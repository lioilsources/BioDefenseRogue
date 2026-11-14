// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get menuSubtitle => 'রোগপ্রতিরোধী কোষ বনাম সংক্রমণ';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp সর্বোচ্চ HP';
  }

  @override
  String get menuStartRun => 'রান শুরু করো';

  @override
  String get menuBook => 'অভিধান';

  @override
  String get menuSoundOn => 'শব্দ: চালু';

  @override
  String get menuSoundOff => 'শব্দ: বন্ধ';

  @override
  String get menuStatsOn => 'পরিসংখ্যান: চালু';

  @override
  String get menuStatsOff => 'পরিসংখ্যান: বন্ধ';

  @override
  String get pauseTitle => 'বিরতি';

  @override
  String get pauseResume => 'চালিয়ে যাও';

  @override
  String get pauseRestart => 'রান আবার শুরু করো';

  @override
  String get backToMenu => 'মেনুতে ফেরো';

  @override
  String get gameOverTitle => 'খেলা শেষ';

  @override
  String gameOverWaves(int count) {
    return 'টিকে থাকা ঢেউ: $count';
  }

  @override
  String get gameOverInstant => 'তুমি সঙ্গে সঙ্গে পড়ে গেলে।';

  @override
  String get gameOverCause => 'কে আমাকে হারাল?';

  @override
  String get gameOverRetry => 'আবার চেষ্টা করো';

  @override
  String get runWonTitle => 'প্রতিরোধক্ষমতা অর্জিত';

  @override
  String get runWonSubtitle => 'জীবাণু ধ্বংস হয়েছে। পোষক বেঁচে গেছে।';

  @override
  String get runWonNewRun => 'নতুন রান';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$countটি স্মৃতি কোষ',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'পরের বার: প্রতিরোধক্ষমতা — $enemy ($bonus ক্ষতি)';
  }

  @override
  String get roomChoiceTitle => 'পথ বেছে নাও';

  @override
  String get upgradeChoiceTitle => 'সাইটোকাইন / রিসেপ্টর বেছে নাও';

  @override
  String get upgradeInfoTooltip => 'এটা কী? (অভিধান)';

  @override
  String hudStartingIn(int secs) {
    return '$secs সেকেন্ডে শুরু';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ঢেউ $wave — $secs সেকেন্ডে';
  }

  @override
  String hudWave(int wave) {
    return 'ঢেউ $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ঢেউ $wave — পরিষ্কার!';
  }

  @override
  String bookToastOne(String name) {
    return 'বইয়ে নতুন পাতা: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'বইয়ে নতুন পাতা: $name ও আরও ($count)';
  }
}
