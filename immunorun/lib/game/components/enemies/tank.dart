import '../../../config/balance.dart';
import '../../../domain/enemy_archetype.dart';
import '../player/player.dart';
import '../swim_sprite.dart';
import 'enemy.dart';

/// Tank — pomalý, tuhý, vysoký kontaktní dmg, odolný proti knockbacku.
/// Vizuál: shluk S. aureus v ametystovém biofilmu (icons/biofilm.webp).
class Tank extends Enemy {
  Tank({
    required Player player,
    required this.onPlayerContact,
  })  : _player = player,
        super(archetype: tankArchetype);

  final Player _player;
  double       _contactTimer = 0;
  final void Function() onPlayerContact;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addIcon(GameIcons.biofilm, Balance.tankSpriteHeight);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    final dir = _player.position - position;
    if (dir.length2 > 1.0) {
      position += dir.normalized() * archetype.speed * statusSpeedMulti * dt;
    }

    final dist = dir.length;
    if (dist < archetype.radius + Balance.playerRadius) {
      _contactTimer -= dt;
      if (_contactTimer <= 0) {
        _contactTimer = Balance.tankContactInterval;
        _player.takeDamage(archetype.contactDamage.round());
        onPlayerContact();
      }
    } else {
      _contactTimer = 0;
    }
  }
}
