import 'dart:math';

import 'package:flame/components.dart';

import '../../config/balance.dart';
import '../../domain/room_type.dart';
import '../components/enemies/enemy.dart';
import '../components/enemies/tank.dart';
import '../components/player/player.dart';
import 'swarmer_pool.dart';
import 'wave_composition.dart';

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
    required this.swarmerPool,
  });

  final Player          player;
  final World           world;
  final void Function() onPlayerContact;
  final SwarmerPool     swarmerPool;

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

  /// Přidaní nepřátelé, kteří ještě nejsou připojení (čekají v `onLoad`).
  /// `world.children` je nevidí, bez nich by se vlna vyčistila dřív, než začne.
  final Set<Enemy> _pending = {};

  /// Přidá nepřítele do světa a počítá ho do vlny už před připojením.
  /// Všechny spawny vlny (i boss z ImmunoGame) musí jít tudy.
  void spawn(Enemy enemy) {
    _pending.add(enemy);
    world.add(enemy);
  }

  int get pendingCount => _pending.length;

  int get _enemyCount {
    _pending.removeWhere((e) => e.isMounted || e.isRemoved);
    return world.children.whereType<Enemy>().length + _pending.length;
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

    // Boss a treasure nerozrodí řadové nepřátele (composeWave vrátí nuly);
    // bosse spawne ImmunoGame via onWaveStart callback
    final comp = composeWave(roomType: _roomType, difficulty: _difficulty);
    _spawnSwarmers(comp.swarmers);
    _spawnTanks(comp.tanks);
    onWaveStart?.call(_wave);
  }

  Vector2 _ringSpawnPos(int i, int count) {
    final angle  = (i / count) * 2 * pi + _rng.nextDouble() * 0.8;
    final offset = Balance.spawnRadius + _rng.nextDouble() * 80;
    return player.position + Vector2(cos(angle), sin(angle)) * offset;
  }

  void _spawnSwarmers(int count) {
    for (var i = 0; i < count; i++) {
      spawn(swarmerPool.acquire(_ringSpawnPos(i, count), player));
    }
  }

  void _spawnTanks(int count) {
    for (var i = 0; i < count; i++) {
      spawn(
        Tank(player: player, onPlayerContact: onPlayerContact)
          ..position = _ringSpawnPos(i, count),
      );
    }
  }

  void _onCleared() {
    _phase = WavePhase.cleared;
    _timer = Balance.waveClearDelay;
    onWaveCleared?.call(_wave);
  }

  void reset() {
    // Nepřipojený nepřítel z minulé místnosti by se jinak připojil v nové.
    for (final e in _pending) {
      e.removeFromParent();
    }
    _pending.clear();
    _wave  = 0;
    _phase = WavePhase.countdown;
    _timer = Balance.waveCountdown;
  }
}
