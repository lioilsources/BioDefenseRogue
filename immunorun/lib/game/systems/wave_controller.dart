import 'dart:math';

import 'package:flame/components.dart';

import '../../config/balance.dart';
import '../components/enemies/enemy.dart';
import '../components/enemies/swarmer.dart';
import '../components/player/player.dart';

enum WavePhase { countdown, active, cleared }

class WaveSnapshot {
  const WaveSnapshot({
    required this.wave,
    required this.phase,
    required this.timeRemaining,
  });

  final int       wave;
  final WavePhase phase;
  final double    timeRemaining;
}

class WaveController extends Component {
  WaveController({
    required this.player,
    required this.world,
    required this.onPlayerContact,
  });

  final Player          player;
  final World           world;
  final void Function() onPlayerContact;

  // Callbacks pro ImmunoGame
  void Function(int wave)? onWaveStart;
  void Function(int wave)? onWaveCleared;

  int       _wave  = 0;
  WavePhase _phase = WavePhase.countdown;
  double    _timer = Balance.waveCountdown;
  final _rng = Random();

  int       get wave  => _wave;
  WavePhase get phase => _phase;

  WaveSnapshot get snapshot => WaveSnapshot(
        wave:          _wave,
        phase:         _phase,
        timeRemaining: _timer.clamp(0.0, double.infinity),
      );

  int get _enemyCount => world.children.whereType<Enemy>().length;

  int get _enemiesToSpawn =>
      (Balance.waveBaseEnemies + _wave * Balance.waveEnemiesPerWave)
          .clamp(1, Balance.maxActiveEnemies);

  @override
  void update(double dt) {
    switch (_phase) {
      case WavePhase.countdown:
        _timer -= dt;
        if (_timer <= 0) _startWave();

      case WavePhase.active:
        if (_enemyCount == 0) _onCleared();

      case WavePhase.cleared:
        _timer -= dt;
        if (_timer <= 0) _startCountdown();
    }
  }

  void _startCountdown() {
    _phase = WavePhase.countdown;
    _timer = Balance.waveCountdown;
  }

  void _startWave() {
    _wave++;
    _phase = WavePhase.active;
    _timer = 0;

    final n = _enemiesToSpawn;
    for (var i = 0; i < n; i++) {
      final angle  = (i / n) * 2 * pi + _rng.nextDouble() * 0.8;
      final offset = Balance.spawnRadius + _rng.nextDouble() * 80;
      final pos    = player.position +
                     Vector2(cos(angle), sin(angle)) * offset;
      world.add(
        Swarmer(player: player, onPlayerContact: onPlayerContact)
          ..position = pos,
      );
    }
    onWaveStart?.call(_wave);
  }

  void _onCleared() {
    _phase = WavePhase.cleared;
    _timer = Balance.waveClearDelay;
    onWaveCleared?.call(_wave);
  }

  void reset() {
    _wave  = 0;
    _phase = WavePhase.countdown;
    _timer = Balance.waveCountdown;
  }
}
