import 'dart:math';

import 'package:flame/components.dart';

import '../../../config/balance.dart';
import '../player/player.dart';
import 'swarmer.dart';

class EnemySpawner extends Component {
  EnemySpawner({
    required this.player,
    required this.world,
    required this.onPlayerContact,
  });

  final Player          player;
  final World           world;
  final void Function() onPlayerContact;

  final _rng    = Random();
  double _timer = 0;

  double get _nextInterval =>
      Balance.spawnIntervalMin +
      _rng.nextDouble() * (Balance.spawnIntervalMax - Balance.spawnIntervalMin);

  int get _activeCount =>
      world.children.whereType<Swarmer>().length;

  @override
  void update(double dt) {
    _timer -= dt;
    if (_timer > 0) return;
    _timer = _nextInterval;

    if (_activeCount >= Balance.maxActiveEnemies) return;

    final angle = _rng.nextDouble() * 2 * pi;
    final spawnPos = player.position +
        Vector2(cos(angle), sin(angle)) * Balance.spawnRadius;

    world.add(
      Swarmer(player: player, onPlayerContact: onPlayerContact)
        ..position = spawnPos,
    );
  }
}
