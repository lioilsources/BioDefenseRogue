import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';
import '../systems/wave_controller.dart';

class ArenaComponent extends PositionComponent {
  ArenaComponent()
      : super(
          size:     Vector2(Balance.arenaWidth, Balance.arenaHeight),
          position: Vector2.zero(),
        );

  WavePhase phase = WavePhase.countdown;

  static final _borderPaint = Paint()
    ..color = const Color(0xFF2ECC71)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0;

  static final _bgPaint = Paint()..color = const Color(0xFF0D1F0D);

  static final _gridPaint = Paint()
    ..color = const Color(0xFF1A3D1A)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  static const double _gridStep = 200.0;

  @override
  void render(Canvas canvas) {
    final w = Balance.arenaWidth;
    final h = Balance.arenaHeight;
    final rect = Rect.fromLTWH(0, 0, w, h);

    canvas.drawRect(rect, _bgPaint);

    // grid
    for (double x = 0; x <= w; x += _gridStep) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), _gridPaint);
    }
    for (double y = 0; y <= h; y += _gridStep) {
      canvas.drawLine(Offset(0, y), Offset(w, y), _gridPaint);
    }

    canvas.drawRect(rect, _borderPaint);
    _drawGates(canvas, w, h);
  }

  void _drawGates(Canvas canvas, double w, double h) {
    final locked = phase == WavePhase.active;
    final gateColor = locked
        ? const Color(0xCCE74C3C)  // červená — zamčeno
        : const Color(0x882ECC71); // zelená — otevřeno
    final gatePaint = Paint()..color = gateColor;

    final g = Balance.gateSize;
    const t = 16.0; // tloušťka brány

    // Severní brána (top)
    canvas.drawRect(Rect.fromLTWH(w / 2 - g / 2, 0, g, t), gatePaint);
    // Jižní brána (bottom)
    canvas.drawRect(Rect.fromLTWH(w / 2 - g / 2, h - t, g, t), gatePaint);
    // Západní brána (left)
    canvas.drawRect(Rect.fromLTWH(0, h / 2 - g / 2, t, g), gatePaint);
    // Východní brána (right)
    canvas.drawRect(Rect.fromLTWH(w - t, h / 2 - g / 2, t, g), gatePaint);

    // ikona zámku / šipky
    final iconPaint = Paint()
      ..color = locked
          ? const Color(0xFFE74C3C)
          : const Color(0xFF2ECC71)
      ..style = PaintingStyle.fill;
    const r = 8.0;
    canvas.drawCircle(Offset(w / 2, t / 2), r, iconPaint);
    canvas.drawCircle(Offset(w / 2, h - t / 2), r, iconPaint);
    canvas.drawCircle(Offset(t / 2, h / 2), r, iconPaint);
    canvas.drawCircle(Offset(w - t / 2, h / 2), r, iconPaint);
  }
}
