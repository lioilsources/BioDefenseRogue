import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';

/// Jeden vzorek dráhy: absolutní world pozice, stáří a rychlost při zachycení.
class _TrailPoint {
  _TrailPoint(this.pos, this.speed);
  final Vector2 pos;
  final double  speed; // px/s — rychlejší pohyb = tlustší/výraznější stopa
  double age = 0;      // s od zachycení
}

/// Fade-out stopa za hráčem. Dělá pohyb (hlavně dash) čitelným.
///
/// Renderuje se v world-space (komponenta stojí na (0,0)), takže kreslí přímo
/// na absolutní pozice hráče. Přidej do world **pod** hráče (dřív v pořadí).
class MovementTrail extends PositionComponent {
  MovementTrail({required this.positionGetter});

  /// Zdroj aktuální pozice (hráč). Voláno každý frame.
  final Vector2 Function() positionGetter;

  final List<_TrailPoint> _points = [];

  /// Smaž stopu — volej při teleportu hráče (přechod místnosti, restart),
  /// jinak by vznikl jeden dlouhý pruh přes celou arénu.
  void clear() => _points.clear();

  @override
  void update(double dt) {
    // Stárnutí + odstranění dožitých bodů
    for (final p in _points) {
      p.age += dt;
    }
    _points.removeWhere((p) => p.age >= Balance.trailLifetime);

    if (dt <= 0) return;

    // Zachyť nový bod, jen když se hráč posunul dost daleko (nezaneřádit stáním)
    final cur = positionGetter();
    if (_points.isEmpty) {
      _points.add(_TrailPoint(cur.clone(), 0));
      return;
    }
    final last = _points.last;
    final d    = (cur - last.pos).length;
    if (d >= Balance.trailMinSpacing) {
      _points.add(_TrailPoint(cur.clone(), d / dt));
    }
  }

  @override
  void render(Canvas canvas) {
    if (_points.length < 2) return;

    // Nejstarší → nejnovější, aby čerstvé segmenty ležely navrchu
    for (var i = 0; i < _points.length - 1; i++) {
      final a = _points[i];
      final b = _points[i + 1];

      final gap = (b.pos - a.pos).length;
      if (gap > Balance.trailMaxSegment) continue; // teleport — nespojuj

      final fa = 1.0 - (a.age / Balance.trailLifetime).clamp(0.0, 1.0);
      final fb = 1.0 - (b.age / Balance.trailLifetime).clamp(0.0, 1.0);
      final fresh = (fa + fb) * 0.5;

      // Rychlost normalizovaná dle dash rychlosti → dash = tlustší jasný pruh
      final speedN =
          (b.speed / Balance.dashSpeed).clamp(0.0, 1.0);
      final width = _lerp(Balance.trailBaseWidth, Balance.trailMaxWidth, speedN) *
          fresh;
      final alpha = Balance.trailMaxAlpha * fresh;

      final paint = Paint()
        ..color       = Balance.trailColor.withValues(alpha: alpha)
        ..strokeWidth = width
        ..strokeCap   = StrokeCap.round
        ..style       = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(a.pos.x, a.pos.y),
        Offset(b.pos.x, b.pos.y),
        paint,
      );
    }
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}
