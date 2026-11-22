// Screenshoty do App Store a Google Play: menu, boj, upgrade, dveře, kniha, výhra.
// Kniha (Lexikon zdraví) jen v cs, je zatím jen česky.
// Spouští tool/store_screenshots.sh (flutter drive na simulátoru / emulátoru);
// PNG ukládá test_driver/screenshot_driver.dart do SCREENSHOT_DIR.
//
// Jazyky: --dart-define=SCREENSHOT_LOCALES=cs,en (výchozí cs,en).

import 'dart:io';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:immunorun/game/immuno_game.dart';
import 'package:immunorun/main.dart';

const _locales = String.fromEnvironment('SCREENSHOT_LOCALES', defaultValue: 'cs,en');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Hra běží vlastní smyčkou (Flame) → snímky plynule, ne jen při pump.
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('store screenshots', (tester) async {
    if (Platform.isAndroid) await binding.convertFlutterSurfaceToImage();

    for (final code in _locales.split(',')) {
      // Čistá meta (první spuštění), nic se neuloží do zařízení.
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(ProviderScope(
        key:   ValueKey(code),
        child: ImmunoApp(locale: Locale(code)),
      ));
      final game = await _waitForGame(tester);

      Future<void> shot(int n, String scene) async {
        await _wait(tester, 0.8);
        await binding.takeScreenshot('${code}_${n}_$scene');
      }

      await shot(1, 'menu');
      // Bez zvuku (až po menu, kde je přepínač ZVUK: ZAP): na snímcích není
      // slyšet a přehrávač by přežil konec testu.
      game.audio.enabled = false;

      game.startRun();
      await _wait(tester, 4); // první vlna doplave do arény, ale ještě nepadne
      await shot(2, 'arena');

      game.debugOfferUpgrades();
      await shot(3, 'upgrade');
      game.chooseUpgrade(game.pendingUpgrades.first);
      await _wait(tester, 1);

      game.debugOfferDoors();
      await shot(4, 'doors');
      game.debugDismissDoors();

      // Kniha je zatím jen česky → do jiných jazyků ji nefoť.
      if (code == 'cs') {
        game.openBook();
        await _wait(tester, 1.5);
        await shot(5, 'book');
        game.closeBook();
      }

      game.debugWinRun();
      await shot(6, 'victory');

      game.pauseEngine();
    }
    await tester.pumpWidget(const SizedBox());
    await _wait(tester, 0.5);
  });
}

Future<ImmunoGame> _waitForGame(WidgetTester tester) async {
  for (var i = 0; i < 300; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    final found = find.byType(GameWidget<ImmunoGame>);
    if (found.evaluate().isNotEmpty) {
      final game = tester.widget<GameWidget<ImmunoGame>>(found).game!;
      if (game.isLoaded && game.overlays.isActive('mainMenu')) return game;
    }
  }
  throw StateError('hra se nenačetla');
}

Future<void> _wait(WidgetTester tester, double seconds) async {
  final end = DateTime.now().add(Duration(milliseconds: (seconds * 1000).round()));
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}
