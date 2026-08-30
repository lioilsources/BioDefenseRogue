import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';
import '../../domain/status_effects.dart';
import 'enemies/enemy.dart';

class Projectile extends CircleComponent with CollisionCallbacks {
  Projectile({
    required this.velocity,
    this.damage  = Balance.projectileDamage,
    double radius    = 6.0,
    Color  color     = Balance.projectileColor,
    double lifetime  = Balance.projectileLifetime,
    this.applyOnHit  = const [],
  })  : _life = lifetime,
        super(
          radius: radius,
          anchor: Anchor.center,
          paint:  Paint()..color = color,
        );

  final Vector2 velocity;
  final double  damage;
  final List<StatusEffect> applyOnHit; // statusy aplikované při zásahu
  double _life;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: radius, anchor: Anchor.center));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    _life -= dt;
    if (_life <= 0) removeFromParent();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      // Status před dmg — opsonizace zesílí už tento zásah
      for (final effect in applyOnHit) {
        other.applyStatus(effect);
      }
      other.takeDamage(
        damage.round(),
        hitDir: velocity.normalized(),
      );
      removeFromParent();
    }
  }
}
