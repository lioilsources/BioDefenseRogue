import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../config/balance.dart';
import '../../../domain/enemy_archetype.dart';
import '../../systems/fever_controller.dart';
import '../player/player.dart';
import 'enemy.dart';

class MiniBoss extends Enemy {
  MiniBoss({
    required this.player,
    required this.feverGetter,
    required this.onPlayerContact,
  }) : super(archetype: bossArchetype);

  final Player                  player;
  final FeverSnapshot Function() feverGetter;
  final void Function()          onPlayerContact;

  int    _phase        = 1;
  double _orbitAngle   = 0;
  double _fireCooldown = 0;
  double _contactTimer = 0;

  static final _orbitCenter = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);

  static final _phase1Paint = Paint()..color = const Color(0xFFFF8C00);
  static final _phase2Paint = Paint()..color = const Color(0xFFCC1100);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    paint = _phase1Paint;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;
    _checkPhaseTransition();
    _updateOrbit(dt);
    _updateFire(dt);
    _checkContactDamage(dt);
  }

  void _checkPhaseTransition() {
    if (_phase != 1) return;
    final hpFrac = hp / archetype.maxHp;
    final fever  = feverGetter().tempC;
    if (hpFrac <= Balance.bossPhase2HpFraction || fever >= Balance.bossFeverTrigger) {
      _phase = 2;
      paint  = _phase2Paint;
    }
  }

  void _updateOrbit(double dt) {
    final speed = _phase == 1
        ? Balance.bossPhase1OrbitSpeed
        : Balance.bossPhase2OrbitSpeed;
    _orbitAngle += speed / Balance.bossOrbitRadius * dt;
    position = _orbitCenter +
        Vector2(cos(_orbitAngle), sin(_orbitAngle)) * Balance.bossOrbitRadius;
  }

  void _updateFire(double dt) {
    _fireCooldown -= dt;
    if (_fireCooldown > 0) return;
    final rate    = _phase == 1 ? Balance.bossPhase1FireRate : Balance.bossPhase2FireRate;
    _fireCooldown = 1.0 / rate;
    _fireAtPlayer();
  }

  void _fireAtPlayer() {
    final dir = (player.position - position).normalized();
    // offset za okraj hitboxu, aby projektil nezačínal uvnitř šéfa
    final spawnPos = position + dir * (archetype.radius + Balance.bossProjectileRadius + 2);

    _spawnProjectile(spawnPos, dir);

    if (_phase == 2) {
      for (final spread in [-Balance.bossPhase2Spread, Balance.bossPhase2Spread]) {
        final s = sin(spread);
        final c = cos(spread);
        final spreadDir = Vector2(
          dir.x * c - dir.y * s,
          dir.x * s + dir.y * c,
        );
        _spawnProjectile(spawnPos, spreadDir);
      }
    }
  }

  void _spawnProjectile(Vector2 pos, Vector2 dir) {
    parent?.add(
      BossProjectile(
        velocity:        dir * Balance.bossProjectileSpeed,
        player:          player,
        onPlayerContact: onPlayerContact,
      )..position = pos.clone(),
    );
  }

  void _checkContactDamage(double dt) {
    final dist = (player.position - position).length;
    if (dist < archetype.radius + Balance.playerRadius) {
      _contactTimer -= dt;
      if (_contactTimer <= 0) {
        _contactTimer = Balance.swarmerContactInterval;
        player.takeDamage(archetype.contactDamage.round());
        onPlayerContact();
      }
    } else {
      _contactTimer = 0;
    }
  }
}

// ── Projektil šéfa ────────────────────────────────────────────────────────

class BossProjectile extends CircleComponent with CollisionCallbacks {
  BossProjectile({
    required this.velocity,
    required this.player,
    required this.onPlayerContact,
  }) : super(
          radius: Balance.bossProjectileRadius,
          anchor: Anchor.center,
          paint:  Paint()..color = const Color(0xFFE74C3C),
        );

  final Vector2      velocity;
  final Player       player;
  final void Function() onPlayerContact;

  double _life = Balance.bossProjectileLife;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: Balance.bossProjectileRadius, anchor: Anchor.center));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    _life -= dt;
    if (_life <= 0) removeFromParent();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      other.takeDamage(Balance.bossProjectileDamage.round());
      onPlayerContact();
      removeFromParent();
    }
    // Enemy (včetně MiniBoss) ignorujeme — projektil projde skrz
  }
}
