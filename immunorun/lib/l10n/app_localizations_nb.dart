// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get menuSubtitle => 'Immuncelle mot infeksjon';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp maks HP';
  }

  @override
  String get menuStartRun => 'START RUN';

  @override
  String get menuBook => 'LEKSIKON';

  @override
  String get menuSoundOn => 'LYD: PÅ';

  @override
  String get menuSoundOff => 'LYD: AV';

  @override
  String get menuStatsOn => 'STATISTIKK: PÅ';

  @override
  String get menuStatsOff => 'STATISTIKK: AV';

  @override
  String get pauseTitle => 'PAUSE';

  @override
  String get pauseResume => 'FORTSETT';

  @override
  String get pauseRestart => 'START RUN PÅ NYTT';

  @override
  String get backToMenu => 'TILBAKE TIL MENYEN';

  @override
  String get gameOverTitle => 'GAME OVER';

  @override
  String gameOverWaves(int count) {
    return 'Overlevde bølger: $count';
  }

  @override
  String get gameOverInstant => 'Du falt med en gang.';

  @override
  String get gameOverCause => 'HVA DREPTE MEG?';

  @override
  String get gameOverRetry => 'PRØV IGJEN';

  @override
  String get runWonTitle => 'IMMUNITET OPPNÅDD';

  @override
  String get runWonSubtitle => 'Patogenet er utslettet. Verten overlevde.';

  @override
  String get runWonNewRun => 'NY RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count minneceller',
      one: '+1 minnecelle',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Neste gang: immun mot $enemy ($bonus skade)';
  }

  @override
  String get roomChoiceTitle => 'VELG VEI';

  @override
  String get upgradeChoiceTitle => 'VELG CYTOKIN / RESEPTOR';

  @override
  String get upgradeInfoTooltip => 'Hva er dette? (Leksikon)';

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
    return 'Ny side i boka: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nye sider i boka: $name og flere ($count)';
  }
}
