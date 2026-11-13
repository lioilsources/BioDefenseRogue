import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';

/// Ikony herních entit v `assets/images/icons/`. Jediné místo s jejich id;
/// [all] se přednačítá v `ImmunoGame.onLoad`, aby `onLoad` entit nečekal na dekódování.
abstract final class GameIcons {
  static const makrofag        = 'makrofag';
  static const kok             = 'kok';
  static const biofilm         = 'biofilm';
  static const stafylokok      = 'stafylokok';
  static const stafylokokFaze2 = 'stafylokok-faze2';

  static const all = [makrofag, kok, biofilm, stafylokok, stafylokokFaze2];

  /// Cesta relativní k `assets/images/` (konvence Flame `Images`).
  static String path(String id) => 'icons/$id.webp';
}

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
    // Ikony mají 512 px a kreslí se na 36–96 pt. Výchozí FilterQuality.none
    // (nejbližší soused) z fotky dělá zrno, které se při plavání třpytí.
    paint.filterQuality = FilterQuality.medium;
  }

  /// Čtvercová ikona z `assets/images/icons/<id>.webp`, vystředěná na [center]
  /// (souřadnice rodiče začínají v jeho levém horním rohu, ne ve středu).
  static Future<SwimSprite> icon(
    String id, {
    required double height,
    required Vector2 center,
  }) async {
    final sprite = await Sprite.load(GameIcons.path(id));
    final aspect = sprite.srcSize.x / sprite.srcSize.y;
    return SwimSprite(
      sprite:   sprite,
      size:     Vector2(height * aspect, height),
      anchor:   Anchor.center,
      position: center,
    );
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
