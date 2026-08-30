import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game/immuno_game.dart';
import 'ui/hud/hud_overlay.dart';
import 'ui/input/gesture_pad.dart';
import 'ui/overlays/main_menu_overlay.dart';
import 'ui/overlays/pause_overlay.dart';
import 'ui/overlays/room_choice_overlay.dart';
import 'ui/overlays/run_end_overlays.dart';
import 'ui/overlays/upgrade_choice_overlay.dart';

void main() {
  runApp(const ProviderScope(child: ImmunoApp()));
}

class ImmunoApp extends StatelessWidget {
  const ImmunoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                      'IMMUNORUN',
      debugShowCheckedModeBanner: false,
      theme:                      ThemeData.dark(),
      home:                       const _GameScreen(),
    );
  }
}

class _GameScreen extends StatefulWidget {
  const _GameScreen();

  @override
  State<_GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<_GameScreen> {
  late final ProviderContainer _container;
  late final ImmunoGame        _game;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _container = ProviderContainer();
    _game      = ImmunoGame(providerContainer: _container);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _container.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: _container,
      child: GameWidget<ImmunoGame>(
        game:       _game,
        focusNode:  _focusNode,
        autofocus:  true,
        overlayBuilderMap: {
          'mainMenu':   (context, game) => MainMenuOverlay(game: game),
          'pause':      (context, game) => PauseOverlay(game: game),
          'hud':        (context, game) => HudOverlay(onPause: game.pauseGame),
          'gesture':    (_, game) => GesturePadOverlay(
                controller: game.playerController,
              ),
          'gameOver':   (context, game) => GameOverOverlay(game: game),
          'runWon':     (context, game) => RunWonOverlay(game: game),
          'roomChoice': (context, game) => RoomChoiceOverlay(game: game),
          'upgradeChoice': (context, game) => UpgradeChoiceOverlay(game: game),
          'transition': (context, game) => const _TransitionOverlay(),
        },
        initialActiveOverlays: const [],
      ),
    );
  }
}

class _TransitionOverlay extends StatelessWidget {
  const _TransitionOverlay();

  @override
  Widget build(BuildContext context) => const ColoredBox(color: Colors.black);
}
