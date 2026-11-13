// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get menuSubtitle => 'Sel imun lawan infeksi';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp HP maks';
  }

  @override
  String get menuStartRun => 'MULAI RUN';

  @override
  String get menuBook => 'LEKSIKON';

  @override
  String get menuSoundOn => 'SUARA: AKTIF';

  @override
  String get menuSoundOff => 'SUARA: MATI';

  @override
  String get pauseTitle => 'JEDA';

  @override
  String get pauseResume => 'LANJUTKAN';

  @override
  String get pauseRestart => 'ULANGI RUN';

  @override
  String get backToMenu => 'KEMBALI KE MENU';

  @override
  String get gameOverTitle => 'PERMAINAN BERAKHIR';

  @override
  String gameOverWaves(int count) {
    return 'Gelombang yang dilalui: $count';
  }

  @override
  String get gameOverInstant => 'Kamu langsung tumbang.';

  @override
  String get gameOverCause => 'APA YANG MEMBUNUHKU?';

  @override
  String get gameOverRetry => 'COBA LAGI';

  @override
  String get runWonTitle => 'IMUNITAS TERCAPAI';

  @override
  String get runWonSubtitle => 'Patogen dihancurkan. Inang selamat.';

  @override
  String get runWonNewRun => 'RUN BARU';

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
    return 'Lain kali: kebal terhadap $enemy ($bonus kerusakan)';
  }

  @override
  String get roomChoiceTitle => 'PILIH JALAN';

  @override
  String get upgradeChoiceTitle => 'PILIH SITOKIN / RESEPTOR';

  @override
  String get upgradeInfoTooltip => 'Apa ini? (Leksikon)';

  @override
  String hudStartingIn(int secs) {
    return 'MULAI DALAM $secs dtk';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'GELOMBANG $wave DALAM $secs dtk';
  }

  @override
  String hudWave(int wave) {
    return 'GELOMBANG $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'GELOMBANG $wave — BERSIH!';
  }

  @override
  String bookToastOne(String name) {
    return 'Halaman baru di buku: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Halaman baru di buku: $name dan lainnya ($count)';
  }
}
