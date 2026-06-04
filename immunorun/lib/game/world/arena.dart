import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';

class ArenaComponent extends PositionComponent {
  ArenaComponent()
      : super(
          size:     Vector2(Balance.arenaWidth, Balance.arenaHeight),
          position: Vector2.zero(),
        );

  static final _borderPaint = Paint()
    ..color = const Color(0xFF2ECC71)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0;

  static final _bgPaint = Paint()
    ..color = const Color(0xFF0D1F0D);

  static final _gridPaint = Paint()
    ..color = const Color(0xFF1A3D1A)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  static const double _gridStep = 200.0;

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, Balance.arenaWidth, Balance.arenaHeight);
    canvas.drawRect(rect, _bgPaint);

    for (double x = 0; x <= Balance.arenaWidth; x += _gridStep) {
      canvas.drawLine(Offset(x, 0), Offset(x, Balance.arenaHeight), _gridPaint);
    }
    for (double y = 0; y <= Balance.arenaHeight; y += _gridStep) {
      canvas.drawLine(Offset(0, y), Offset(Balance.arenaWidth, y), _gridPaint);
    }

    canvas.drawRect(rect, _borderPaint);
  }
}
