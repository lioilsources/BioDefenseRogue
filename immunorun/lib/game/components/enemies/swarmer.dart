import 'package:flame/components.dart';

import '../../../domain/enemy_archetype.dart';
import 'enemy.dart';

// Swarmer — první archetyp nepřítele (steering AI přijde v F1).
class Swarmer extends Enemy {
  Swarmer() : super(archetype: swarmerArchetype);

  // Cíl pronásledování — nastaví spawner
  Vector2? target;

  @override
  void update(double dt) {
    super.update(dt);
    final t = target;
    if (t == null || isDead) return;

    final dir = (t - position);
    if (dir.length2 > 1.0) {
      dir.normalize();
      position += dir * archetype.speed * dt;
    }
  }
}
