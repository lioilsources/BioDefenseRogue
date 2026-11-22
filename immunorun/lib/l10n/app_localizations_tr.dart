// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get menuSubtitle => 'Bağışıklık hücresi enfeksiyona karşı';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp maks. HP';
  }

  @override
  String get menuStartRun => 'OYUNA BAŞLA';

  @override
  String get menuBook => 'SÖZLÜK';

  @override
  String get menuSoundOn => 'SES: AÇIK';

  @override
  String get menuSoundOff => 'SES: KAPALI';

  @override
  String get menuStatsOn => 'İSTATİSTİK: AÇIK';

  @override
  String get menuStatsOff => 'İSTATİSTİK: KAPALI';

  @override
  String get pauseTitle => 'DURAKLATILDI';

  @override
  String get pauseResume => 'DEVAM ET';

  @override
  String get pauseRestart => 'YENİDEN BAŞLAT';

  @override
  String get backToMenu => 'MENÜYE DÖN';

  @override
  String get gameOverTitle => 'OYUN BİTTİ';

  @override
  String gameOverWaves(int count) {
    return 'Atlatılan dalga: $count';
  }

  @override
  String get gameOverInstant => 'Hemen düştün.';

  @override
  String get gameOverCause => 'BENİ NE ÖLDÜRDÜ?';

  @override
  String get gameOverRetry => 'TEKRAR DENE';

  @override
  String get runWonTitle => 'BAĞIŞIKLIK KAZANILDI';

  @override
  String get runWonSubtitle => 'Patojen yok edildi. Konak hayatta kaldı.';

  @override
  String get runWonNewRun => 'YENİ OYUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count bellek hücresi',
      one: '+$count bellek hücresi',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Bir dahaki sefere: bağışıklık — $enemy ($bonus hasar)';
  }

  @override
  String get roomChoiceTitle => 'YOLUNU SEÇ';

  @override
  String get upgradeChoiceTitle => 'SİTOKİN / RESEPTÖR SEÇ';

  @override
  String get upgradeInfoTooltip => 'Bu nedir? (Sözlük)';

  @override
  String hudStartingIn(int secs) {
    return '$secs sn SONRA BAŞLIYOR';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return '$wave. DALGA $secs sn SONRA';
  }

  @override
  String hudWave(int wave) {
    return '$wave. DALGA';
  }

  @override
  String hudWaveCleared(int wave) {
    return '$wave. DALGA — TEMİZLENDİ!';
  }

  @override
  String bookToastOne(String name) {
    return 'Kitapta yeni sayfa: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Kitapta yeni sayfalar: $name ve diğerleri ($count)';
  }
}
