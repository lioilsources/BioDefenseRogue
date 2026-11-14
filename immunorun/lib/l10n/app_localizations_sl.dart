// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get menuSubtitle => 'Imunska celica proti okužbi';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp maks. HP';
  }

  @override
  String get menuStartRun => 'ZAČNI RUN';

  @override
  String get menuBook => 'LEKSIKON';

  @override
  String get menuSoundOn => 'ZVOK: VKLOP';

  @override
  String get menuSoundOff => 'ZVOK: IZKLOP';

  @override
  String get menuStatsOn => 'STATISTIKA: VKLOP';

  @override
  String get menuStatsOff => 'STATISTIKA: IZKLOP';

  @override
  String get pauseTitle => 'PREMOR';

  @override
  String get pauseResume => 'NADALJUJ';

  @override
  String get pauseRestart => 'ZNOVA ZAČNI RUN';

  @override
  String get backToMenu => 'NAZAJ V MENI';

  @override
  String get gameOverTitle => 'KONEC IGRE';

  @override
  String gameOverWaves(int count) {
    return 'Preživeti valovi: $count';
  }

  @override
  String get gameOverInstant => 'Takoj si padel.';

  @override
  String get gameOverCause => 'KAJ ME JE UBILO?';

  @override
  String get gameOverRetry => 'POSKUSI ZNOVA';

  @override
  String get runWonTitle => 'IMUNOST DOSEŽENA';

  @override
  String get runWonSubtitle => 'Patogen uničen. Gostitelj je preživel.';

  @override
  String get runWonNewRun => 'NOV RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count spominskih celic',
      few: '+$count spominske celice',
      two: '+$count spominski celici',
      one: '+$count spominska celica',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Naslednjič: imunost – $enemy ($bonus škode)';
  }

  @override
  String get roomChoiceTitle => 'IZBERI POT';

  @override
  String get upgradeChoiceTitle => 'IZBERI CITOKIN / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'Kaj je to? (Leksikon)';

  @override
  String hudStartingIn(int secs) {
    return 'ZAČNEMO ČEZ $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'VAL $wave ČEZ $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'VAL $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'VAL $wave — POČIŠČENO!';
  }

  @override
  String bookToastOne(String name) {
    return 'Nova stran v knjigi: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nove strani v knjigi: $name in druge ($count)';
  }
}
