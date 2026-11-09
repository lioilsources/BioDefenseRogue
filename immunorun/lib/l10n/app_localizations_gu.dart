// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get menuSubtitle => 'રોગપ્રતિકારક કોષ વિરુદ્ધ ચેપ';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp મહત્તમ HP';
  }

  @override
  String get menuStartRun => 'રન શરૂ કરો';

  @override
  String get menuBook => 'શબ્દકોશ';

  @override
  String get menuSoundOn => 'અવાજ: ચાલુ';

  @override
  String get menuSoundOff => 'અવાજ: બંધ';

  @override
  String get pauseTitle => 'વિરામ';

  @override
  String get pauseResume => 'ચાલુ રાખો';

  @override
  String get pauseRestart => 'રન ફરી શરૂ કરો';

  @override
  String get backToMenu => 'મેનૂ પર પાછા';

  @override
  String get gameOverTitle => 'રમત પૂરી';

  @override
  String gameOverWaves(int count) {
    return 'ટકી રહેલા મોજાં: $count';
  }

  @override
  String get gameOverInstant => 'તમે તરત જ પડી ગયા.';

  @override
  String get gameOverCause => 'મને કોણે હરાવ્યો?';

  @override
  String get gameOverRetry => 'ફરી પ્રયાસ કરો';

  @override
  String get runWonTitle => 'રોગપ્રતિકારકતા મળી';

  @override
  String get runWonSubtitle => 'રોગાણુ નાશ પામ્યો. યજમાન બચી ગયો.';

  @override
  String get runWonNewRun => 'નવો રન';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count સ્મૃતિ કોષ',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'આગલી વખતે: રોગપ્રતિકારકતા — $enemy ($bonus નુકસાન)';
  }

  @override
  String get roomChoiceTitle => 'રસ્તો પસંદ કરો';

  @override
  String get upgradeChoiceTitle => 'સાયટોકાઇન / રિસેપ્ટર પસંદ કરો';

  @override
  String get upgradeInfoTooltip => 'આ શું છે? (શબ્દકોશ)';

  @override
  String hudStartingIn(int secs) {
    return '$secs સેકન્ડમાં શરૂ';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'મોજું $wave — $secs સેકન્ડમાં';
  }

  @override
  String hudWave(int wave) {
    return 'મોજું $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'મોજું $wave — સાફ!';
  }

  @override
  String bookToastOne(String name) {
    return 'પુસ્તકમાં નવું પાનું: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'પુસ્તકમાં નવાં પાનાં: $name અને વધુ ($count)';
  }
}
