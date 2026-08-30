// Tenký wrapper nad flame_audio: preload, master vypínač, per-sfx throttle,
// no-op fallback když assety/backend chybí (zrcadlí shader-loading vzor).

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

  static const all = [hit, death, dash, pickup, bossPhase, playerHurt];
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
  bool enabled = true;

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
