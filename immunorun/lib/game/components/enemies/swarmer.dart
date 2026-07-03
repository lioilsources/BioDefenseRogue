import 'package:flame/components.dart';

import '../../../config/balance.dart';
import '../../../domain/enemy_archetype.dart';
import '../player/player.dart';
import 'enemy.dart';

class Swarmer extends Enemy {
  Swarmer({
    required Player player,
    required this.onPlayerContact,
  })  : _player = player,
        super(archetype: swarmerArchetype);

  Player         _player;
  bool           _spriteLoaded = false;
  double         _contactTimer = 0;
  final void Function() onPlayerContact;

  void resetForPool(Vector2 spawnPos, Player newPlayer) {
    _player       = newPlayer;
    position      = spawnPos;
    _contactTimer = 0;
    resetEnemy();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (_spriteLoaded) return;
    _spriteLoaded = true;
    final sprite = await Sprite.load('pathogens/cocci.png');
    final h      = Balance.swarmerSpriteHeight;
    final aspect = sprite.srcSize.x / sprite.srcSize.y;
    add(SpriteComponent(
      sprite: sprite,
      size:   Vector2(h * aspect, h),
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    final dir = _player.position - position;
    if (dir.length2 > 1.0) {
      position += dir.normalized() * archetype.speed * dt;
    }

    final dist = dir.length;
    if (dist < archetype.radius + Balance.playerRadius) {
      _contactTimer -= dt;
      if (_contactTimer <= 0) {
        _contactTimer = Balance.swarmerContactInterval;
        _player.takeDamage(archetype.contactDamage.round());
        onPlayerContact();
      }
    } else {
      _contactTimer = 0;
    }
  }
}
