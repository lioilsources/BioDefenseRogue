import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/balance.dart';
import '../enemies/enemy.dart';
import '../projectile.dart';
import 'player_controller.dart';

// Callback volaný při použití zánětlivé schopnosti (pro FeverController)
typedef AbilityCallback = void Function();

class Player extends CircleComponent with CollisionCallbacks {
  Player({required this.controller})
      : super(
          radius: Balance.playerRadius,
          anchor: Anchor.center,
          paint:  Paint()..color = const Color(0x00000000),
        );

  final PlayerController controller;

  // HP
  int _hp = Balance.playerMaxHp;
  int get hp => _hp;
  bool get isDead => _hp <= 0;

  // i-frames (dash + hit)
  double _invulnerableTimer = 0;
  bool get isInvulnerable => _invulnerableTimer > 0;

  // ── Dash (nábojový systém) ──────────────────────────────────────────────
  double  _dashCharges = Balance.dashMaxCharges.toDouble();
  double  _dashLockout = 0;         // minimální rozestup dvou dashů
  bool    _dashing     = false;
  double  _dashTimer   = 0;
  double  _dashSpeed   = 0;
  Vector2 _dashDir     = Vector2.zero();
  // Průjezdový damage (charge dash) — 0 = běžný dash bez dmg
  double  _dashDamage    = 0;
  double  _dashHitRadius = 0;
  final Set<Enemy> _dashHits = {}; // aby charge dash nezasáhl týž cíl vícekrát
  bool    _spaceWasDown = false;

  // ATP / special ability
  double _atp        = Balance.atpMax;
  bool   _eWasDown   = false;
  double get atp     => _atp;
  double get atpNorm => _atp / Balance.atpMax;

  /// Voláno při použití zánětlivé schopnosti — FeverController.onAbility()
  AbilityCallback? onAbilityUsed;

  // Auto-aim / primary weapon
  double _fireCooldown = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: Balance.playerRadius, anchor: Anchor.center));
    final sprite = await Sprite.load('cells/macrophage.png');
    final h      = Balance.playerSpriteHeight;
    final aspect = sprite.srcSize.x / sprite.srcSize.y;
    add(SpriteComponent(
      sprite: sprite,
      size:   Vector2(h * aspect, h),
      anchor: Anchor.center,
    ));
    _publishCharges();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _updateTimers(dt);
    _processActions();     // gesta + klávesnicové edge-triggery → dash/combos
    _updateDashMotion(dt); // posun probíhajícího dashe (+ průjezdový dmg)

    if (!_dashing) {
      final move = _movementVector();
      if (move.length2 > 0) position += move * dt;
    }

    _tryFire(dt);
    _clampToArena();
  }

  // ─── Pohyb ────────────────────────────────────────────────────────────────

  /// Klávesnice (plný pohyb) má přednost, jinak drift (pomalé doladění, mobil).
  Vector2 _movementVector() {
    final kb = controller.keyboardVector;
    if (kb.length2 > 0) return kb.normalized() * Balance.playerSpeed;

    final drift = controller.driftDelta;
    if (drift.length2 > 0) {
      final mag = drift.length.clamp(0.0, 1.0);
      return drift.normalized() * (Balance.driftSpeed * mag);
    }
    return Vector2.zero();
  }

  // ─── Akce (dash / combos) ──────────────────────────────────────────────────

  void _processActions() {
    // Gesta z overlaye
    for (final a in controller.drainActions()) {
      switch (a.kind) {
        case PlayerActionKind.dash:
          _tryDash(a.dir ?? controller.aimDirection);
        case PlayerActionKind.chargeDash:
          _tryChargeDash(a.dir ?? controller.aimDirection);
        case PlayerActionKind.juke:
          _tryJuke();
        case PlayerActionKind.aoe:
          _tryAoe();
      }
    }

    // Desktop klávesnice: Space = dash, E = AoE nova
    final keys = HardwareKeyboard.instance.logicalKeysPressed;

    final spaceDown = keys.contains(LogicalKeyboardKey.space);
    if (spaceDown && !_spaceWasDown) _tryDash(controller.aimDirection);
    _spaceWasDown = spaceDown;

    final eDown = keys.contains(LogicalKeyboardKey.keyE);
    if (eDown && !_eWasDown) _tryAoe();
    _eWasDown = eDown;
  }

  void _tryDash(Vector2 dir) {
    if (_dashing || _dashLockout > 0) return;
    if (_dashCharges < 1) return;
    _spendCharges(1);
    _startDash(
      dir:       dir,
      speed:     Balance.dashSpeed,
      duration:  Balance.dashDuration,
      iframes:   Balance.dashIframes,
    );
  }

  void _tryChargeDash(Vector2 dir) {
    if (_dashing || _dashLockout > 0) return;
    if (_dashCharges < Balance.chargeDashCost) {
      _tryDash(dir); // málo nábojů → aspoň běžný dash
      return;
    }
    _spendCharges(Balance.chargeDashCost);
    _startDash(
      dir:       dir,
      speed:     Balance.chargeDashSpeed,
      duration:  Balance.chargeDashDuration,
      iframes:   Balance.chargeDashIframes,
      damage:    Balance.chargeDashDamage,
      hitRadius: Balance.chargeDashHitRadius,
    );
  }

  void _startDash({
    required Vector2 dir,
    required double speed,
    required double duration,
    required double iframes,
    double damage    = 0,
    double hitRadius = 0,
  }) {
    _dashDir           = dir.length2 > 0 ? dir.normalized() : Vector2(0, -1);
    _dashing           = true;
    _dashTimer         = duration;
    _dashSpeed         = speed;
    _dashDamage        = damage;
    _dashHitRadius     = hitRadius;
    _dashLockout       = Balance.dashInputLockout;
    _invulnerableTimer = max(_invulnerableTimer, iframes);
    _dashHits.clear();
  }

  void _updateDashMotion(double dt) {
    if (!_dashing) return;
    _dashTimer -= dt;
    position += _dashDir * _dashSpeed * dt;

    if (_dashDamage > 0) _applyDashPassThrough();

    if (_dashTimer <= 0) {
      _dashing    = false;
      _dashDamage = 0;
    }
  }

  /// Charge dash: zásah nepřátel v dosahu při průjezdu (každý jen jednou).
  void _applyDashPassThrough() {
    final enemies = parent?.children.whereType<Enemy>();
    if (enemies == null) return;
    final r2 = _dashHitRadius * _dashHitRadius;
    for (final e in enemies) {
      if (e.isDead || _dashHits.contains(e)) continue;
      if ((e.position - position).length2 <= r2) {
        _dashHits.add(e);
        e.takeDamage(_dashDamage.round(), hitDir: _dashDir);
      }
    }
  }

  void _tryJuke() {
    if (_dashCharges < Balance.jukeCost) return;
    _spendCharges(Balance.jukeCost);
    _invulnerableTimer = max(_invulnerableTimer, Balance.jukeIframes);

    // Odrazová pulzace: knockback + malý dmg okolním nepřátelům
    final enemies = parent?.children.whereType<Enemy>();
    if (enemies == null) return;
    final r2 = Balance.jukePulseRadius * Balance.jukePulseRadius;
    for (final e in enemies.toList()) {
      if (e.isDead) continue;
      final delta = e.position - position;
      if (delta.length2 <= r2) {
        e.takeDamage(Balance.jukePulseDamage, hitDir: delta);
      }
    }
  }

  void _tryAoe() {
    if (_atp < Balance.atpSpecialCost) return;
    _atp -= Balance.atpSpecialCost;
    onAbilityUsed?.call();
    _fireRadialNova();
  }

  void _spendCharges(int n) {
    _dashCharges = (_dashCharges - n).clamp(0.0, Balance.dashMaxCharges.toDouble());
    _publishCharges();
  }

  int _lastPublishedCharges = -1;
  void _publishCharges() {
    final c = _dashCharges.floor();
    if (c != _lastPublishedCharges) {
      _lastPublishedCharges = c;
      controller.dashCharges.value = c;
    }
  }

  // ─── Damage ──────────────────────────────────────────────────────────────

  void takeDamage(int amount) {
    if (isInvulnerable || isDead) return;
    _hp = (_hp - amount).clamp(0, Balance.playerMaxHp);
    _invulnerableTimer = max(_invulnerableTimer, Balance.hitInvulnerability);
  }

  void heal(int amount) {
    _hp = (_hp + amount).clamp(0, Balance.playerMaxHp);
  }

  void reset() {
    _hp                = Balance.playerMaxHp;
    _invulnerableTimer = 0;
    _dashing           = false;
    _dashTimer         = 0;
    _dashDamage        = 0;
    _dashLockout       = 0;
    _dashCharges       = Balance.dashMaxCharges.toDouble();
    _dashHits.clear();
    _fireCooldown      = 0;
    _atp               = Balance.atpMax;
    _publishCharges();
  }

  // ─── Internal ────────────────────────────────────────────────────────────

  void _updateTimers(double dt) {
    if (_invulnerableTimer > 0) _invulnerableTimer -= dt;
    if (_dashLockout > 0)       _dashLockout       -= dt;
    if (_fireCooldown > 0)      _fireCooldown      -= dt;
    if (_atp < Balance.atpMax) {
      _atp = (_atp + Balance.atpRegen * dt).clamp(0, Balance.atpMax);
    }
    if (_dashCharges < Balance.dashMaxCharges) {
      _dashCharges = (_dashCharges + dt / Balance.dashChargeRegenTime)
          .clamp(0.0, Balance.dashMaxCharges.toDouble());
      _publishCharges();
    }
  }

  void _tryFire(double dt) {
    if (_fireCooldown > 0) return;

    final enemies = parent?.children.whereType<Enemy>().toList();
    if (enemies == null || enemies.isEmpty) return;

    Enemy? nearest;
    double nearestDist = Balance.primaryRange;
    for (final e in enemies) {
      if (e.isDead) continue;
      final d = (e.position - position).length;
      if (d < nearestDist) {
        nearestDist = d;
        nearest = e;
      }
    }
    if (nearest == null) return;

    _fireCooldown = 1.0 / Balance.primaryFireRate;
    final dir  = (nearest.position - position).normalized();
    final proj = Projectile(velocity: dir * Balance.projectileSpeed)
      ..position = position.clone();
    parent?.add(proj);
  }

  /// Radiální nova — projektily rovnoměrně po celém kruhu (kruhové gesto / E).
  void _fireRadialNova() {
    final count = Balance.aoeNovaCount;
    for (var i = 0; i < count; i++) {
      final angle = (i / count) * 2 * pi;
      final dir   = Vector2(cos(angle), sin(angle));
      parent?.add(
        Projectile(
          velocity: dir * Balance.specialSpeed,
          damage:   Balance.specialDamage,
          radius:   Balance.specialRadius,
          color:    const Color(0xFF3498DB),
          lifetime: Balance.specialLifetime,
        )..position = position.clone(),
      );
    }
  }

  void _clampToArena() {
    final r = Balance.playerRadius;
    position.x = position.x.clamp(r, Balance.arenaWidth  - r);
    position.y = position.y.clamp(r, Balance.arenaHeight - r);
  }
}
