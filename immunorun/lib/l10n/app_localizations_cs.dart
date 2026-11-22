// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get menuSubtitle => 'Imunitní buňka vs. infekce';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp max HP';
  }

  @override
  String get menuStartRun => 'SPUSTIT RUN';

  @override
  String get menuBook => 'LEXIKON';

  @override
  String get menuSoundOn => 'ZVUK: ZAP';

  @override
  String get menuSoundOff => 'ZVUK: VYP';

  @override
  String get menuStatsOn => 'STATISTIKY: ZAP';

  @override
  String get menuStatsOff => 'STATISTIKY: VYP';

  @override
  String get pauseTitle => 'PAUZA';

  @override
  String get pauseResume => 'POKRAČOVAT';

  @override
  String get pauseRestart => 'RESTART RUNU';

  @override
  String get backToMenu => 'ZPĚT DO MENU';

  @override
  String get gameOverTitle => 'GAME OVER';

  @override
  String gameOverWaves(int count) {
    return 'Přežito vln: $count';
  }

  @override
  String get gameOverInstant => 'Padl jsi hned.';

  @override
  String get gameOverCause => 'CO MĚ ZABILO?';

  @override
  String get gameOverRetry => 'ZKUSIT ZNOVU';

  @override
  String get runWonTitle => 'IMMUNITA DOSAŽENA';

  @override
  String get runWonSubtitle => 'Patogen zničen. Host přežil.';

  @override
  String get runWonNewRun => 'NOVÝ RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count paměťových buněk',
      few: '+$count paměťové buňky',
      one: '+1 paměťová buňka',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Příště: imunizace proti $enemy ($bonus dmg)';
  }

  @override
  String get roomChoiceTitle => 'VYBER CESTU';

  @override
  String get upgradeChoiceTitle => 'VYBER CYTOKIN / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'Co to je? (Lexikon)';

  @override
  String hudStartingIn(int secs) {
    return 'ZAČÍNÁME ZA ${secs}s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'VLNA $wave ZA ${secs}s';
  }

  @override
  String hudWave(int wave) {
    return 'VLNA $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'VLNA $wave — VYČIŠTĚNO!';
  }

  @override
  String bookToastOne(String name) {
    return 'Nová stránka v knize: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nové stránky v knize: $name a další ($count)';
  }
}
