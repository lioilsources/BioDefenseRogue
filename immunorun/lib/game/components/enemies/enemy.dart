import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../config/balance.dart';
import '../../../domain/enemy_archetype.dart';
import '../particle_burst.dart';

abstract class Enemy extends CircleComponent with CollisionCallbacks {
  Enemy({required this.archetype})
      : super(
          radius: archetype.radius,
          anchor: Anchor.center,
          paint:  Paint()..color = const Color(0xFFE74C3C),
        );

  final EnemyArchetype archetype;
  late int _hp;

  // Knockback
  Vector2 _knockVelocity = Vector2.zero();

  // Callback volaný při zásahu — ImmunoGame ho napojí na hit-stop
  void Function()? onHitCallback;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _hp = archetype.maxHp;
    add(CircleHitbox(radius: archetype.radius, anchor: Anchor.center));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_knockVelocity.length2 > 1.0) {
      position += _knockVelocity * dt;
      _knockVelocity *= (1.0 - Balance.knockbackDecay * dt).clamp(0.0, 1.0);
    }
  }

  bool get isDead => _hp <= 0;
  int  get hp     => _hp;

  void _spawnParticles(bool death) {
    final burst = ParticleBurst(
      origin:   position.clone(),
      count:    death ? Balance.deathParticleCount : Balance.hitParticleCount,
      baseColor: death
          ? const Color(0xFFE74C3C)   // červená při smrti
          : const Color(0xFFF39C12),  // oranžová při hitu
      speedMul: death ? 1.4 : 0.7,
    );
    parent?.add(burst);
  }

  void takeDamage(int amount, {Vector2? hitDir}) {
    if (isDead) return;
    _hp = (_hp - amount).clamp(0, archetype.maxHp);
    if (hitDir != null) {
      _knockVelocity = hitDir.normalized() * Balance.knockbackImpulse;
    }
    onHitCallback?.call();
    _spawnParticles(isDead);
    if (isDead) removeFromParent();
  }
}
