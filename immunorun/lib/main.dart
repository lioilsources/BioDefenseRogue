import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/meta_repository.dart';
import 'domain/lore.dart';
import 'domain/meta_progress.dart';
import 'game/immuno_game.dart';
import 'l10n/app_localizations.dart';
import 'l10n/lore_l10n.dart';
import 'telemetry/telemetry.dart';
import 'ui/book/book_overlay.dart';
import 'ui/book/book_toast.dart';
import 'ui/hud/hud_overlay.dart';
import 'ui/input/gesture_pad.dart';
import 'ui/meta_providers.dart';
import 'ui/overlays/main_menu_overlay.dart';
import 'ui/overlays/pause_overlay.dart';
import 'ui/overlays/room_choice_overlay.dart';
import 'ui/overlays/run_end_overlays.dart';
import 'ui/overlays/upgrade_choice_overlay.dart';

Future<void> main() async {
  final launchedAt = DateTime.now();
  WidgetsFlutterBinding.ensureInitialized();
  final telemetry = ImmunoTelemetry();
  try {
    final prefs = await SharedPreferences.getInstance();
    // Jazyk, který vybere MaterialApp, pro události před prvním snímkem.
    setTelemetryLocale(resolveAppLocale(
      WidgetsBinding.instance.platformDispatcher.locales,
      AppLocalizations.supportedLocales,
    ));
    // Anonymní statistiky (docs/telemetry.md). Bez await: hra na měření
    // nečeká a build bez TELEMETRY_KEY nedělá vůbec nic.
    unawaited(Telemetry.init(
      app:           kTelemetryApp,
      appVersion:    kAppVersion,
      dictionary:    immunoDictionary,
      store:         PrefsTelemetryStore(prefs),
      lang:          () => telemetryLang,
      tester:        kTesterBuild,
      hadDataBefore: () => hadMetaBefore(prefs),
      pauseProps:    () => {'runs': telemetry.runs},
      launchedAt:    launchedAt,
    ));
  } catch (_) {
    // Bez úložiště se neměří; hra jede dál.
  }
  runApp(ProviderScope(
    child: ImmunoApp(telemetry: telemetry, launchedAt: launchedAt),
  ));
}

class ImmunoApp extends StatelessWidget {
  const ImmunoApp({super.key, this.telemetry, this.launchedAt});

  /// Háčky měření; null v testech.
  final ImmunoTelemetry? telemetry;
  final DateTime? launchedAt;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                      'IMMUNORUN',
      debugShowCheckedModeBanner: false,
      theme:                      ThemeData.dark(),
      localizationsDelegates:     const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:           AppLocalizations.supportedLocales,
      localeListResolutionCallback: resolveAppLocale,
      home: _GameScreen(telemetry: telemetry, launchedAt: launchedAt),
    );
  }
}

/// Jako výchozí rozlišení Flutteru, jen tradiční čínština bez skriptu
/// (zh_TW, zh_HK, zh_MO z Androidu) nespadne do zjednodušené.
Locale resolveAppLocale(List<Locale>? preferred, Iterable<Locale> supported) {
  const hant = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
  final fixed = [
    for (final l in preferred ?? const <Locale>[])
      if (l.languageCode == 'zh' && l.scriptCode == null &&
          const {'TW', 'HK', 'MO'}.contains(l.countryCode))
        hant
      else
        l,
  ];
  return basicLocaleListResolution(fixed, supported);
}

class _GameScreen extends StatefulWidget {
  const _GameScreen({this.telemetry, this.launchedAt});

  final ImmunoTelemetry? telemetry;
  final DateTime?        launchedAt;

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
    // Názvy pojmů čte i herní kód bez contextu → jazyk do globálu registru.
    loreLocale = AppLocalizations.of(context).localeName;
    setTelemetryLocale(Localizations.localeOf(context));
    return FutureBuilder<MetaProgress>(
      future:  _metaFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ColoredBox(color: Colors.black);
        }
        final game = _game ??= _createGame(snapshot.data!);
        return _buildGame(game);
      },
    );
  }

  ImmunoGame _createGame(MetaProgress meta) {
    final game = ImmunoGame(
      providerContainer: _container,
      initialMeta:       meta,
      onMetaChanged:     _onMetaChanged,
    )..observer = widget.telemetry;
    final launchedAt = widget.launchedAt;
    if (launchedAt != null) {
      // Čas načítání: od startu procesu po použitelné menu.
      game.loaded.then((_) {
        final ms = DateTime.now().difference(launchedAt).inMilliseconds;
        Telemetry.track('menu_ready', {'ms': ms.clamp(0, 600000)});
      });
    }
    return game;
  }

  Widget _buildGame(ImmunoGame game) {
    return UncontrolledProviderScope(
      container: _container,
      // Material dodá overlayům výchozí styl textu (jinak žluté podtržení).
      child: Material(
        type: MaterialType.transparency,
        child: GameWidget<ImmunoGame>(
          game:       game,
          focusNode:  _focusNode,
          autofocus:  true,
          overlayBuilderMap: {
            'mainMenu':   (context, game) => MainMenuOverlay(game: game),
            'pause':      (context, game) => PauseOverlay(game: game),
            'hud':        (context, game) => HudOverlay(
                  onPause:     game.pauseGame,
                  onFeverInfo: (zone) => game.openBookAt(lore.byRef(zone)),
                ),
            'gesture':    (_, game) => GesturePadOverlay(
                  controller: game.playerController,
                ),
            'gameOver':   (context, game) => GameOverOverlay(game: game),
            'runWon':     (context, game) => RunWonOverlay(game: game),
            'roomChoice': (context, game) => RoomChoiceOverlay(game: game),
            'upgradeChoice': (context, game) => UpgradeChoiceOverlay(game: game),
            'transition': (context, game) => const _TransitionOverlay(),
            'book':       (context, game) => BookOverlay(game: game),
            'bookToast':  (context, game) => BookToast(text: bookToastText(
                  AppLocalizations.of(context), game.bookToastFresh)),
          },
          initialActiveOverlays: const [],
        ),
      ),
    );
  }
}

class _TransitionOverlay extends StatelessWidget {
  const _TransitionOverlay();

  @override
  Widget build(BuildContext context) => const ColoredBox(color: Colors.black);
}
