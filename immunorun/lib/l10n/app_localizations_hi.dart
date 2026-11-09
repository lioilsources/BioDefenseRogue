// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get menuSubtitle => 'प्रतिरक्षा कोशिका बनाम संक्रमण';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp अधिकतम HP';
  }

  @override
  String get menuStartRun => 'रन शुरू करें';

  @override
  String get menuBook => 'शब्दकोश';

  @override
  String get menuSoundOn => 'आवाज़: चालू';

  @override
  String get menuSoundOff => 'आवाज़: बंद';

  @override
  String get pauseTitle => 'रुका हुआ';

  @override
  String get pauseResume => 'जारी रखें';

  @override
  String get pauseRestart => 'रन फिर से शुरू करें';

  @override
  String get backToMenu => 'मेनू पर वापस';

  @override
  String get gameOverTitle => 'खेल खत्म';

  @override
  String gameOverWaves(int count) {
    return 'झेली गई लहरें: $count';
  }

  @override
  String get gameOverInstant => 'तुम तुरंत गिर गए।';

  @override
  String get gameOverCause => 'मुझे किसने हराया?';

  @override
  String get gameOverRetry => 'फिर कोशिश करें';

  @override
  String get runWonTitle => 'प्रतिरक्षा हासिल';

  @override
  String get runWonSubtitle => 'रोगाणु नष्ट हुआ। मेज़बान बच गया।';

  @override
  String get runWonNewRun => 'नया रन';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count स्मृति कोशिकाएँ',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'अगली बार: प्रतिरक्षा — $enemy ($bonus नुकसान)';
  }

  @override
  String get roomChoiceTitle => 'रास्ता चुनें';

  @override
  String get upgradeChoiceTitle => 'साइटोकाइन / रिसेप्टर चुनें';

  @override
  String get upgradeInfoTooltip => 'यह क्या है? (शब्दकोश)';

  @override
  String hudStartingIn(int secs) {
    return '$secs सेकंड में शुरू';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'लहर $wave — $secs सेकंड में';
  }

  @override
  String hudWave(int wave) {
    return 'लहर $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'लहर $wave — साफ़!';
  }

  @override
  String bookToastOne(String name) {
    return 'किताब में नया पन्ना: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'किताब में नए पन्ने: $name और अन्य ($count)';
  }
}
