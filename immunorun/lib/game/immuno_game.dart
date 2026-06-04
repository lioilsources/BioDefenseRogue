import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/balance.dart';
import '../ui/hud/hud_overlay.dart';
import 'components/enemies/enemy.dart';
import 'components/player/player.dart';
import 'components/player/player_controller.dart';
import 'systems/fever_controller.dart';
import 'systems/wave_controller.dart';
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
  late final ArenaComponent   _arena;
  late final WaveController   _waves;

  PlayerController get playerController => _controller;

  bool   _gameOver     = false;
  double _hitStopTimer = 0;
  int    _wavesCleared = 0; // pro game over statistiku

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
    _arena      = ArenaComponent();
    await _activeWorld.add(_background);
    await _activeWorld.add(_arena);

    _controller = PlayerController();
    _player     = Player(controller: _controller);
    _player.position = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    await _activeWorld.add(_controller);
    await _activeWorld.add(_player);

    cam.follow(_player);
    _fever = FeverController();

    _waves = WaveController(
      player:          _player,
      world:           _activeWorld,
      onPlayerContact: _onEnemyHitPlayer,
    )
      ..onWaveStart   = (_) {}
      ..onWaveCleared = (n) {
        _wavesCleared = n;
        _fever.setRoomClear(true);
      };

    // onWaveStart: fever stoupá opět normálně
    _waves.onWaveStart = (_) => _fever.setRoomClear(false);

    await _activeWorld.add(_waves);
    _activeWorld.children.register<Enemy>();

    await _tryLoadFluidShader();
    overlays.add('hud');
  }

  void _onEnemyHitPlayer() {
    _fever.onHit();
    triggerHitStop();
  }

  void triggerHitStop() => _hitStopTimer = Balance.hitStopDuration;

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
    if (_hitStopTimer > 0) {
      _hitStopTimer -= dt;
      return;
    }

    super.update(dt);
    if (_gameOver) return;

    _wireNewEnemies();

    // Synchronizuj fázi arény s wave stavem
    _arena.phase = _waves.phase;

    final activeEnemies = _activeWorld.children.whereType<Enemy>().length;
    _fever.update(dt, activeEnemies: activeEnemies);

    if (_fever.snapshot.zone == FeverZone.hyper ||
        _fever.snapshot.zone == FeverZone.critical) {
      _player.takeDamage((Balance.feverHpDrainHyper * dt).round());
    }

    if (_player.isDead || _fever.isDead) _triggerGameOver();

    final snap    = _fever.snapshot;
    final hpNorm  = _player.hp / Balance.playerMaxHp;
    final waveSn  = _waves.snapshot;
    Future.microtask(() {
      providerContainer.read(feverProvider.notifier).setSnapshot(snap);
      providerContainer.read(playerHpProvider.notifier).set(hpNorm);
      providerContainer.read(waveProvider.notifier).set(waveSn);
    });
  }

  void _wireNewEnemies() {
    for (final e in _activeWorld.children.query<Enemy>()) {
      e.onHitCallback ??= triggerHitStop;
    }
  }

  void _triggerGameOver() {
    _gameOver = true;
    overlays.add('gameOver');
  }

  int get wavesCleared => _wavesCleared;

  void resetGame() {
    _gameOver    = false;
    _hitStopTimer = 0;
    _wavesCleared = 0;

    _activeWorld.children
        .where((c) =>
            c is! Player &&
            c is! PlayerController &&
            c is! ArenaComponent &&
            c is! BackgroundLayer &&
            c is! WaveController)
        .toList()
        .forEach((c) => c.removeFromParent());

    _player.position = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    _player.reset();
    _fever.reset();
    _waves.reset();
    overlays.remove('gameOver');
  }
}
