// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get menuSubtitle => 'Immuunisolu vastaan infektio';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp maks. HP';
  }

  @override
  String get menuStartRun => 'ALOITA RUN';

  @override
  String get menuBook => 'TIETOSANAKIRJA';

  @override
  String get menuSoundOn => 'ÄÄNI: PÄÄLLÄ';

  @override
  String get menuSoundOff => 'ÄÄNI: POIS';

  @override
  String get pauseTitle => 'TAUKO';

  @override
  String get pauseResume => 'JATKA';

  @override
  String get pauseRestart => 'ALOITA RUN ALUSTA';

  @override
  String get backToMenu => 'TAKAISIN VALIKKOON';

  @override
  String get gameOverTitle => 'PELI PÄÄTTYI';

  @override
  String gameOverWaves(int count) {
    return 'Selvitetyt aallot: $count';
  }

  @override
  String get gameOverInstant => 'Kaaduit heti.';

  @override
  String get gameOverCause => 'MIKÄ MINUT TAPPOI?';

  @override
  String get gameOverRetry => 'YRITÄ UUDELLEEN';

  @override
  String get runWonTitle => 'IMMUNITEETTI SAAVUTETTU';

  @override
  String get runWonSubtitle => 'Taudinaiheuttaja tuhottu. Isäntä selvisi.';

  @override
  String get runWonNewRun => 'UUSI RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count muistisolua',
      one: '+1 muistisolu',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Ensi kerralla: immuuni – $enemy ($bonus vahinkoa)';
  }

  @override
  String get roomChoiceTitle => 'VALITSE REITTI';

  @override
  String get upgradeChoiceTitle => 'VALITSE SYTOKIINI / RESEPTORI';

  @override
  String get upgradeInfoTooltip => 'Mikä tämä on? (Tietosanakirja)';

  @override
  String hudStartingIn(int secs) {
    return 'ALKAA $secs s KULUTTUA';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'AALTO $wave $secs s KULUTTUA';
  }

  @override
  String hudWave(int wave) {
    return 'AALTO $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'AALTO $wave — SELVITETTY!';
  }

  @override
  String bookToastOne(String name) {
    return 'Uusi sivu kirjassa: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Uusia sivuja kirjassa: $name ja muita ($count)';
  }
}
