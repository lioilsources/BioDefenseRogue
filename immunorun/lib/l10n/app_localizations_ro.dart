// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get menuSubtitle => 'Celulă imunitară contra infecției';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp HP max.';
  }

  @override
  String get menuStartRun => 'ÎNCEPE RUNDA';

  @override
  String get menuBook => 'LEXICON';

  @override
  String get menuSoundOn => 'SUNET: PORNIT';

  @override
  String get menuSoundOff => 'SUNET: OPRIT';

  @override
  String get pauseTitle => 'PAUZĂ';

  @override
  String get pauseResume => 'CONTINUĂ';

  @override
  String get pauseRestart => 'RELUAREA RUNDEI';

  @override
  String get backToMenu => 'ÎNAPOI LA MENIU';

  @override
  String get gameOverTitle => 'JOC TERMINAT';

  @override
  String gameOverWaves(int count) {
    return 'Valuri supraviețuite: $count';
  }

  @override
  String get gameOverInstant => 'Ai căzut imediat.';

  @override
  String get gameOverCause => 'CE M-A UCIS?';

  @override
  String get gameOverRetry => 'ÎNCEARCĂ DIN NOU';

  @override
  String get runWonTitle => 'IMUNITATE OBȚINUTĂ';

  @override
  String get runWonSubtitle => 'Patogen distrus. Gazda a supraviețuit.';

  @override
  String get runWonNewRun => 'RUNDĂ NOUĂ';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count de celule de memorie',
      few: '+$count celule de memorie',
      one: '+$count celulă de memorie',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Data viitoare: imunizat împotriva $enemy ($bonus daune)';
  }

  @override
  String get roomChoiceTitle => 'ALEGE DRUMUL';

  @override
  String get upgradeChoiceTitle => 'ALEGE CITOKINĂ / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'Ce este asta? (Lexicon)';

  @override
  String hudStartingIn(int secs) {
    return 'ÎNCEPEM ÎN $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'VALUL $wave ÎN $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'VALUL $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'VALUL $wave — CURĂȚAT!';
  }

  @override
  String bookToastOne(String name) {
    return 'Pagină nouă în carte: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Pagini noi în carte: $name și altele ($count)';
  }
}
