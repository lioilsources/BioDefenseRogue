// Anonymní statistiky hraní (docs/telemetry.md). Vrstva appky: hra sem
// jen hlásí přes GameObserver, nic z měření nečte.

import 'package:flutter/widgets.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/room_type.dart';
import '../domain/upgrade.dart';
import '../game/game_observer.dart';
import '../l10n/app_localizations.dart';

/// Verze appky, jak ji hlásí měření; test ji hlídá proti `pubspec.yaml`.
const kAppVersion = '1.0.1';

/// Id appky v `apps.yaml` ve StoreMetrics.
const kTelemetryApp = 'immunorun';

/// Testerský build: `--dart-define=TESTER=true`.
const kTesterBuild = bool.fromEnvironment('TESTER');

/// Kdo zabil (`MetaProgress.lastKilledByType`), jak ho hlásí `run_end.cause`.
const kCauses = {'fever', 'swarmer', 'tank', 'boss'};

/// Jediný slovník měření ImmunoRunu, zrcadlený v `docs/telemetry.md`.
final immunoDictionary = TelemetryDictionary(
  appVersion: kAppVersion,
  languages: {
    for (final l in AppLocalizations.supportedLocales) telemetryLocaleId(l),
  },
  screens: {for (final s in GameScreen.values) s.id},
  features: {
    'book',
    'book_hint',
    'quiz',
    'font_size',
    'parents',
    'sound_off',
    'elite_room',
    'treasure_room',
  },
  sessionPause: {'runs': const IntProp(100000)},
  events: {
    'menu_ready': {'ms': const IntProp(600000)},
    ...TelemetryDictionary.flow(
      'run',
      results: {for (final r in RunEnd.values) r.name},
      start: {
        'from': EnumProp({for (final f in RunFrom.values) f.name}),
        'vaccinated': const BoolProp(),
      },
      end: {
        'level': const IntProp(100),
        'room': EnumProp({for (final r in RoomType.values) r.name}),
        'cause': const EnumProp({...kCauses, 'other', 'none'}),
        'rooms': const IntProp(100),
        'upgrades': const IntProp(100),
        'cells': const IntProp(100000),
      },
    ),
    'room_choose': {
      'room': EnumProp({for (final r in RoomType.values) r.name}),
      'level': const IntProp(100),
    },
    'upgrade_pick': {
      'upgrade': EnumProp({for (final u in UpgradeId.values) u.name}),
      'level': const IntProp(100),
    },
  },
);

/// [TelemetryStore] nad SharedPreferences, které appka už používá.
class PrefsTelemetryStore implements TelemetryStore {
  PrefsTelemetryStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> read(String key) async => _prefs.getString(key);

  @override
  Future<void> write(String key, String value) => _prefs.setString(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}

/// Hrál už někdo před zavedením měření? Meta (`meta.*`) se ukládá po
/// prvním runu nebo po otevření knihy. Klíče `telemetry_*` nečte.
bool hadMetaBefore(SharedPreferences prefs) =>
    prefs.getKeys().any((k) => k.startsWith('meta.'));

/// Jazyk appky pro `lang`; nastavuje ho vrstva widgetů.
String telemetryLang = 'cs';

void setTelemetryLocale(Locale locale) {
  final id = telemetryLocaleId(locale);
  telemetryLang = immunoDictionary.languages.contains(id)
      ? id
      : telemetryLocaleId(Locale(locale.languageCode));
}

/// Převádí háčky hry na události. Měření neřídí hru: hra odsud nic nečte.
class ImmunoTelemetry implements GameObserver {
  TelemetryFlow? _run;

  /// Runy začaté v této relaci (`session_pause.runs`).
  int runs = 0;

  @override
  void screenChanged(GameScreen screen) => Telemetry.screen(screen.id);

  @override
  void runStarted(RunFrom from,
      {required bool vaccinated, required RunStats Function() live}) {
    runs++;
    _run = Telemetry.flow(
      'run',
      {'from': from.name, 'vaccinated': vaccinated},
      // Run nechaný v pozadí skončí s těmito hodnotami, když se appka nevrátí.
      () => endProps(live()),
    );
  }

  @override
  void runEnded(RunEnd end, RunStats stats) {
    final run = _run;
    _run = null;
    if (run == null || run.ended) return;
    run.end(end.name, endProps(stats));
    if (end == RunEnd.death || end == RunEnd.won) {
      // První dohraný run je první skutečný užitek.
      Telemetry.activation();
    }
  }

  static Map<String, Object> endProps(RunStats s) => {
        'level': s.level.clamp(0, 100),
        'room': s.room.name,
        'cause': switch (s.killedBy) {
          null => 'none',
          final k when kCauses.contains(k) => k,
          _ => 'other',
        },
        'rooms': s.roomsCleared.clamp(0, 100),
        'upgrades': s.upgrades.clamp(0, 100),
        'cells': s.cellsEarned.clamp(0, 100000),
      };

  @override
  void roomChosen(RoomType room, int level) {
    if (room == RoomType.elite) Telemetry.feature('elite_room');
    if (room == RoomType.treasure) Telemetry.feature('treasure_room');
    Telemetry.track(
        'room_choose', {'room': room.name, 'level': level.clamp(0, 100)});
  }

  @override
  void upgradePicked(UpgradeId id, int level) => Telemetry.track(
      'upgrade_pick', {'upgrade': id.name, 'level': level.clamp(0, 100)});

  @override
  void bookOpened({required bool fromHint}) =>
      Telemetry.feature(fromHint ? 'book_hint' : 'book');

  @override
  void quizDone() => Telemetry.feature('quiz');

  @override
  void bookFontChanged() => Telemetry.feature('font_size');
}
