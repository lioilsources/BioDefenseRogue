// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get menuSubtitle => 'Imunosna stanica protiv infekcije';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp maks. HP';
  }

  @override
  String get menuStartRun => 'POKRENI RUN';

  @override
  String get menuBook => 'LEKSIKON';

  @override
  String get menuSoundOn => 'ZVUK: UKLJ.';

  @override
  String get menuSoundOff => 'ZVUK: ISKLJ.';

  @override
  String get pauseTitle => 'PAUZA';

  @override
  String get pauseResume => 'NASTAVI';

  @override
  String get pauseRestart => 'PONOVI RUN';

  @override
  String get backToMenu => 'NATRAG NA IZBORNIK';

  @override
  String get gameOverTitle => 'KRAJ IGRE';

  @override
  String gameOverWaves(int count) {
    return 'Preživljeni valovi: $count';
  }

  @override
  String get gameOverInstant => 'Pao si odmah.';

  @override
  String get gameOverCause => 'ŠTO ME UBILO?';

  @override
  String get gameOverRetry => 'POKUŠAJ PONOVNO';

  @override
  String get runWonTitle => 'IMUNITET POSTIGNUT';

  @override
  String get runWonSubtitle => 'Patogen uništen. Domaćin je preživio.';

  @override
  String get runWonNewRun => 'NOVI RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count memorijskih stanica',
      few: '+$count memorijske stanice',
      one: '+$count memorijska stanica',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Sljedeći put: imunitet – $enemy ($bonus štete)';
  }

  @override
  String get roomChoiceTitle => 'ODABERI PUT';

  @override
  String get upgradeChoiceTitle => 'ODABERI CITOKIN / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'Što je to? (Leksikon)';

  @override
  String hudStartingIn(int secs) {
    return 'POČINJEMO ZA $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'VAL $wave ZA $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'VAL $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'VAL $wave — OČIŠĆENO!';
  }

  @override
  String bookToastOne(String name) {
    return 'Nova stranica u knjizi: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nove stranice u knjizi: $name i druge ($count)';
  }
}
