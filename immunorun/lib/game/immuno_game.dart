import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/balance.dart';
import '../ui/hud/hud_overlay.dart';
import 'components/player/player.dart';
import 'components/player/player_controller.dart';
import 'systems/fever_controller.dart';
import 'world/arena.dart';
import 'world/background.dart';

class ImmunoGame extends FlameGame
    with HasCollisionDetection {
  ImmunoGame({required this.providerContainer});

  final ProviderContainer providerContainer;

  late final Player           _player;
  late final PlayerController _controller;
  late final FeverController  _fever;
  late final BackgroundLayer  _background;

  PlayerController get playerController => _controller;

  @override
  Color backgroundColor() => const Color(0xFF0D1F0D);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // World musí být přidán do hry PŘED nastavením camera.world,
    // jinak CameraComponent přidá world jako své dítě a dojde k dvojímu přidání.
    final world = World();
    await add(world);

    final camera = CameraComponent.withFixedResolution(
      width:  size.x,
      height: size.y,
    );
    // Přiřazení referencí — world je už mounted, setter ho znovu nepřidává.
    camera.world = world;
    await add(camera);

    _background = BackgroundLayer();
    await world.add(_background);

    await world.add(ArenaComponent());

    // Controller přidán do world — HasKeyboardHandlerComponents propaguje rekurzivně.
    _controller       = PlayerController();
    _player           = Player(controller: _controller);
    _player.position  = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    await world.add(_controller);
    await world.add(_player);

    camera.follow(_player);

    _fever = FeverController();

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
    _fever.update(dt);
    // Flame volá update() během Flutter layout fáze (LayoutBuilder).
    // Riverpod 3.x zakazuje měnit stav během buildu → odkládáme na microtask.
    final snap = _fever.snapshot;
    Future.microtask(
      () => providerContainer.read(feverProvider.notifier).setSnapshot(snap),
    );
  }
}
