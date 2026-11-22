// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get menuSubtitle => 'Immune cell vs. infection';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp max HP';
  }

  @override
  String get menuStartRun => 'START RUN';

  @override
  String get menuBook => 'LEXICON';

  @override
  String get menuSoundOn => 'SOUND: ON';

  @override
  String get menuSoundOff => 'SOUND: OFF';

  @override
  String get menuStatsOn => 'STATS: ON';

  @override
  String get menuStatsOff => 'STATS: OFF';

  @override
  String get pauseTitle => 'PAUSED';

  @override
  String get pauseResume => 'RESUME';

  @override
  String get pauseRestart => 'RESTART RUN';

  @override
  String get backToMenu => 'BACK TO MENU';

  @override
  String get gameOverTitle => 'GAME OVER';

  @override
  String gameOverWaves(int count) {
    return 'Waves survived: $count';
  }

  @override
  String get gameOverInstant => 'You fell right away.';

  @override
  String get gameOverCause => 'WHAT KILLED ME?';

  @override
  String get gameOverRetry => 'TRY AGAIN';

  @override
  String get runWonTitle => 'IMMUNITY ACHIEVED';

  @override
  String get runWonSubtitle => 'Pathogen destroyed. The host survived.';

  @override
  String get runWonNewRun => 'NEW RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count memory cells',
      one: '+1 memory cell',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Next time: immunized against $enemy ($bonus dmg)';
  }

  @override
  String get roomChoiceTitle => 'CHOOSE YOUR PATH';

  @override
  String get upgradeChoiceTitle => 'CHOOSE A CYTOKINE / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'What is this? (Lexicon)';

  @override
  String hudStartingIn(int secs) {
    return 'STARTING IN ${secs}s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'WAVE $wave IN ${secs}s';
  }

  @override
  String hudWave(int wave) {
    return 'WAVE $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'WAVE $wave — CLEARED!';
  }

  @override
  String bookToastOne(String name) {
    return 'New page in the book: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'New pages in the book: $name and more ($count)';
  }
}
