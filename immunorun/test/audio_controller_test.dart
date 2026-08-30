import 'package:flutter_test/flutter_test.dart';
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

    test('vypnutý zvuk je no-op', () {
      final audio = AudioController()..enabled = false;
      expect(() => audio.play(Sfx.dash), returnsNormally);
    });
  });
}
