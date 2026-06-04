import 'package:flame/components.dart';

// Spawner — implementuje se plně v F1.
// Placeholder aby šla zkompilovat struktura.
class EnemySpawner extends Component {
  EnemySpawner({required this.playerPosition});
  final Vector2 Function() playerPosition;
}
