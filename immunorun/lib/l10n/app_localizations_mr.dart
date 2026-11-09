// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get menuSubtitle => 'रोगप्रतिकारक पेशी विरुद्ध संसर्ग';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp कमाल HP';
  }

  @override
  String get menuStartRun => 'रन सुरू करा';

  @override
  String get menuBook => 'शब्दकोश';

  @override
  String get menuSoundOn => 'आवाज: चालू';

  @override
  String get menuSoundOff => 'आवाज: बंद';

  @override
  String get pauseTitle => 'विराम';

  @override
  String get pauseResume => 'पुढे चला';

  @override
  String get pauseRestart => 'रन पुन्हा सुरू करा';

  @override
  String get backToMenu => 'मेनूवर परत';

  @override
  String get gameOverTitle => 'खेळ संपला';

  @override
  String gameOverWaves(int count) {
    return 'तग धरलेल्या लाटा: $count';
  }

  @override
  String get gameOverInstant => 'तू लगेच पडलास.';

  @override
  String get gameOverCause => 'मला कशाने हरवले?';

  @override
  String get gameOverRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get runWonTitle => 'प्रतिकारशक्ती मिळाली';

  @override
  String get runWonSubtitle => 'रोगजंतू नष्ट झाला. यजमान वाचला.';

  @override
  String get runWonNewRun => 'नवीन रन';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count स्मृती पेशी',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'पुढच्या वेळी: प्रतिकारशक्ती — $enemy ($bonus नुकसान)';
  }

  @override
  String get roomChoiceTitle => 'मार्ग निवडा';

  @override
  String get upgradeChoiceTitle => 'सायटोकाइन / रिसेप्टर निवडा';

  @override
  String get upgradeInfoTooltip => 'हे काय आहे? (शब्दकोश)';

  @override
  String hudStartingIn(int secs) {
    return '$secs सेकंदांत सुरू';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'लाट $wave — $secs सेकंदांत';
  }

  @override
  String hudWave(int wave) {
    return 'लाट $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'लाट $wave — साफ!';
  }

  @override
  String bookToastOne(String name) {
    return 'पुस्तकात नवे पान: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'पुस्तकात नवी पाने: $name आणि इतर ($count)';
  }
}
