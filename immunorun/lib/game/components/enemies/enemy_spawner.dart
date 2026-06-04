import 'package:flame/components.dart';

import '../player/player.dart';

// Nahrazen WaveController (M2.1). Ponechán jako stub pro případný ObjectPool (M1.5).
class EnemySpawner extends Component {
  EnemySpawner({
    required this.player,
    required this.world,
    required this.onPlayerContact,
  });

  final Player          player;
  final World           world;
  final void Function() onPlayerContact;
}
