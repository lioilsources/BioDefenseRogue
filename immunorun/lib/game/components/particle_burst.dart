import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';

class _Spark {
  _Spark({required this.vel, required this.color})
      : life = Balance.particleLifetime,
        pos  = Vector2.zero();
  final Vector2 vel;
  final Color   color;
  Vector2 pos;
  double  life;
}

/// Jednorázový výbuch částic. Přidej do world na origin pozici, sám se odstraní.
class ParticleBurst extends PositionComponent {
  ParticleBurst({
    required Vector2 origin,
    required int     count,
    required this.baseColor,
    double speedMul = 1.0,
  }) : super(position: origin) {
    final rng = Random();
    for (var i = 0; i < count; i++) {
      final angle = rng.nextDouble() * 2 * pi;
      final speed = (0.5 + rng.nextDouble() * 0.8) * Balance.particleSpeed * speedMul;
      _sparks.add(_Spark(
        vel:   Vector2(cos(angle), sin(angle)) * speed,
        color: baseColor,
      ));
    }
  }

  final Color       baseColor;
  final List<_Spark> _sparks = [];

  @override
  void update(double dt) {
    bool alive = false;
    for (final s in _sparks) {
      s.life -= dt;
      if (s.life > 0) {
        s.pos += s.vel * dt;
        alive = true;
      }
    }
    if (!alive) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    for (final s in _sparks) {
      if (s.life <= 0) continue;
      final t     = (s.life / Balance.particleLifetime).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = s.color.withValues(alpha: t)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(s.pos.x, s.pos.y), 3.0 * t, paint);
    }
  }
}
