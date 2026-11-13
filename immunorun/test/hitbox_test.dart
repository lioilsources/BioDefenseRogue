import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/game/components/enemies/mini_boss.dart';
import 'package:immunorun/game/components/enemies/swarmer.dart';
import 'package:immunorun/game/components/enemies/tank.dart';
import 'package:immunorun/game/components/player/player.dart';
import 'package:immunorun/game/components/player/player_controller.dart';
import 'package:immunorun/game/components/projectile.dart';
import 'package:immunorun/game/systems/fever_controller.dart';

/// Hitbox musí sedět na středu komponenty (tam, kde je sprite a kam se míří).
/// Souřadnice dětí začínají v levém horním rohu rodiče, ne v jeho středu.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FlameGame game;
  late World world;

  setUp(() async {
    game  = FlameGame();
    world = World();
    game.onGameResize(Vector2(800, 600));
    // ignore: invalid_use_of_internal_member
    await game.load();
    // ignore: invalid_use_of_internal_member
    game.mount();
    game.update(0);
    await game.add(world);
    await game.ready();
  });

  Future<void> expectCentered(PositionComponent c) async {
    c.position = Vector2(300, 200);
    await world.add(c);
    await game.ready();
    game.update(0);
    final hitbox = c.children.whereType<CircleHitbox>().single;
    expect(hitbox.absoluteCenter.x, closeTo(c.absoluteCenter.x, 0.01),
        reason: '${c.runtimeType}');
    expect(hitbox.absoluteCenter.y, closeTo(c.absoluteCenter.y, 0.01),
        reason: '${c.runtimeType}');
  }

  final player = Player(controller: PlayerController());

  test('hráč', () => expectCentered(Player(controller: PlayerController())));
  test('kok', () => expectCentered(
      Swarmer(player: player, onPlayerContact: () {})));
  test('tank', () => expectCentered(
      Tank(player: player, onPlayerContact: () {})));
  test('boss', () => expectCentered(MiniBoss(
        player:          player,
        feverGetter:     () => FeverController().snapshot,
        onPlayerContact: () {},
      )));
  test('projektil hráče', () => expectCentered(
      Projectile(velocity: Vector2(1, 0))));
  test('projektil bosse', () => expectCentered(BossProjectile(
        velocity:        Vector2(1, 0),
        player:          player,
        onPlayerContact: () {},
      )));
}
