// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get menuSubtitle => 'Komórka odpornościowa kontra infekcja';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp maks. HP';
  }

  @override
  String get menuStartRun => 'ROZPOCZNIJ RUN';

  @override
  String get menuBook => 'LEKSYKON';

  @override
  String get menuSoundOn => 'DŹWIĘK: WŁ.';

  @override
  String get menuSoundOff => 'DŹWIĘK: WYŁ.';

  @override
  String get menuStatsOn => 'STATYSTYKI: WŁ.';

  @override
  String get menuStatsOff => 'STATYSTYKI: WYŁ.';

  @override
  String get pauseTitle => 'PAUZA';

  @override
  String get pauseResume => 'KONTYNUUJ';

  @override
  String get pauseRestart => 'RESTART RUNU';

  @override
  String get backToMenu => 'WRÓĆ DO MENU';

  @override
  String get gameOverTitle => 'KONIEC GRY';

  @override
  String gameOverWaves(int count) {
    return 'Przetrwane fale: $count';
  }

  @override
  String get gameOverInstant => 'Padłeś od razu.';

  @override
  String get gameOverCause => 'CO MNIE ZABIŁO?';

  @override
  String get gameOverRetry => 'SPRÓBUJ PONOWNIE';

  @override
  String get runWonTitle => 'ODPORNOŚĆ OSIĄGNIĘTA';

  @override
  String get runWonSubtitle => 'Patogen zniszczony. Gospodarz przeżył.';

  @override
  String get runWonNewRun => 'NOWY RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count komórki pamięci',
      many: '+$count komórek pamięci',
      few: '+$count komórki pamięci',
      one: '+1 komórka pamięci',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Następnym razem: odporność – $enemy ($bonus obrażeń)';
  }

  @override
  String get roomChoiceTitle => 'WYBIERZ DROGĘ';

  @override
  String get upgradeChoiceTitle => 'WYBIERZ CYTOKINĘ / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'Co to jest? (Leksykon)';

  @override
  String hudStartingIn(int secs) {
    return 'START ZA $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'FALA $wave ZA $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'FALA $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'FALA $wave — OCZYSZCZONA!';
  }

  @override
  String bookToastOne(String name) {
    return 'Nowa strona w książce: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nowe strony w książce: $name i inne ($count)';
  }
}
