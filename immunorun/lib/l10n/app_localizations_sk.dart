// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get menuSubtitle => 'Imunitná bunka proti infekcii';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp max HP';
  }

  @override
  String get menuStartRun => 'SPUSTIŤ RUN';

  @override
  String get menuBook => 'LEXIKÓN';

  @override
  String get menuSoundOn => 'ZVUK: ZAP';

  @override
  String get menuSoundOff => 'ZVUK: VYP';

  @override
  String get menuStatsOn => 'ŠTATISTIKY: ZAP';

  @override
  String get menuStatsOff => 'ŠTATISTIKY: VYP';

  @override
  String get pauseTitle => 'PAUZA';

  @override
  String get pauseResume => 'POKRAČOVAŤ';

  @override
  String get pauseRestart => 'REŠTART RUNU';

  @override
  String get backToMenu => 'SPÄŤ DO MENU';

  @override
  String get gameOverTitle => 'GAME OVER';

  @override
  String gameOverWaves(int count) {
    return 'Prežité vlny: $count';
  }

  @override
  String get gameOverInstant => 'Padol si hneď.';

  @override
  String get gameOverCause => 'ČO MA ZABILO?';

  @override
  String get gameOverRetry => 'SKÚSIŤ ZNOVA';

  @override
  String get runWonTitle => 'IMUNITA DOSIAHNUTÁ';

  @override
  String get runWonSubtitle => 'Patogén zničený. Hostiteľ prežil.';

  @override
  String get runWonNewRun => 'NOVÝ RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count pamäťových buniek',
      few: '+$count pamäťové bunky',
      one: '+1 pamäťová bunka',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Nabudúce: imunizácia – $enemy ($bonus dmg)';
  }

  @override
  String get roomChoiceTitle => 'VYBER SI CESTU';

  @override
  String get upgradeChoiceTitle => 'VYBER CYTOKÍN / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'Čo to je? (Lexikón)';

  @override
  String hudStartingIn(int secs) {
    return 'ZAČÍNAME O $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'VLNA $wave O $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'VLNA $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'VLNA $wave — VYČISTENÉ!';
  }

  @override
  String bookToastOne(String name) {
    return 'Nová strana v knihe: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nové strany v knihe: $name a ďalšie ($count)';
  }
}
