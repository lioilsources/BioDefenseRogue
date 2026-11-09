// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get menuSubtitle => 'مدافعتی خلیہ بمقابلہ انفیکشن';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp زیادہ سے زیادہ HP';
  }

  @override
  String get menuStartRun => 'رن شروع کریں';

  @override
  String get menuBook => 'لغت';

  @override
  String get menuSoundOn => 'آواز: آن';

  @override
  String get menuSoundOff => 'آواز: آف';

  @override
  String get pauseTitle => 'وقفہ';

  @override
  String get pauseResume => 'جاری رکھیں';

  @override
  String get pauseRestart => 'رن دوبارہ شروع کریں';

  @override
  String get backToMenu => 'مینو پر واپس';

  @override
  String get gameOverTitle => 'کھیل ختم';

  @override
  String gameOverWaves(int count) {
    return 'جھیلی گئی لہریں: $count';
  }

  @override
  String get gameOverInstant => 'تم فوراً گر گئے۔';

  @override
  String get gameOverCause => 'مجھے کس نے ہرایا؟';

  @override
  String get gameOverRetry => 'دوبارہ کوشش کریں';

  @override
  String get runWonTitle => 'مدافعت حاصل';

  @override
  String get runWonSubtitle => 'جراثیم تباہ ہو گیا۔ میزبان بچ گیا۔';

  @override
  String get runWonNewRun => 'نیا رن';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count یادداشتی خلیے',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'اگلی بار: مدافعت — $enemy ($bonus نقصان)';
  }

  @override
  String get roomChoiceTitle => 'راستہ چنیں';

  @override
  String get upgradeChoiceTitle => 'سائٹوکائن / ریسیپٹر چنیں';

  @override
  String get upgradeInfoTooltip => 'یہ کیا ہے؟ (لغت)';

  @override
  String hudStartingIn(int secs) {
    return '$secs سیکنڈ میں شروع';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'لہر $wave — $secs سیکنڈ میں';
  }

  @override
  String hudWave(int wave) {
    return 'لہر $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'لہر $wave — صاف!';
  }

  @override
  String bookToastOne(String name) {
    return 'کتاب میں نیا صفحہ: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'کتاب میں نئے صفحات: $name اور دیگر ($count)';
  }
}
