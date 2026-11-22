// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get menuSubtitle => 'Иммунная клетка против инфекции';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp к макс. HP';
  }

  @override
  String get menuStartRun => 'НАЧАТЬ ЗАБЕГ';

  @override
  String get menuBook => 'ЛЕКСИКОН';

  @override
  String get menuSoundOn => 'ЗВУК: ВКЛ';

  @override
  String get menuSoundOff => 'ЗВУК: ВЫКЛ';

  @override
  String get menuStatsOn => 'СТАТИСТИКА: ВКЛ';

  @override
  String get menuStatsOff => 'СТАТИСТИКА: ВЫКЛ';

  @override
  String get pauseTitle => 'ПАУЗА';

  @override
  String get pauseResume => 'ПРОДОЛЖИТЬ';

  @override
  String get pauseRestart => 'ЗАНОВО';

  @override
  String get backToMenu => 'В МЕНЮ';

  @override
  String get gameOverTitle => 'ИГРА ОКОНЧЕНА';

  @override
  String gameOverWaves(int count) {
    return 'Пережито волн: $count';
  }

  @override
  String get gameOverInstant => 'Ты пал сразу.';

  @override
  String get gameOverCause => 'ЧТО МЕНЯ УБИЛО?';

  @override
  String get gameOverRetry => 'ЕЩЁ РАЗ';

  @override
  String get runWonTitle => 'ИММУНИТЕТ ДОСТИГНУТ';

  @override
  String get runWonSubtitle => 'Патоген уничтожен. Хозяин выжил.';

  @override
  String get runWonNewRun => 'НОВЫЙ ЗАБЕГ';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count клетки памяти',
      many: '+$count клеток памяти',
      few: '+$count клетки памяти',
      one: '+$count клетка памяти',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'В следующий раз: иммунитет — $enemy ($bonus урона)';
  }

  @override
  String get roomChoiceTitle => 'ВЫБЕРИ ПУТЬ';

  @override
  String get upgradeChoiceTitle => 'ВЫБЕРИ ЦИТОКИН / РЕЦЕПТОР';

  @override
  String get upgradeInfoTooltip => 'Что это? (Лексикон)';

  @override
  String hudStartingIn(int secs) {
    return 'СТАРТ ЧЕРЕЗ $secs с';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ВОЛНА $wave ЧЕРЕЗ $secs с';
  }

  @override
  String hudWave(int wave) {
    return 'ВОЛНА $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ВОЛНА $wave — ЗАЧИЩЕНО!';
  }

  @override
  String bookToastOne(String name) {
    return 'Новая страница в книге: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Новые страницы в книге: $name и другие ($count)';
  }
}
