import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';
import 'package:immunorun/game/systems/audio_controller.dart';

void main() {
  group('SfxThrottle', () {
    test('první přehrání projde, opakování v intervalu ne', () {
      final t = SfxThrottle(minInterval: 0.1);
      expect(t.shouldPlay('hit.wav', 0.0), isTrue);
      expect(t.shouldPlay('hit.wav', 0.05), isFalse);
      expect(t.shouldPlay('hit.wav', 0.11), isTrue);
    });

    test('různé sfx se nethrottlují navzájem', () {
      final t = SfxThrottle(minInterval: 0.1);
      expect(t.shouldPlay('hit.wav', 0.0), isTrue);
      expect(t.shouldPlay('death.wav', 0.01), isTrue);
    });

    test('reset vymaže historii', () {
      final t = SfxThrottle(minInterval: 10.0);
      expect(t.shouldPlay('hit.wav', 0.0), isTrue);
      t.reset();
      expect(t.shouldPlay('hit.wav', 0.1), isTrue);
    });
  });

  group('AudioController', () {
    test('bez preloadu je play no-op (žádná výjimka)', () {
      final audio = AudioController();
      expect(() => audio.play(Sfx.hit), returnsNormally);
    });

    test('ambient bez backendu je no-op, vypnutí zvuku ho zastaví', () {
      final audio = AudioController()..startAmbient();
      expect(audio.ambientPlaying, isFalse, reason: 'bez preloadu nehraje');
      audio.enabled = false;
      expect(() => audio.stopAmbient(), returnsNormally);
      expect(audio.ambientPlaying, isFalse);
    });

    test('vypnutý zvuk je no-op', () {
      final audio = AudioController()..enabled = false;
      expect(() => audio.play(Sfx.dash), returnsNormally);
    });
  });

  group('kniha (K6)', () {
    test('každý SFX i ambient existuje v assets/audio', () {
      for (final f in [...Sfx.all, Sfx.bookAmbient]) {
        expect(File('assets/audio/$f').existsSync(), isTrue, reason: f);
      }
    });

    test('ambient ≤ 1 MB (ADR 0005)', () {
      expect(File('assets/audio/${Sfx.bookAmbient}').lengthSync(),
          lessThanOrEqualTo(1024 * 1024));
    });

    test('fade-in jde od 0 k cíli, fade-out zpět k 0', () {
      double v(int s, bool inn) => fadeVolume(
          step: s, steps: 4, target: Balance.bookAmbientVolume, fadeIn: inn);
      expect(v(0, true), 0);
      expect(v(2, true), closeTo(Balance.bookAmbientVolume / 2, 1e-9));
      expect(v(4, true), Balance.bookAmbientVolume);
      expect(v(4, false), 0);
      expect(v(9, true), Balance.bookAmbientVolume, reason: 'clamp');
    });

    test('narace je ve fázi 1 vypnutá', () {
      expect(Balance.bookNarrationEnabled, isFalse);
    });
  });
}
