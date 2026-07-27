import 'dart:math';

import 'package:flame/components.dart';

import '../../config/balance.dart';

/// `SpriteComponent` s jemným „plaváním" — nezávislý idle pohyb pro život buňky.
///
/// Moduluje **scale** (nádech/výdech), **angle** (kolébání) a drobný **bob**
/// kolem výchozích hodnot zachycených v `onLoad`. Hýbe jen vizuálem — hitbox je
/// na rodiči (`Player` / `Enemy`), takže gameplay zůstává nedotčen.
///
/// Každá instance má náhodnou fázi + jitter rychlosti, aby se buňky nehýbaly
/// synchronně (bez sdíleného „tepu").
class SwimSprite extends SpriteComponent {
  SwimSprite({
    required super.sprite,
    required super.size,
    super.anchor,
    super.position,
    Random? rng,
  }) {
    final r = rng ?? _shared;
    _phaseBreathe = r.nextDouble() * 2 * pi;
    _phaseSway    = r.nextDouble() * 2 * pi;
    _phaseBobX    = r.nextDouble() * 2 * pi;
    _phaseBobY    = r.nextDouble() * 2 * pi;
    _speedMul     = 1.0 + (r.nextDouble() - 0.5) * 2 * Balance.spriteSwimSpeedJitter;
  }

  static final Random _shared = Random();

  late final double _phaseBreathe;
  late final double _phaseSway;
  late final double _phaseBobX;
  late final double _phaseBobY;
  late final double _speedMul;

  late final Vector2 _baseScale;
  late final double  _baseAngle;
  late final Vector2 _basePosition;
  double _t = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _baseScale    = scale.clone();
    _baseAngle    = angle;
    _basePosition = position.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt * _speedMul;

    // Nádech/výdech — scale kolem výchozí hodnoty
    final breathe = 1.0 +
        Balance.spriteSwimBreatheAmp *
            sin(2 * pi * Balance.spriteSwimBreatheFreq * _t + _phaseBreathe);
    scale = _baseScale * breathe;

    // Kolébání — jemná rotace
    angle = _baseAngle +
        Balance.spriteSwimSwayRad *
            sin(2 * pi * Balance.spriteSwimSwayFreq * _t + _phaseSway);

    // Bob — drobný posun (X a Y s mírně jinou frekvencí → lissajous, ne přímka)
    position = _basePosition +
        Vector2(
          Balance.spriteSwimBobAmp *
              sin(2 * pi * Balance.spriteSwimBobFreq * _t + _phaseBobX),
          Balance.spriteSwimBobAmp *
              sin(2 * pi * Balance.spriteSwimBobFreq * 0.83 * _t + _phaseBobY),
        );
  }
}
