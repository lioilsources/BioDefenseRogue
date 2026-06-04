import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';

// Paralaxní vrstva — velikost arény, shader animuje nezávisle.
class _ParallaxLayer extends PositionComponent {
  _ParallaxLayer({required this.scrollFactor, required this.alpha})
      : super(
          size:     Vector2(Balance.arenaWidth, Balance.arenaHeight),
          position: Vector2.zero(),
        );

  final double          scrollFactor;
  final double          alpha;
  ui.FragmentShader?    _shader;
  double                _time = 0.0;

  void setShader(ui.FragmentShader shader) => _shader = shader;

  @override
  void update(double dt) => _time += dt;

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, Balance.arenaWidth, Balance.arenaHeight);
    final s    = _shader;

    if (s == null) {
      canvas.drawRect(
        rect,
        Paint()..color = Color.fromARGB((alpha * 80).toInt(), 8, 35, 12),
      );
      return;
    }

    s
      ..setFloat(0, Balance.arenaWidth)
      ..setFloat(1, Balance.arenaHeight)
      ..setFloat(2, _time + scrollFactor * 100.0);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = s
        ..color  = Color.fromARGB((alpha * 255).toInt(), 255, 255, 255),
    );
  }
}

class BackgroundLayer extends Component {
  final List<_ParallaxLayer> _layers = [];

  void applyShader(ui.FragmentProgram program) {
    for (final layer in _layers) {
      layer.setShader(program.fragmentShader());
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    for (final (factor, alpha) in Balance.parallaxLayers) {
      final layer = _ParallaxLayer(scrollFactor: factor, alpha: alpha);
      _layers.add(layer);
      await add(layer);
    }
  }
}
