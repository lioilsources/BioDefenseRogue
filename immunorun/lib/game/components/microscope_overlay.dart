import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';

class MicroscopeOverlayComponent extends PositionComponent
    with HasGameReference<FlameGame> {
  // Priority 90 — pod fever overlayem (100), varování horečky musí zůstat navrchu.
  MicroscopeOverlayComponent() : super(position: Vector2.zero(), priority: 90);

  ui.FragmentShader? _shader;
  double _time = 0.0;

  void applyShader(ui.FragmentProgram program) {
    _shader = program.fragmentShader();
  }

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
    if (s == null) return;

    s
      ..setFloat(0, size.x)
      ..setFloat(1, size.y)
      ..setFloat(2, _time)
      ..setFloat(3, Balance.microscopeIntensity);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..shader = s,
    );
  }
}
