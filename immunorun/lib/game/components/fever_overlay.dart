import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';

class FeverOverlayComponent extends PositionComponent
    with HasGameReference<FlameGame> {
  FeverOverlayComponent() : super(position: Vector2.zero(), priority: 100);

  ui.FragmentShader? _shader;
  double _time  = 0.0;
  double _fever = 0.0;  // 0..1 normalizováno

  void applyShader(ui.FragmentProgram program) {
    _shader = program.fragmentShader();
  }

  void setFever(double normalized) => _fever = normalized.clamp(0.0, 1.0);

  @override
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void update(double dt) => _time += dt;

  @override
  void render(Canvas canvas) {
    final s = _shader;
    if (s == null || _fever < 0.05) return;

    s
      ..setFloat(0, size.x)
      ..setFloat(1, size.y)
      ..setFloat(2, _time)
      ..setFloat(3, _fever);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..shader = s,
    );
  }
}
