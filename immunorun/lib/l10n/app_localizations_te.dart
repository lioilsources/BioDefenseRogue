// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get menuSubtitle => 'రోగనిరోధక కణం vs. ఇన్ఫెక్షన్';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp గరిష్ఠ HP';
  }

  @override
  String get menuStartRun => 'రన్ ప్రారంభించు';

  @override
  String get menuBook => 'నిఘంటువు';

  @override
  String get menuSoundOn => 'శబ్దం: ఆన్';

  @override
  String get menuSoundOff => 'శబ్దం: ఆఫ్';

  @override
  String get pauseTitle => 'విరామం';

  @override
  String get pauseResume => 'కొనసాగించు';

  @override
  String get pauseRestart => 'రన్ మళ్లీ ప్రారంభించు';

  @override
  String get backToMenu => 'మెనూకి తిరిగి';

  @override
  String get gameOverTitle => 'ఆట ముగిసింది';

  @override
  String gameOverWaves(int count) {
    return 'తట్టుకున్న తరంగాలు: $count';
  }

  @override
  String get gameOverInstant => 'నువ్వు వెంటనే పడిపోయావు.';

  @override
  String get gameOverCause => 'నన్ను ఏది ఓడించింది?';

  @override
  String get gameOverRetry => 'మళ్లీ ప్రయత్నించు';

  @override
  String get runWonTitle => 'రోగనిరోధకత సాధించావు';

  @override
  String get runWonSubtitle => 'వ్యాధికారకం నాశనమైంది. ఆతిథేయి బతికింది.';

  @override
  String get runWonNewRun => 'కొత్త రన్';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count జ్ఞాపక కణాలు',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'తదుపరి సారి: రోగనిరోధకత — $enemy ($bonus నష్టం)';
  }

  @override
  String get roomChoiceTitle => 'దారి ఎంచుకో';

  @override
  String get upgradeChoiceTitle => 'సైటోకైన్ / గ్రాహకం ఎంచుకో';

  @override
  String get upgradeInfoTooltip => 'ఇది ఏమిటి? (నిఘంటువు)';

  @override
  String hudStartingIn(int secs) {
    return '$secs సెకన్లలో ప్రారంభం';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'తరంగం $wave — $secs సెకన్లలో';
  }

  @override
  String hudWave(int wave) {
    return 'తరంగం $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'తరంగం $wave — శుభ్రం!';
  }

  @override
  String bookToastOne(String name) {
    return 'పుస్తకంలో కొత్త పేజీ: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'పుస్తకంలో కొత్త పేజీలు: $name మరియు మరిన్ని ($count)';
  }
}
