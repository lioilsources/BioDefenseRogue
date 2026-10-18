import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/meta_repository.dart';
import 'domain/meta_progress.dart';
import 'game/immuno_game.dart';
import 'ui/book/book_overlay.dart';
import 'ui/hud/hud_overlay.dart';
import 'ui/input/gesture_pad.dart';
import 'ui/meta_providers.dart';
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
  late final ProviderContainer      _container;
  late final Future<MetaProgress>   _metaFuture;
  final MetaRepository _metaRepo = SharedPrefsMetaRepository();
  ImmunoGame? _game;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _container  = ProviderContainer();
    _metaFuture = _loadMeta();
  }

  Future<MetaProgress> _loadMeta() async {
    MetaProgress meta;
    try {
      meta = await _metaRepo.load();
    } catch (_) {
      meta = MetaProgress.empty; // persistence nedostupná → hraj bez mety
    }
    _container.read(metaProvider.notifier).set(meta);
    return meta;
  }

  void _onMetaChanged(MetaProgress meta) {
    _container.read(metaProvider.notifier).set(meta);
    _metaRepo.save(meta); // fire-and-forget; případná chyba nezastaví hru
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _container.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MetaProgress>(
      future:  _metaFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ColoredBox(color: Colors.black);
        }
        final game = _game ??= ImmunoGame(
          providerContainer: _container,
          initialMeta:       snapshot.data!,
          onMetaChanged:     _onMetaChanged,
        );
        return _buildGame(game);
      },
    );
  }

  Widget _buildGame(ImmunoGame game) {
    return UncontrolledProviderScope(
      container: _container,
      child: GameWidget<ImmunoGame>(
        game:       game,
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
          'book':       (context, game) => BookOverlay(game: game),
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
