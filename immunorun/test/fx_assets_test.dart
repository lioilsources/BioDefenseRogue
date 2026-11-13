import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/game/components/fx_sprite.dart';
import 'package:immunorun/ui/overlays/screen_background.dart';

void main() {
  test('FX sprity a textura arény existují', () {
    for (final p in FxImages.all) {
      expect(File('assets/images/$p').existsSync(), isTrue, reason: p);
    }
  });

  test('pozadí obrazovek a ikona vakcinace existují', () {
    for (final p in [
      ScreenImages.menu,
      ScreenImages.runWon,
      ScreenImages.gameOver,
      ScreenImages.vaccination,
    ]) {
      expect(File(p).existsSync(), isTrue, reason: p);
    }
  });

  test('bez načtení kreslí komponenty původní kruh', () {
    expect(FxImages.of(FxImages.granula), isNull);
  });
}
