import 'dart:math';

import 'package:flame/components.dart';

import '../../config/balance.dart';
import '../../domain/room_type.dart';
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

  int       _wave       = 0;
  WavePhase _phase      = WavePhase.countdown;
  double    _timer      = Balance.waveCountdown;
  RoomType  _roomType   = RoomType.combat;
  int       _difficulty = 0; // číslo místnosti pro škálování obtížnosti
  final     _rng        = Random();

  int       get wave  => _wave;
  WavePhase get phase => _phase;

  WaveSnapshot get snapshot => WaveSnapshot(
        wave:          _wave,
        phase:         _phase,
        timeRemaining: _timer.clamp(0.0, double.infinity),
      );

  void setRoom(RoomType type, {int difficulty = 0}) {
    _roomType   = type;
    _difficulty = difficulty;
  }

  int get _enemyCount => world.children.whereType<Enemy>().length;

  int get _enemiesToSpawn {
    final base = Balance.waveBaseEnemies + _difficulty * Balance.waveEnemiesPerWave;
    final mult = _roomType == RoomType.elite ? Balance.eliteEnemyMultiplier : 1.0;
    return (base * mult).round().clamp(1, Balance.maxActiveEnemies);
  }

  @override
  void update(double dt) {
    switch (_phase) {
      case WavePhase.countdown:
        _timer -= dt;
        if (_timer <= 0) _startWave();

      case WavePhase.active:
        if (_enemyCount == 0) _onCleared();

      case WavePhase.cleared:
        if (_timer > 0) _timer -= dt;
        // Záměrně nespouštíme novou vlnu — ImmunoGame přejde do další místnosti
    }
  }

  void _startWave() {
    _wave++;
    _phase = WavePhase.active;
    _timer = 0;

    // Boss a treasure nerozrodí swarmery — boss spawne ImmunoGame via onWaveStart callback
    if (_roomType != RoomType.boss && _roomType != RoomType.treasure) {
      _spawnSwarmers(_enemiesToSpawn);
    }
    onWaveStart?.call(_wave);
  }

  void _spawnSwarmers(int count) {
    for (var i = 0; i < count; i++) {
      final angle  = (i / count) * 2 * pi + _rng.nextDouble() * 0.8;
      final offset = Balance.spawnRadius + _rng.nextDouble() * 80;
      final pos    = player.position +
                     Vector2(cos(angle), sin(angle)) * offset;
      world.add(
        Swarmer(player: player, onPlayerContact: onPlayerContact)
          ..position = pos,
      );
    }
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
