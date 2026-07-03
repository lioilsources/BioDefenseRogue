import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';
import 'enemies/enemy.dart';

class Projectile extends CircleComponent with CollisionCallbacks {
  Projectile({
    required this.velocity,
    this.damage  = Balance.projectileDamage,
    double radius    = 6.0,
    Color  color     = const Color(0xFFF1C40F),
    double lifetime  = Balance.projectileLifetime,
  })  : _life = lifetime,
        super(
          radius: radius,
          anchor: Anchor.center,
          paint:  Paint()..color = color,
        );

  final Vector2 velocity;
  final double  damage;
  double _life;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: 6.0, anchor: Anchor.center));
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
      other.takeDamage(
        damage.round(),
        hitDir: velocity.normalized(),
      );
      removeFromParent();
    }
  }
}
