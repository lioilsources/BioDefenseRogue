// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get menuSubtitle => 'Immunzelle gegen Infektion';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp max. HP';
  }

  @override
  String get menuStartRun => 'RUN STARTEN';

  @override
  String get menuBook => 'LEXIKON';

  @override
  String get menuSoundOn => 'TON: AN';

  @override
  String get menuSoundOff => 'TON: AUS';

  @override
  String get pauseTitle => 'PAUSE';

  @override
  String get pauseResume => 'WEITER';

  @override
  String get pauseRestart => 'RUN NEU STARTEN';

  @override
  String get backToMenu => 'ZURÜCK ZUM MENÜ';

  @override
  String get gameOverTitle => 'GAME OVER';

  @override
  String gameOverWaves(int count) {
    return 'Überstandene Wellen: $count';
  }

  @override
  String get gameOverInstant => 'Du bist sofort gefallen.';

  @override
  String get gameOverCause => 'WAS HAT MICH BESIEGT?';

  @override
  String get gameOverRetry => 'NOCHMAL VERSUCHEN';

  @override
  String get runWonTitle => 'IMMUNITÄT ERREICHT';

  @override
  String get runWonSubtitle => 'Erreger vernichtet. Der Wirt hat überlebt.';

  @override
  String get runWonNewRun => 'NEUER RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count Gedächtniszellen',
      one: '+1 Gedächtniszelle',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Nächstes Mal: immun gegen $enemy ($bonus Schaden)';
  }

  @override
  String get roomChoiceTitle => 'WÄHLE DEINEN WEG';

  @override
  String get upgradeChoiceTitle => 'WÄHLE ZYTOKIN / REZEPTOR';

  @override
  String get upgradeInfoTooltip => 'Was ist das? (Lexikon)';

  @override
  String hudStartingIn(int secs) {
    return 'START IN $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'WELLE $wave IN $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'WELLE $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'WELLE $wave — GESÄUBERT!';
  }

  @override
  String bookToastOne(String name) {
    return 'Neue Seite im Buch: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Neue Seiten im Buch: $name und weitere ($count)';
  }
}
