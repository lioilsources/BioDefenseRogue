// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get menuSubtitle => 'நோய் எதிர்ப்பு செல் vs. தொற்று';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp அதிகபட்ச HP';
  }

  @override
  String get menuStartRun => 'ரன் தொடங்கு';

  @override
  String get menuBook => 'அகராதி';

  @override
  String get menuSoundOn => 'ஒலி: இயக்கு';

  @override
  String get menuSoundOff => 'ஒலி: அணை';

  @override
  String get menuStatsOn => 'புள்ளிவிவரம்: இயக்கு';

  @override
  String get menuStatsOff => 'புள்ளிவிவரம்: அணை';

  @override
  String get pauseTitle => 'இடைநிறுத்தம்';

  @override
  String get pauseResume => 'தொடர்';

  @override
  String get pauseRestart => 'ரன் மீண்டும் தொடங்கு';

  @override
  String get backToMenu => 'மெனுவுக்குத் திரும்பு';

  @override
  String get gameOverTitle => 'ஆட்டம் முடிந்தது';

  @override
  String gameOverWaves(int count) {
    return 'தாங்கிய அலைகள்: $count';
  }

  @override
  String get gameOverInstant => 'நீ உடனே விழுந்துவிட்டாய்.';

  @override
  String get gameOverCause => 'என்னை எது வீழ்த்தியது?';

  @override
  String get gameOverRetry => 'மீண்டும் முயல்';

  @override
  String get runWonTitle => 'நோய் எதிர்ப்பு அடைந்தது';

  @override
  String get runWonSubtitle => 'நோய்க்கிருமி அழிந்தது. உடல் பிழைத்தது.';

  @override
  String get runWonNewRun => 'புதிய ரன்';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count நினைவு செல்கள்',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'அடுத்த முறை: நோய் எதிர்ப்பு — $enemy ($bonus சேதம்)';
  }

  @override
  String get roomChoiceTitle => 'பாதையைத் தேர்ந்தெடு';

  @override
  String get upgradeChoiceTitle => 'சைட்டோகைன் / ஏற்பியைத் தேர்ந்தெடு';

  @override
  String get upgradeInfoTooltip => 'இது என்ன? (அகராதி)';

  @override
  String hudStartingIn(int secs) {
    return '$secs வினாடியில் தொடக்கம்';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'அலை $wave — $secs வினாடியில்';
  }

  @override
  String hudWave(int wave) {
    return 'அலை $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'அலை $wave — சுத்தம்!';
  }

  @override
  String bookToastOne(String name) {
    return 'புத்தகத்தில் புதிய பக்கம்: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'புத்தகத்தில் புதிய பக்கங்கள்: $name மற்றும் பல ($count)';
  }
}
