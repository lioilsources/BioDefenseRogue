// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get menuSubtitle => 'خلية مناعية ضد العدوى';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp أقصى HP';
  }

  @override
  String get menuStartRun => 'ابدأ الجولة';

  @override
  String get menuBook => 'المعجم';

  @override
  String get menuSoundOn => 'الصوت: تشغيل';

  @override
  String get menuSoundOff => 'الصوت: إيقاف';

  @override
  String get menuStatsOn => 'الإحصاءات: تشغيل';

  @override
  String get menuStatsOff => 'الإحصاءات: إيقاف';

  @override
  String get pauseTitle => 'إيقاف مؤقت';

  @override
  String get pauseResume => 'متابعة';

  @override
  String get pauseRestart => 'إعادة الجولة';

  @override
  String get backToMenu => 'العودة إلى القائمة';

  @override
  String get gameOverTitle => 'انتهت اللعبة';

  @override
  String gameOverWaves(int count) {
    return 'الموجات التي نجوت منها: $count';
  }

  @override
  String get gameOverInstant => 'سقطت على الفور.';

  @override
  String get gameOverCause => 'ما الذي قتلني؟';

  @override
  String get gameOverRetry => 'حاول مجددًا';

  @override
  String get runWonTitle => 'تحققت المناعة';

  @override
  String get runWonSubtitle => 'دُمّر العامل الممرض. نجا المضيف.';

  @override
  String get runWonNewRun => 'جولة جديدة';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count خلية ذاكرة',
      many: '+$count خلية ذاكرة',
      few: '+$count خلايا ذاكرة',
      two: '+خليتا ذاكرة',
      one: '+خلية ذاكرة واحدة',
      zero: '+$count خلية ذاكرة',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'في المرة القادمة: مناعة — $enemy ($bonus ضرر)';
  }

  @override
  String get roomChoiceTitle => 'اختر طريقك';

  @override
  String get upgradeChoiceTitle => 'اختر سيتوكينًا / مستقبِلًا';

  @override
  String get upgradeInfoTooltip => 'ما هذا؟ (المعجم)';

  @override
  String hudStartingIn(int secs) {
    return 'البداية بعد $secs ث';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'الموجة $wave بعد $secs ث';
  }

  @override
  String hudWave(int wave) {
    return 'الموجة $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'الموجة $wave — تم التطهير!';
  }

  @override
  String bookToastOne(String name) {
    return 'صفحة جديدة في الكتاب: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'صفحات جديدة في الكتاب: $name وغيرها ($count)';
  }
}
