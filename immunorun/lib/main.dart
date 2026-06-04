import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game/immuno_game.dart';
import 'ui/hud/hud_overlay.dart';
import 'ui/input/virtual_joystick.dart';

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
          'hud': (context, game) => const HudOverlay(),
          'joystick': (_, game) => VirtualJoystickOverlay(
                controller: game.playerController,
              ),
        },
        initialActiveOverlays: kIsWeb || isDesktop ? [] : ['joystick'],
      ),
    );
  }

  static bool get isDesktop =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;
}
