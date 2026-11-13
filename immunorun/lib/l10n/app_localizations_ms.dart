// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get menuSubtitle => 'Sel imun lawan jangkitan';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp HP maks';
  }

  @override
  String get menuStartRun => 'MULA LARIAN';

  @override
  String get menuBook => 'LEKSIKON';

  @override
  String get menuSoundOn => 'BUNYI: HIDUP';

  @override
  String get menuSoundOff => 'BUNYI: MATI';

  @override
  String get pauseTitle => 'JEDA';

  @override
  String get pauseResume => 'SAMBUNG';

  @override
  String get pauseRestart => 'MULA SEMULA';

  @override
  String get backToMenu => 'KEMBALI KE MENU';

  @override
  String get gameOverTitle => 'PERMAINAN TAMAT';

  @override
  String gameOverWaves(int count) {
    return 'Gelombang yang ditempuh: $count';
  }

  @override
  String get gameOverInstant => 'Anda tumbang serta-merta.';

  @override
  String get gameOverCause => 'APA YANG MEMBUNUH SAYA?';

  @override
  String get gameOverRetry => 'CUBA LAGI';

  @override
  String get runWonTitle => 'IMUNITI DICAPAI';

  @override
  String get runWonSubtitle => 'Patogen dimusnahkan. Perumah terselamat.';

  @override
  String get runWonNewRun => 'LARIAN BAHARU';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count sel memori',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Lain kali: imun terhadap $enemy ($bonus kerosakan)';
  }

  @override
  String get roomChoiceTitle => 'PILIH LALUAN';

  @override
  String get upgradeChoiceTitle => 'PILIH SITOKIN / RESEPTOR';

  @override
  String get upgradeInfoTooltip => 'Apakah ini? (Leksikon)';

  @override
  String hudStartingIn(int secs) {
    return 'BERMULA DALAM $secs saat';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'GELOMBANG $wave DALAM $secs saat';
  }

  @override
  String hudWave(int wave) {
    return 'GELOMBANG $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'GELOMBANG $wave — DIBERSIHKAN!';
  }

  @override
  String bookToastOne(String name) {
    return 'Halaman baharu dalam buku: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Halaman baharu dalam buku: $name dan lain-lain ($count)';
  }
}
