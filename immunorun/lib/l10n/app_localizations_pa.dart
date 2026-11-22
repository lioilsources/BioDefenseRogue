// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get menuSubtitle => 'ਰੋਗ-ਰੋਧਕ ਸੈੱਲ ਬਨਾਮ ਲਾਗ';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp ਵੱਧ ਤੋਂ ਵੱਧ HP';
  }

  @override
  String get menuStartRun => 'ਰਨ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get menuBook => 'ਸ਼ਬਦਕੋਸ਼';

  @override
  String get menuSoundOn => 'ਆਵਾਜ਼: ਚਾਲੂ';

  @override
  String get menuSoundOff => 'ਆਵਾਜ਼: ਬੰਦ';

  @override
  String get menuStatsOn => 'ਅੰਕੜੇ: ਚਾਲੂ';

  @override
  String get menuStatsOff => 'ਅੰਕੜੇ: ਬੰਦ';

  @override
  String get pauseTitle => 'ਰੁਕਿਆ';

  @override
  String get pauseResume => 'ਜਾਰੀ ਰੱਖੋ';

  @override
  String get pauseRestart => 'ਰਨ ਮੁੜ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get backToMenu => 'ਮੀਨੂ \'ਤੇ ਵਾਪਸ';

  @override
  String get gameOverTitle => 'ਖੇਡ ਖਤਮ';

  @override
  String gameOverWaves(int count) {
    return 'ਝੱਲੀਆਂ ਲਹਿਰਾਂ: $count';
  }

  @override
  String get gameOverInstant => 'ਤੁਸੀਂ ਤੁਰੰਤ ਡਿੱਗ ਪਏ।';

  @override
  String get gameOverCause => 'ਮੈਨੂੰ ਕਿਸ ਨੇ ਹਰਾਇਆ?';

  @override
  String get gameOverRetry => 'ਫਿਰ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get runWonTitle => 'ਰੋਗ-ਰੋਧਕਤਾ ਹਾਸਲ';

  @override
  String get runWonSubtitle => 'ਰੋਗਾਣੂ ਨਸ਼ਟ ਹੋ ਗਿਆ। ਮੇਜ਼ਬਾਨ ਬਚ ਗਿਆ।';

  @override
  String get runWonNewRun => 'ਨਵਾਂ ਰਨ';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count ਯਾਦ ਸੈੱਲ',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'ਅਗਲੀ ਵਾਰ: ਰੋਗ-ਰੋਧਕਤਾ — $enemy ($bonus ਨੁਕਸਾਨ)';
  }

  @override
  String get roomChoiceTitle => 'ਰਾਹ ਚੁਣੋ';

  @override
  String get upgradeChoiceTitle => 'ਸਾਈਟੋਕਾਈਨ / ਰਿਸੈਪਟਰ ਚੁਣੋ';

  @override
  String get upgradeInfoTooltip => 'ਇਹ ਕੀ ਹੈ? (ਸ਼ਬਦਕੋਸ਼)';

  @override
  String hudStartingIn(int secs) {
    return '$secs ਸਕਿੰਟ ਵਿੱਚ ਸ਼ੁਰੂ';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ਲਹਿਰ $wave — $secs ਸਕਿੰਟ ਵਿੱਚ';
  }

  @override
  String hudWave(int wave) {
    return 'ਲਹਿਰ $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ਲਹਿਰ $wave — ਸਾਫ਼!';
  }

  @override
  String bookToastOne(String name) {
    return 'ਕਿਤਾਬ ਵਿੱਚ ਨਵਾਂ ਪੰਨਾ: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'ਕਿਤਾਬ ਵਿੱਚ ਨਵੇਂ ਪੰਨੇ: $name ਅਤੇ ਹੋਰ ($count)';
  }
}
