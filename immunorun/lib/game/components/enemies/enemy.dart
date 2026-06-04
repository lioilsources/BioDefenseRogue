import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../domain/enemy_archetype.dart';

// Základní třída pro všechny nepřátele — rozšíří se v F1.
abstract class Enemy extends CircleComponent with CollisionCallbacks {
  Enemy({required this.archetype})
      : super(
          radius: archetype.radius,
          anchor: Anchor.center,
          paint:  Paint()..color = const Color(0xFFE74C3C),
        );

  final EnemyArchetype archetype;

  int _hp = 0;

  void init(Vector2 spawnPosition) {
    position = spawnPosition;
    _hp      = archetype.maxHp;
    add(CircleHitbox(radius: archetype.radius, anchor: Anchor.center));
  }

  bool get isDead => _hp <= 0;

  void takeDamage(int amount) {
    _hp = (_hp - amount).clamp(0, archetype.maxHp);
  }
}
