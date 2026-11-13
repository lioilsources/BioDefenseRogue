import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';
import 'package:immunorun/domain/enemy_archetype.dart';
import 'package:immunorun/domain/room_type.dart';
import 'package:immunorun/game/components/enemies/enemy.dart';
import 'package:immunorun/game/components/player/player.dart';
import 'package:immunorun/game/components/player/player_controller.dart';
import 'package:immunorun/game/components/swim_sprite.dart';
import 'package:immunorun/game/systems/swarmer_pool.dart';
import 'package:immunorun/game/systems/wave_controller.dart';

/// Nepřítel, jehož `onLoad` doběhne až na pokyn — simuluje studenou cache obrázků.
class _SlowEnemy extends Enemy {
  _SlowEnemy() : super(archetype: tankArchetype);

  final gate = Completer<void>();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await gate.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FlameGame game;
  late World world;
  late WaveController waves;
  late int cleared;

  setUp(() async {
    game  = FlameGame();
    world = World();
    // Stejně jako flame_test.initializeGame: hra musí být „připojená“, jinak
    // add() z update() mění children během iterace.
    game.onGameResize(Vector2(800, 600));
    // ignore: invalid_use_of_internal_member
    await game.load();
    // ignore: invalid_use_of_internal_member
    game.mount();
    game.update(0);
    await game.add(world);
    // Hráč se do světa nepřidává (načítal by sprite); vlna z něj čte jen pozici.
    final player = Player(controller: PlayerController());
    waves = WaveController(
      player:          player,
      world:           world,
      onPlayerContact: () {},
      swarmerPool:     SwarmerPool(onPlayerContact: () {}),
    )..setRoom(RoomType.boss);
    cleared = 0;
    waves.onWaveCleared = (_) => cleared++;
    await world.add(waves);
    await game.ready();
  });

  void tick([double dt = 1 / 60]) {
    game.update(dt);
  }

  test('vlna se nevyčistí, dokud se spawnutý nepřítel načítá', () async {
    final enemy = _SlowEnemy();
    waves.onWaveStart = (_) => waves.spawn(enemy);

    tick(Balance.waveCountdown + 0.1); // odpočet → _startWave → spawn bosse
    for (var i = 0; i < 10; i++) {
      tick();
      await Future<void>.delayed(Duration.zero);
    }
    expect(enemy.isMounted, isFalse);
    expect(waves.phase, WavePhase.active);
    expect(cleared, 0);

    enemy.gate.complete();
    await game.ready();
    tick();
    expect(enemy.isMounted, isTrue);
    expect(waves.pendingCount, 0);
    expect(waves.phase, WavePhase.active);

    enemy.removeFromParent();
    tick(); // zpracuje odebrání
    tick();
    expect(waves.phase, WavePhase.cleared);
    expect(cleared, 1);
  });

  test('reset zahodí nepřipojené nepřátele z minulé místnosti', () async {
    final enemy = _SlowEnemy();
    waves.onWaveStart = (_) => waves.spawn(enemy);
    tick(Balance.waveCountdown + 0.1);
    expect(waves.pendingCount, 1);

    waves.reset();
    expect(waves.pendingCount, 0);
    enemy.gate.complete();
    await game.ready();
    tick();
    expect(enemy.isMounted, isFalse);
  });

  test('každá herní ikona existuje v assets', () {
    for (final id in GameIcons.all) {
      final path = 'assets/images/${GameIcons.path(id)}';
      expect(File(path).existsSync(), isTrue, reason: path);
    }
  });
}
