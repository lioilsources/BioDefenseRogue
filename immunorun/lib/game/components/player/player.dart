import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/balance.dart';
import '../enemies/enemy.dart';
import '../projectile.dart';
import 'player_controller.dart';

class Player extends CircleComponent with CollisionCallbacks {
  Player({required this.controller})
      : super(
          radius: Balance.playerRadius,
          anchor: Anchor.center,
          paint:  Paint()..color = const Color(0xFF5DADE2),
        );

  final PlayerController controller;

  // HP
  int _hp = Balance.playerMaxHp;
  int get hp => _hp;
  bool get isDead => _hp <= 0;

  // i-frames (dash + hit)
  double _invulnerableTimer = 0;
  bool get isInvulnerable => _invulnerableTimer > 0;

  // Dash
  bool   _dashing         = false;
  double _dashTimer        = 0;
  double _dashCooldown     = 0;
  Vector2 _dashDir         = Vector2.zero();
  bool   _spaceWasDown     = false;

  // Auto-aim / primary weapon
  double _fireCooldown = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: Balance.playerRadius, anchor: Anchor.center));
  }

  @override
  void update(double dt) {
    super.update(dt);

    _updateTimers(dt);
    _updateDash(dt);

    if (!_dashing) {
      final dir = controller.direction;
      if (dir.length2 > 0) {
        position += dir * Balance.playerSpeed * dt;
      }
    }

    _tryFire(dt);
    _clampToArena();
  }

  // ─── Damage ──────────────────────────────────────────────────────────────

  void takeDamage(int amount) {
    if (isInvulnerable || isDead) return;
    _hp = (_hp - amount).clamp(0, Balance.playerMaxHp);
    _invulnerableTimer = max(_invulnerableTimer, Balance.hitInvulnerability);
  }

  void reset() {
    _hp              = Balance.playerMaxHp;
    _invulnerableTimer = 0;
    _dashing         = false;
    _dashTimer       = 0;
    _dashCooldown    = 0;
    _fireCooldown    = 0;
  }

  // ─── Internal ────────────────────────────────────────────────────────────

  void _updateTimers(double dt) {
    if (_invulnerableTimer > 0) _invulnerableTimer -= dt;
    if (_dashCooldown > 0)      _dashCooldown      -= dt;
    if (_fireCooldown > 0)      _fireCooldown      -= dt;
  }

  void _updateDash(double dt) {
    final spaceDown = HardwareKeyboard.instance.logicalKeysPressed
        .contains(LogicalKeyboardKey.space);
    final justPressed = spaceDown && !_spaceWasDown;
    _spaceWasDown = spaceDown;

    if (_dashing) {
      _dashTimer -= dt;
      position += _dashDir * Balance.dashSpeed * dt;
      if (_dashTimer <= 0) _dashing = false;
      return;
    }

    if (justPressed && _dashCooldown <= 0) {
      final dir = controller.direction;
      _dashDir         = dir.length2 > 0 ? dir.normalized() : Vector2(0, -1);
      _dashing         = true;
      _dashTimer       = Balance.dashDuration;
      _dashCooldown    = Balance.dashCooldown;
      _invulnerableTimer = max(_invulnerableTimer, Balance.dashIframes);
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

  void _clampToArena() {
    final r = Balance.playerRadius;
    position.x = position.x.clamp(r, Balance.arenaWidth  - r);
    position.y = position.y.clamp(r, Balance.arenaHeight - r);
  }
}
