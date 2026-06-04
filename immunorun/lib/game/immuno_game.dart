import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/balance.dart';
import '../ui/hud/hud_overlay.dart';
import 'components/enemies/enemy.dart';
import 'components/enemies/enemy_spawner.dart';
import 'components/player/player.dart';
import 'components/player/player_controller.dart';
import 'systems/fever_controller.dart';
import 'world/arena.dart';
import 'world/background.dart';

class ImmunoGame extends FlameGame with HasCollisionDetection {
  ImmunoGame({required this.providerContainer});

  final ProviderContainer providerContainer;

  late final Player           _player;
  late final PlayerController _controller;
  late final FeverController  _fever;
  late final BackgroundLayer  _background;
  late final World            _activeWorld;

  FeverController get fever => _fever;
  PlayerController get playerController => _controller;

  bool _gameOver = false;

  @override
  Color backgroundColor() => const Color(0xFF0D1F0D);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _activeWorld = World();
    await add(_activeWorld);

    final cam = CameraComponent.withFixedResolution(
      width:  size.x,
      height: size.y,
    );
    cam.world = _activeWorld;
    await add(cam);

    _background = BackgroundLayer();
    await _activeWorld.add(_background);
    await _activeWorld.add(ArenaComponent());

    _controller = PlayerController();
    _player     = Player(controller: _controller);
    _player.position = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    await _activeWorld.add(_controller);
    await _activeWorld.add(_player);

    cam.follow(_player);

    _fever = FeverController();

    await _activeWorld.add(
      EnemySpawner(
        player:          _player,
        world:           _activeWorld,
        onPlayerContact: _fever.onHit,
      ),
    );

    await _tryLoadFluidShader();
    overlays.add('hud');
  }

  Future<void> _tryLoadFluidShader() async {
    try {
      final program =
          await ui.FragmentProgram.fromAsset('assets/shaders/fluid.frag');
      _background.applyShader(program);
    } catch (e) {
      debugPrint('ImmunoGame: fluid shader nedostupný: $e');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_gameOver) return;

    final activeEnemies = _activeWorld.children.whereType<Enemy>().length;
    _fever.update(dt, activeEnemies: activeEnemies);

    // HP drain v hyper zóně
    if (_fever.snapshot.zone == FeverZone.hyper ||
        _fever.snapshot.zone == FeverZone.critical) {
      _player.takeDamage((Balance.feverHpDrainHyper * dt).round());
    }

    // Game over
    if (_player.isDead || _fever.isDead) {
      _triggerGameOver();
    }

    final snap = _fever.snapshot;
    final hpNorm = _player.hp / Balance.playerMaxHp;
    Future.microtask(() {
      providerContainer.read(feverProvider.notifier).setSnapshot(snap);
      providerContainer.read(playerHpProvider.notifier).set(hpNorm);
    });
  }

  void _triggerGameOver() {
    _gameOver = true;
    overlays.add('gameOver');
  }

  void resetGame() {
    _gameOver = false;

    // odstraň nepřátele a projektily
    _activeWorld.children
        .where((c) => c is! Player && c is! PlayerController &&
                      c is! ArenaComponent && c is! BackgroundLayer &&
                      c is! EnemySpawner)
        .toList()
        .forEach((c) => c.removeFromParent());

    _player.position = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    _player.reset();
    _fever.reset();

    overlays.remove('gameOver');
  }
}
