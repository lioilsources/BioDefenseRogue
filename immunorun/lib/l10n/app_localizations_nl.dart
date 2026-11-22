// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get menuSubtitle => 'Immuuncel tegen infectie';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp max HP';
  }

  @override
  String get menuStartRun => 'RUN STARTEN';

  @override
  String get menuBook => 'LEXICON';

  @override
  String get menuSoundOn => 'GELUID: AAN';

  @override
  String get menuSoundOff => 'GELUID: UIT';

  @override
  String get menuStatsOn => 'STATISTIEKEN: AAN';

  @override
  String get menuStatsOff => 'STATISTIEKEN: UIT';

  @override
  String get pauseTitle => 'PAUZE';

  @override
  String get pauseResume => 'DOORGAAN';

  @override
  String get pauseRestart => 'RUN OPNIEUW';

  @override
  String get backToMenu => 'TERUG NAAR MENU';

  @override
  String get gameOverTitle => 'GAME OVER';

  @override
  String gameOverWaves(int count) {
    return 'Golven overleefd: $count';
  }

  @override
  String get gameOverInstant => 'Je ging meteen neer.';

  @override
  String get gameOverCause => 'WAT HEEFT ME GEDOOD?';

  @override
  String get gameOverRetry => 'OPNIEUW PROBEREN';

  @override
  String get runWonTitle => 'IMMUNITEIT BEREIKT';

  @override
  String get runWonSubtitle =>
      'Ziekteverwekker vernietigd. De gastheer heeft het overleefd.';

  @override
  String get runWonNewRun => 'NIEUWE RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count geheugencellen',
      one: '+1 geheugencel',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Volgende keer: immuun voor $enemy ($bonus schade)';
  }

  @override
  String get roomChoiceTitle => 'KIES JE PAD';

  @override
  String get upgradeChoiceTitle => 'KIES CYTOKINE / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'Wat is dit? (Lexicon)';

  @override
  String hudStartingIn(int secs) {
    return 'START OVER $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'GOLF $wave OVER $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'GOLF $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'GOLF $wave — OPGERUIMD!';
  }

  @override
  String bookToastOne(String name) {
    return 'Nieuwe pagina in het boek: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nieuwe pagina\'s in het boek: $name en meer ($count)';
  }
}
