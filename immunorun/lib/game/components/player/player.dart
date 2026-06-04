import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/balance.dart';
import 'player_controller.dart';

class Player extends CircleComponent with CollisionCallbacks {
  Player({required this.controller})
      : super(
          radius: Balance.playerRadius,
          anchor: Anchor.center,
          paint:  Paint()..color = const Color(0xFF5DADE2),
        );

  final PlayerController controller;

  int _hp = Balance.playerMaxHp;
  int get hp => _hp;
  double _logTimer = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(
      radius: Balance.playerRadius,
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    final dir = controller.direction;
    final keys = HardwareKeyboard.instance.logicalKeysPressed;
    _logTimer += dt;
    if (_logTimer >= 1.0) {
      _logTimer = 0;
      debugPrint('[Player] pos=${position.x.toInt()},${position.y.toInt()} '
          'dir=${dir.x.toStringAsFixed(2)},${dir.y.toStringAsFixed(2)} '
          'keys=${keys.map((k) => k.keyLabel).join("+")}');
    }
    if (dir.length2 > 0) {
      position += dir * Balance.playerSpeed * dt;
    }
    _clampToArena();
  }

  void _clampToArena() {
    final r = Balance.playerRadius;
    position.x = position.x.clamp(r, Balance.arenaWidth  - r);
    position.y = position.y.clamp(r, Balance.arenaHeight - r);
  }

  void takeDamage(int amount) {
    _hp = (_hp - amount).clamp(0, Balance.playerMaxHp);
  }
}
