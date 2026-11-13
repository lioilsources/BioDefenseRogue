// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get menuSubtitle => 'Імунна клітина проти інфекції';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp до макс. HP';
  }

  @override
  String get menuStartRun => 'ПОЧАТИ ЗАБІГ';

  @override
  String get menuBook => 'ЛЕКСИКОН';

  @override
  String get menuSoundOn => 'ЗВУК: УВІМК.';

  @override
  String get menuSoundOff => 'ЗВУК: ВИМК.';

  @override
  String get pauseTitle => 'ПАУЗА';

  @override
  String get pauseResume => 'ПРОДОВЖИТИ';

  @override
  String get pauseRestart => 'ПОЧАТИ ЗАНОВО';

  @override
  String get backToMenu => 'ДО МЕНЮ';

  @override
  String get gameOverTitle => 'ГРУ ЗАКІНЧЕНО';

  @override
  String gameOverWaves(int count) {
    return 'Пережито хвиль: $count';
  }

  @override
  String get gameOverInstant => 'Ти впав одразу.';

  @override
  String get gameOverCause => 'ЩО МЕНЕ ВБИЛО?';

  @override
  String get gameOverRetry => 'ЩЕ РАЗ';

  @override
  String get runWonTitle => 'ІМУНІТЕТ ДОСЯГНУТО';

  @override
  String get runWonSubtitle => 'Патоген знищено. Господар вижив.';

  @override
  String get runWonNewRun => 'НОВИЙ ЗАБІГ';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count клітини памʼяті',
      many: '+$count клітин памʼяті',
      few: '+$count клітини памʼяті',
      one: '+$count клітина памʼяті',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Наступного разу: імунітет — $enemy ($bonus шкоди)';
  }

  @override
  String get roomChoiceTitle => 'ОБЕРИ ШЛЯХ';

  @override
  String get upgradeChoiceTitle => 'ОБЕРИ ЦИТОКІН / РЕЦЕПТОР';

  @override
  String get upgradeInfoTooltip => 'Що це? (Лексикон)';

  @override
  String hudStartingIn(int secs) {
    return 'СТАРТ ЧЕРЕЗ $secs с';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ХВИЛЯ $wave ЧЕРЕЗ $secs с';
  }

  @override
  String hudWave(int wave) {
    return 'ХВИЛЯ $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ХВИЛЯ $wave — ЗАЧИЩЕНО!';
  }

  @override
  String bookToastOne(String name) {
    return 'Нова сторінка в книзі: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Нові сторінки в книзі: $name та інші ($count)';
  }
}
