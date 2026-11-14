// Kontroly, které z ol1n_telemetry kopíruje každá appka (README „Testovací
// sada“), a háčky hry: obrazovky, runy, upgrady, kniha.

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/domain/room_type.dart';
import 'package:immunorun/domain/upgrade.dart';
import 'package:immunorun/game/game_observer.dart';
import 'package:immunorun/game/immuno_game.dart';
import 'package:immunorun/telemetry/telemetry.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:ol1n_telemetry/testing.dart';

const _stats = RunStats(
  level:        3,
  room:         RoomType.elite,
  roomsCleared: 2,
  upgrades:     2,
  cellsEarned:  40,
  killedBy:     'tank',
);

/// Zapisuje, co hra hlásí (bez balíčku).
class _Recorder implements GameObserver {
  final calls = <String>[];

  @override
  void screenChanged(GameScreen screen) => calls.add('screen:${screen.id}');
  @override
  void runStarted(RunFrom from,
          {required bool vaccinated, required RunStats Function() live}) =>
      calls.add('start:${from.name}');
  @override
  void runEnded(RunEnd end, RunStats stats) => calls.add('end:${end.name}');
  @override
  void roomChosen(RoomType room, int level) => calls.add('room:${room.name}');
  @override
  void upgradePicked(UpgradeId id, int level) => calls.add('upgrade:${id.name}');
  @override
  void bookOpened({required bool fromHint}) => calls.add('book:$fromHint');
  @override
  void quizDone() => calls.add('quiz');
  @override
  void bookFontChanged() => calls.add('font');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('docs/telemetry.md lists exactly the dictionary', () {
    expect(
        telemetryDocProblems(immunoDictionary,
            File('../docs/telemetry.md').readAsStringSync()),
        isEmpty);
  });

  test('no property is free text', () {
    expect(telemetryDictionaryProblems(immunoDictionary), isEmpty);
  });

  test('app version matches pubspec.yaml', () {
    expect(
        telemetryVersionProblems(
            kAppVersion, File('pubspec.yaml').readAsStringSync()),
        isEmpty);
  });

  test('the code sends only dictionary events, and every one of them', () {
    expect(telemetryTrackCallProblems(immunoDictionary), isEmpty);
  });

  test('no key, no network', () async {
    expect(
        await telemetryNoKeyProblems(immunoDictionary,
            pauseProps: () => {'runs': 0}),
        isEmpty);
  }, skip: const bool.fromEnvironment('TELEMETRY_DEBUG'));

  test('off means nothing', () async {
    expect(
        await telemetryOffProblems(immunoDictionary,
            pauseProps: () => {'runs': 0}),
        isEmpty);
  });

  group('telemetry hooks', () {
    late ImmunoTelemetry hooks;

    setUp(() async {
      Telemetry.resetForTest();
      await Telemetry.init(
        app:              kTelemetryApp,
        appVersion:       kAppVersion,
        dictionary:       immunoDictionary,
        store:            MemoryTelemetryStore(),
        lang:             () => 'cs',
        pauseProps:       () => {'runs': 0},
        sink:             FakeSink(),
        startTimer:       false,
        observeLifecycle: false,
      );
      hooks = ImmunoTelemetry();
    });

    tearDown(Telemetry.resetForTest);

    List<String> names() => [for (final e in Telemetry.debugQueue) e.name];
    TelemetryEvent last(String name) =>
        Telemetry.debugQueue.lastWhere((e) => e.name == name);

    test('screens follow the game state', () {
      hooks.screenChanged(GameScreen.menu);
      hooks.screenChanged(GameScreen.roomChoice);
      expect(Telemetry.debugScreen, 'room_choice');
      expect(last('screen_leave').props['screen'], 'menu');
    });

    test('a run played to the end activates once', () {
      hooks.runStarted(RunFrom.menu, vaccinated: false, live: () => _stats);
      hooks.runEnded(RunEnd.death, _stats);
      hooks.runStarted(RunFrom.result, vaccinated: true, live: () => _stats);
      hooks.runEnded(RunEnd.won, _stats);

      expect(names().where((n) => n == 'activation'), hasLength(1));
      final start = Telemetry.debugQueue.firstWhere((e) => e.name == 'run_start');
      expect(start.props, containsPair('from', 'menu'));
      expect(start.props, containsPair('vaccinated', false));
      final end = Telemetry.debugQueue.firstWhere((e) => e.name == 'run_end');
      expect(end.props, containsPair('result', 'death'));
      expect(end.props, containsPair('cause', 'tank'));
      expect(end.props, containsPair('level', 3));
      expect(end.props, containsPair('room', 'elite'));
      expect(end.props, containsPair('cells', 40));
      expect(last('run_start').props['from'], 'result');
      expect(hooks.runs, 2);
    });

    test('leaving a run is not an activation', () {
      hooks.runStarted(RunFrom.menu, vaccinated: false, live: () => _stats);
      hooks.runEnded(RunEnd.restart, _stats);
      hooks.runStarted(RunFrom.pause, vaccinated: false, live: () => _stats);
      hooks.runEnded(RunEnd.menu, _stats);
      expect(names(), isNot(contains('activation')));
      expect(last('run_end').props, containsPair('result', 'menu'));
    });

    test('an unknown cause reports other, no cause reports none', () {
      const fresh = RunStats(
          level: 1, room: RoomType.combat, roomsCleared: 0, upgrades: 0,
          cellsEarned: 0, killedBy: 'virus');
      expect(ImmunoTelemetry.endProps(fresh)['cause'], 'other');
      expect(
          ImmunoTelemetry.endProps(const RunStats(
              level: 1, room: RoomType.combat, roomsCleared: 0, upgrades: 0,
              cellsEarned: 0))['cause'],
          'none');
    });

    test('an end without a start sends nothing', () {
      hooks.runEnded(RunEnd.menu, _stats);
      expect(names(), isNot(contains('run_end')));
    });

    test('picks, doors and book become events and features', () {
      hooks.upgradePicked(UpgradeId.histamin, 2);
      hooks.roomChosen(RoomType.elite, 2);
      hooks.bookOpened(fromHint: true);
      hooks.quizDone();
      expect(last('upgrade_pick').props, containsPair('upgrade', 'histamin'));
      expect(last('room_choose').props, containsPair('room', 'elite'));
      final features = [
        for (final e in Telemetry.debugQueue)
          if (e.name == 'feature_use') e.props['feature'],
      ];
      expect(features, ['elite_room', 'book_hint', 'quiz']);
    });
  });

  group('game reports to its observer', () {
    ImmunoGame game(_Recorder r) {
      final g = ImmunoGame(providerContainer: ProviderContainer())
        ..observer = r;
      for (final name in ['book', 'pause', 'mainMenu']) {
        g.overlays.addEntry(name, (_, _) => const SizedBox());
      }
      return g;
    }

    test('book opens and closes as a screen', () {
      final r = _Recorder();
      final g = game(r)..pauseEngine();
      g.openBook();
      g.closeBook();
      g.openBook(chapterId: '05-horecka');
      expect(r.calls, [
        'book:false',
        'screen:book',
        'screen:play',
        'book:true',
        'screen:book',
      ]);
    });

    test('quiz and font size are reported, nothing is read back', () {
      final r = _Recorder();
      game(r)
        ..markQuizDone('05-horecka')
        ..setBookFontStep(1);
      expect(r.calls, ['quiz', 'font']);
    });
  });
}
