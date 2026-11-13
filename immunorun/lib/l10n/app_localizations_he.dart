// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get menuSubtitle => 'תא חיסוני נגד זיהום';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp HP מרבי';
  }

  @override
  String get menuStartRun => 'התחל ריצה';

  @override
  String get menuBook => 'לקסיקון';

  @override
  String get menuSoundOn => 'צליל: פועל';

  @override
  String get menuSoundOff => 'צליל: כבוי';

  @override
  String get pauseTitle => 'השהיה';

  @override
  String get pauseResume => 'המשך';

  @override
  String get pauseRestart => 'התחל ריצה מחדש';

  @override
  String get backToMenu => 'חזרה לתפריט';

  @override
  String get gameOverTitle => 'המשחק נגמר';

  @override
  String gameOverWaves(int count) {
    return 'גלים ששרדת: $count';
  }

  @override
  String get gameOverInstant => 'נפלת מיד.';

  @override
  String get gameOverCause => 'מה הרג אותי?';

  @override
  String get gameOverRetry => 'נסה שוב';

  @override
  String get runWonTitle => 'החסינות הושגה';

  @override
  String get runWonSubtitle => 'הפתוגן הושמד. המאכסן שרד.';

  @override
  String get runWonNewRun => 'ריצה חדשה';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count תאי זיכרון',
      two: '+$count תאי זיכרון',
      one: '+תא זיכרון אחד',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'בפעם הבאה: חסינות — $enemy ($bonus נזק)';
  }

  @override
  String get roomChoiceTitle => 'בחר דרך';

  @override
  String get upgradeChoiceTitle => 'בחר ציטוקין / קולטן';

  @override
  String get upgradeInfoTooltip => 'מה זה? (לקסיקון)';

  @override
  String hudStartingIn(int secs) {
    return 'מתחילים בעוד $secs שנ׳';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'גל $wave בעוד $secs שנ׳';
  }

  @override
  String hudWave(int wave) {
    return 'גל $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'גל $wave — נוקה!';
  }

  @override
  String bookToastOne(String name) {
    return 'עמוד חדש בספר: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'עמודים חדשים בספר: $name ועוד ($count)';
  }
}
