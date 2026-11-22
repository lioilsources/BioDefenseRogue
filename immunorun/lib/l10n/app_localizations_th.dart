// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get menuSubtitle => 'เซลล์ภูมิคุ้มกันปะทะการติดเชื้อ';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  HP สูงสุด +$hp';
  }

  @override
  String get menuStartRun => 'เริ่มรอบ';

  @override
  String get menuBook => 'สารานุกรม';

  @override
  String get menuSoundOn => 'เสียง: เปิด';

  @override
  String get menuSoundOff => 'เสียง: ปิด';

  @override
  String get menuStatsOn => 'สถิติ: เปิด';

  @override
  String get menuStatsOff => 'สถิติ: ปิด';

  @override
  String get pauseTitle => 'หยุดชั่วคราว';

  @override
  String get pauseResume => 'เล่นต่อ';

  @override
  String get pauseRestart => 'เริ่มรอบใหม่';

  @override
  String get backToMenu => 'กลับไปที่เมนู';

  @override
  String get gameOverTitle => 'จบเกม';

  @override
  String gameOverWaves(int count) {
    return 'รอดมาได้: $count ระลอก';
  }

  @override
  String get gameOverInstant => 'คุณล้มลงทันที';

  @override
  String get gameOverCause => 'อะไรทำให้ฉันตาย?';

  @override
  String get gameOverRetry => 'ลองอีกครั้ง';

  @override
  String get runWonTitle => 'ได้รับภูมิคุ้มกันแล้ว';

  @override
  String get runWonSubtitle => 'กำจัดเชื้อโรคแล้ว ร่างกายรอดชีวิต';

  @override
  String get runWonNewRun => 'รอบใหม่';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เซลล์ความจำ +$count',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'ครั้งหน้า: มีภูมิคุ้มกันต่อ $enemy (ความเสียหาย $bonus)';
  }

  @override
  String get roomChoiceTitle => 'เลือกเส้นทาง';

  @override
  String get upgradeChoiceTitle => 'เลือกไซโทไคน์ / ตัวรับ';

  @override
  String get upgradeInfoTooltip => 'นี่คืออะไร? (สารานุกรม)';

  @override
  String hudStartingIn(int secs) {
    return 'เริ่มใน $secs วิ';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ระลอก $wave ใน $secs วิ';
  }

  @override
  String hudWave(int wave) {
    return 'ระลอก $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ระลอก $wave — เคลียร์แล้ว!';
  }

  @override
  String bookToastOne(String name) {
    return 'หน้าใหม่ในหนังสือ: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'หน้าใหม่ในหนังสือ: $name และอื่นๆ ($count)';
  }
}
