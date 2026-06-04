import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../domain/enemy_archetype.dart';

abstract class Enemy extends CircleComponent with CollisionCallbacks {
  Enemy({required this.archetype})
      : super(
          radius: archetype.radius,
          anchor: Anchor.center,
          paint:  Paint()..color = const Color(0xFFE74C3C),
        );

  final EnemyArchetype archetype;
  late int _hp;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _hp = archetype.maxHp;
    add(CircleHitbox(radius: archetype.radius, anchor: Anchor.center));
  }

  bool get isDead => _hp <= 0;
  int  get hp     => _hp;

  void takeDamage(int amount) {
    if (isDead) return;
    _hp = (_hp - amount).clamp(0, archetype.maxHp);
    if (isDead) removeFromParent();
  }
}
