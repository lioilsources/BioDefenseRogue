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
          'gameOver': (context, game) => _GameOverOverlay(game: game),
        },
        initialActiveOverlays: kIsWeb || _isDesktop ? [] : ['joystick'],
      ),
    );
  }

  static bool get _isDesktop =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;
}

class _GameOverOverlay extends StatelessWidget {
  const _GameOverOverlay({required this.game});
  final ImmunoGame game;

  @override
  Widget build(BuildContext context) {
    final waves = game.wavesCleared;
    return Center(
      child: Container(
        padding:    const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
        decoration: BoxDecoration(
          color:        Colors.black87,
          borderRadius: BorderRadius.circular(16),
          border:       Border.all(color: Colors.red.shade700, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                color:      Colors.redAccent,
                fontSize:   36,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              waves > 0 ? 'Přežito vln: $waves' : 'Padl jsi hned.',
              style: const TextStyle(
                color:    Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              onPressed: game.resetGame,
              child: const Text(
                'ZKUSIT ZNOVU',
                style: TextStyle(fontSize: 18, letterSpacing: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
