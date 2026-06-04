import '../../../config/balance.dart';
import '../../../domain/enemy_archetype.dart';
import '../player/player.dart';
import 'enemy.dart';

class Swarmer extends Enemy {
  Swarmer({
    required this.player,
    required this.onPlayerContact,
  }) : super(archetype: swarmerArchetype);

  final Player          player;
  final void Function() onPlayerContact;

  double _contactTimer = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    // chase
    final dir = player.position - position;
    if (dir.length2 > 1.0) {
      position += dir.normalized() * archetype.speed * dt;
    }

    // contact damage
    final dist = dir.length;
    if (dist < archetype.radius + Balance.playerRadius) {
      _contactTimer -= dt;
      if (_contactTimer <= 0) {
        _contactTimer = Balance.swarmerContactInterval;
        player.takeDamage(archetype.contactDamage.round());
        onPlayerContact();
      }
    } else {
      _contactTimer = 0;
    }
  }
}
