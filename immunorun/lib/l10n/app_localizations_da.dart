// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get menuSubtitle => 'Immuncelle mod infektion';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp maks. HP';
  }

  @override
  String get menuStartRun => 'START RUN';

  @override
  String get menuBook => 'LEKSIKON';

  @override
  String get menuSoundOn => 'LYD: TIL';

  @override
  String get menuSoundOff => 'LYD: FRA';

  @override
  String get menuStatsOn => 'STATISTIK: TIL';

  @override
  String get menuStatsOff => 'STATISTIK: FRA';

  @override
  String get pauseTitle => 'PAUSE';

  @override
  String get pauseResume => 'FORTSÆT';

  @override
  String get pauseRestart => 'GENSTART RUN';

  @override
  String get backToMenu => 'TILBAGE TIL MENU';

  @override
  String get gameOverTitle => 'GAME OVER';

  @override
  String gameOverWaves(int count) {
    return 'Overlevede bølger: $count';
  }

  @override
  String get gameOverInstant => 'Du faldt med det samme.';

  @override
  String get gameOverCause => 'HVAD DRÆBTE MIG?';

  @override
  String get gameOverRetry => 'PRØV IGEN';

  @override
  String get runWonTitle => 'IMMUNITET OPNÅET';

  @override
  String get runWonSubtitle => 'Patogenet er udryddet. Værten overlevede.';

  @override
  String get runWonNewRun => 'NYT RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count hukommelsesceller',
      one: '+1 hukommelsescelle',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Næste gang: immun over for $enemy ($bonus skade)';
  }

  @override
  String get roomChoiceTitle => 'VÆLG DIN VEJ';

  @override
  String get upgradeChoiceTitle => 'VÆLG CYTOKIN / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'Hvad er det? (Leksikon)';

  @override
  String hudStartingIn(int secs) {
    return 'STARTER OM $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'BØLGE $wave OM $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'BØLGE $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'BØLGE $wave — RYDDET!';
  }

  @override
  String bookToastOne(String name) {
    return 'Ny side i bogen: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nye sider i bogen: $name og flere ($count)';
  }
}
