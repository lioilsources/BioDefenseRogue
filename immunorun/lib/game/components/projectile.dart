import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';
import 'enemies/enemy.dart';

class Projectile extends CircleComponent with CollisionCallbacks {
  Projectile({required this.velocity})
      : super(
          radius: 6.0,
          anchor: Anchor.center,
          paint:  Paint()..color = const Color(0xFFF1C40F),
        );

  final Vector2 velocity;
  double _life = Balance.projectileLifetime;

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
      other.takeDamage(Balance.projectileDamage.round());
      removeFromParent();
    }
  }
}
