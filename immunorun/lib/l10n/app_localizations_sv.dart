// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get menuSubtitle => 'Immuncell mot infektion';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp max HP';
  }

  @override
  String get menuStartRun => 'STARTA RUN';

  @override
  String get menuBook => 'LEXIKON';

  @override
  String get menuSoundOn => 'LJUD: PÅ';

  @override
  String get menuSoundOff => 'LJUD: AV';

  @override
  String get pauseTitle => 'PAUS';

  @override
  String get pauseResume => 'FORTSÄTT';

  @override
  String get pauseRestart => 'STARTA OM RUN';

  @override
  String get backToMenu => 'TILLBAKA TILL MENYN';

  @override
  String get gameOverTitle => 'GAME OVER';

  @override
  String gameOverWaves(int count) {
    return 'Överlevda vågor: $count';
  }

  @override
  String get gameOverInstant => 'Du föll direkt.';

  @override
  String get gameOverCause => 'VAD DÖDADE MIG?';

  @override
  String get gameOverRetry => 'FÖRSÖK IGEN';

  @override
  String get runWonTitle => 'IMMUNITET UPPNÅDD';

  @override
  String get runWonSubtitle => 'Patogenen är förintad. Värden överlevde.';

  @override
  String get runWonNewRun => 'NY RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count minnesceller',
      one: '+1 minnescell',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Nästa gång: immun mot $enemy ($bonus skada)';
  }

  @override
  String get roomChoiceTitle => 'VÄLJ VÄG';

  @override
  String get upgradeChoiceTitle => 'VÄLJ CYTOKIN / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'Vad är det här? (Lexikon)';

  @override
  String hudStartingIn(int secs) {
    return 'START OM $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'VÅG $wave OM $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'VÅG $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'VÅG $wave — RENSAD!';
  }

  @override
  String bookToastOne(String name) {
    return 'Ny sida i boken: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nya sidor i boken: $name med flera ($count)';
  }
}
