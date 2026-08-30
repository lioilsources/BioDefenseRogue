import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../config/balance.dart';
import '../../../domain/enemy_archetype.dart';
import '../../../domain/status_effects.dart';
import '../particle_burst.dart';

abstract class Enemy extends CircleComponent with CollisionCallbacks {
  Enemy({required this.archetype})
      : super(
          radius: archetype.radius,
          anchor: Anchor.center,
          paint:  Paint()..color = const Color(0x00000000),
        );

  final EnemyArchetype archetype;
  late int _hp;

  // Knockback
  Vector2 _knockVelocity = Vector2.zero();

  // Status efekty (opsonized, slowed, …)
  final List<ActiveStatus> _statuses = [];

  static final Paint _opsonizedPaint = Paint()
    ..color = Balance.opsonizedRingColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5;

  // Callbacks
  void Function()? onHitCallback;
  // Volaný při přirozené smrti — pool.release() nebo removeFromParent()
  void Function()? onDeath;
  // Volaný při smrti PŘED onDeath — drop ATP na pozici
  void Function(Vector2 pos, EnemyArchetype archetype)? onDrop;

  bool _componentsLoaded = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _hp = archetype.maxHp;
    if (!_componentsLoaded) {
      _componentsLoaded = true;
      add(CircleHitbox(radius: archetype.radius, anchor: Anchor.center));
    }
  }

  void resetEnemy() {
    _hp             = archetype.maxHp;
    _knockVelocity  = Vector2.zero();
    _statuses.clear();
    onHitCallback   = null;
    onDeath         = null;
    onDrop          = null;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_knockVelocity.length2 > 1.0) {
      position += _knockVelocity * dt;
      _knockVelocity *= (1.0 - Balance.knockbackDecay * dt).clamp(0.0, 1.0);
    }
    // Odtikej trvání statusů
    for (final s in _statuses) {
      s.duration -= dt;
    }
    _statuses.removeWhere((s) => s.duration <= 0);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (hasStatus(StatusEffect.opsonized)) {
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        archetype.radius + 4,
        _opsonizedPaint,
      );
    }
  }

  bool get isDead => _hp <= 0;
  int  get hp     => _hp;

  bool hasStatus(StatusEffect effect) =>
      _statuses.any((s) => s.effect == effect);

  /// Multiplikátor rychlosti pohybu podle statusů (slowed).
  double get statusSpeedMulti => speedMultiOf(_statuses);

  /// Aplikuj status — reaplikace obnoví trvání.
  void applyStatus(StatusEffect effect) {
    final duration = statusBaseDuration(effect);
    if (duration <= 0) return;
    for (final s in _statuses) {
      if (s.effect == effect) {
        s.duration = duration;
        return;
      }
    }
    _statuses.add(ActiveStatus(effect: effect, duration: duration));
  }

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
    final effective = (amount * damageTakenMultiOf(_statuses)).round();
    _hp = (_hp - effective).clamp(0, archetype.maxHp);
    if (hitDir != null) {
      _knockVelocity = hitDir.normalized() *
          Balance.knockbackImpulse * (1.0 - archetype.knockbackResist);
    }
    onHitCallback?.call();
    _spawnParticles(isDead);
    if (isDead) {
      onDrop?.call(position.clone(), archetype);
      onDrop = null;
      final cb = onDeath;
      onDeath = null;
      cb != null ? cb() : removeFromParent();
    }
  }
}
