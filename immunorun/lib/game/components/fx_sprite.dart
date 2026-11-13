import 'dart:ui' as ui;

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';

/// Obrázky FX (střely, ATP, textura arény) z `assets/images/fx|bg/`.
///
/// Hra je načte jednou v `onLoad`. Dokud tu nejsou (testy bez assetů),
/// komponenty kreslí původní barevný kruh.
class FxImages {
  FxImages._();

  static const granula = 'fx/fx-granula.webp';
  static const toxin   = 'fx/fx-toxin.webp';
  static const atp     = 'fx/fx-atp.webp';
  static const arena   = 'bg/bg-arena.webp';
  static const all     = [granula, toxin, atp, arena];

  static final Map<String, ui.Image> _cache = {};

  static ui.Image? of(String path) => _cache[path];

  static Future<void> load(Images images) async {
    for (final p in all) {
      _cache[p] = await images.load(p);
    }
  }
}

/// Kruh se spritem místo plné barvy. `fxTint` obarví světlý sprite
/// (střela hráče: normální, kritický zásah, nova).
mixin FxSpriteRender on CircleComponent {
  String get fxImagePath;
  bool get fxTinted => false;

  Paint? _fxPaint;

  @override
  void render(Canvas canvas) {
    final img = FxImages.of(fxImagePath);
    if (img == null) {
      super.render(canvas);
      return;
    }
    final p = _fxPaint ??= Paint()..filterQuality = FilterQuality.medium;
    if (fxTinted) {
      p.colorFilter = ColorFilter.mode(paint.color, BlendMode.modulate);
    }
    final d = radius * 2 * Balance.fxSpriteScale;
    canvas.drawImageRect(
      img,
      Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
      Rect.fromCenter(center: Offset(radius, radius), width: d, height: d),
      p,
    );
  }
}
