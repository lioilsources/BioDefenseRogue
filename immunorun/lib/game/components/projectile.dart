import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

// Projektil — plná implementace v F1.
class Projectile extends CircleComponent with CollisionCallbacks {
  Projectile()
      : super(
          radius: 6.0,
          anchor: Anchor.center,
          paint:  Paint()..color = const Color(0xFFF1C40F),
        );

  Vector2 velocity = Vector2.zero();

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }
}
