// Tenký wrapper nad flame_audio: preload, master vypínač, per-sfx throttle,
// no-op fallback když assety/backend chybí (zrcadlí shader-loading vzor).

import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../../config/balance.dart';

/// Názvy SFX souborů (assets/audio/).
abstract final class Sfx {
  static const hit        = 'hit.wav';
  static const death      = 'death.wav';
  static const dash       = 'dash.wav';
  static const pickup     = 'pickup.wav';
  static const bossPhase  = 'boss_phase.wav';
  static const playerHurt = 'player_hurt.wav';
  // Kniha (ADR 0005)
  static const bookOpen   = 'book_open.wav';
  static const pageTurn   = 'page_turn.wav';
  static const bookClose  = 'book_close.wav';

  /// Ambient smyčka knihy (přes FlameAudio.bgm, ne audioCache).
  static const bookAmbient = 'book_ambient.m4a';

  static const all = [hit, death, dash, pickup, bossPhase, playerHurt,
      bookOpen, pageTurn, bookClose];
}

/// Hlasitost ambientu v kroku [step] z [steps] fade-in (od 0 k [target]),
/// nebo fade-out (od [target] k 0). Čistý Dart, testovatelné.
double fadeVolume({
  required int step,
  required int steps,
  required double target,
  required bool fadeIn,
}) {
  final f = (step / steps).clamp(0.0, 1.0);
  return target * (fadeIn ? f : 1 - f);
}

/// Per-sfx rate limit — čistý Dart, testovatelné bez audio backendu.
class SfxThrottle {
  SfxThrottle({required this.minInterval});

  final double minInterval; // s mezi přehráním téhož sfx
  final Map<String, double> _lastPlayed = {};

  /// Vrátí true a zaznamená čas, pokud sfx smí hrát v čase [now] (s).
  bool shouldPlay(String sfx, double now) {
    final last = _lastPlayed[sfx];
    if (last != null && now - last < minInterval) return false;
    _lastPlayed[sfx] = now;
    return true;
  }

  void reset() => _lastPlayed.clear();
}

class AudioController {
  bool _enabled = true;

  bool get enabled => _enabled;

  /// Vypnutí zvuku zastaví i běžící ambient.
  set enabled(bool v) {
    _enabled = v;
    if (!v) stopAmbient(fade: false);
  }

  bool   _ambientOn = false;
  Timer? _fade;

  bool get ambientPlaying => _ambientOn;

  bool _available = false;
  final Stopwatch _clock = Stopwatch()..start();
  final SfxThrottle _throttle =
      SfxThrottle(minInterval: Balance.sfxMinInterval);

  /// Načti všechny SFX do cache; při chybě audio tiše vypni.
  Future<void> preload() async {
    try {
      await FlameAudio.audioCache.loadAll(Sfx.all);
      _available = true;
    } catch (e) {
      debugPrint('AudioController: SFX nedostupné: $e');
    }
  }

  /// Ambient knihy s fade-in. Bez backendu nebo s vypnutým zvukem no-op.
  void startAmbient() {
    if (!enabled || !_available || _ambientOn) return;
    _ambientOn = true;
    try {
      FlameAudio.bgm.play(Sfx.bookAmbient, volume: 0);
      _runFade(fadeIn: true);
    } catch (e) {
      debugPrint('AudioController: ambient selhal: $e');
      _ambientOn = false;
    }
  }

  /// Zastaví ambient (s fade-out, pokud [fade]).
  void stopAmbient({bool fade = true}) {
    if (!_ambientOn) return;
    _ambientOn = false;
    _fade?.cancel();
    try {
      if (fade) {
        _runFade(fadeIn: false, then: FlameAudio.bgm.stop);
      } else {
        FlameAudio.bgm.stop();
      }
    } catch (e) {
      debugPrint('AudioController: stop ambientu selhal: $e');
    }
  }

  void _runFade({required bool fadeIn, Future<void> Function()? then}) {
    _fade?.cancel();
    var step = 0;
    const steps = Balance.bookAmbientFadeSteps;
    _fade = Timer.periodic(
      const Duration(milliseconds: Balance.bookAmbientFadeMs ~/ steps),
      (t) {
        step++;
        FlameAudio.bgm.audioPlayer.setVolume(fadeVolume(
          step: step, steps: steps,
          target: Balance.bookAmbientVolume, fadeIn: fadeIn,
        ));
        if (step >= steps) {
          t.cancel();
          then?.call();
        }
      },
    );
  }

  void play(String sfx) {
    if (!enabled || !_available) return;
    if (!_throttle.shouldPlay(sfx, _clock.elapsedMilliseconds / 1000.0)) return;
    try {
      FlameAudio.play(sfx, volume: Balance.sfxMasterVolume);
    } catch (e) {
      debugPrint('AudioController: přehrání $sfx selhalo: $e');
    }
  }
}
