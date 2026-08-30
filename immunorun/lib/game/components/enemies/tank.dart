import 'package:flutter/painting.dart';

import '../../../config/balance.dart';
import '../../../domain/enemy_archetype.dart';
import '../player/player.dart';
import 'enemy.dart';

/// Tank — pomalý, tuhý, vysoký kontaktní dmg, odolný proti knockbacku.
/// Procedurální render (sprite zatím není — viz CREDITS.md).
class Tank extends Enemy {
  Tank({
    required Player player,
    required this.onPlayerContact,
  })  : _player = player,
        super(archetype: tankArchetype);

  final Player _player;
  double       _contactTimer = 0;
  final void Function() onPlayerContact;

  static final Paint _bodyPaint   = Paint()..color = Balance.tankColor;
  static final Paint _borderPaint = Paint()
    ..color = Balance.tankBorderColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0;

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    canvas.drawCircle(center, archetype.radius, _bodyPaint);
    canvas.drawCircle(center, archetype.radius - 2, _borderPaint);
    super.render(canvas); // opsonized ring nad tělem
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    final dir = _player.position - position;
    if (dir.length2 > 1.0) {
      position += dir.normalized() * archetype.speed * statusSpeedMulti * dt;
    }

    final dist = dir.length;
    if (dist < archetype.radius + Balance.playerRadius) {
      _contactTimer -= dt;
      if (_contactTimer <= 0) {
        _contactTimer = Balance.tankContactInterval;
        _player.takeDamage(archetype.contactDamage.round());
        onPlayerContact();
      }
    } else {
      _contactTimer = 0;
    }
  }
}
