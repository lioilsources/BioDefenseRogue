// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get menuSubtitle => 'Tế bào miễn dịch đấu với nhiễm trùng';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp HP tối đa';
  }

  @override
  String get menuStartRun => 'BẮT ĐẦU LƯỢT';

  @override
  String get menuBook => 'TỪ ĐIỂN';

  @override
  String get menuSoundOn => 'ÂM THANH: BẬT';

  @override
  String get menuSoundOff => 'ÂM THANH: TẮT';

  @override
  String get pauseTitle => 'TẠM DỪNG';

  @override
  String get pauseResume => 'TIẾP TỤC';

  @override
  String get pauseRestart => 'CHƠI LẠI LƯỢT';

  @override
  String get backToMenu => 'VỀ MENU';

  @override
  String get gameOverTitle => 'KẾT THÚC';

  @override
  String gameOverWaves(int count) {
    return 'Số đợt sống sót: $count';
  }

  @override
  String get gameOverInstant => 'Bạn gục ngay lập tức.';

  @override
  String get gameOverCause => 'CÁI GÌ ĐÃ HẠ TÔI?';

  @override
  String get gameOverRetry => 'THỬ LẠI';

  @override
  String get runWonTitle => 'ĐÃ CÓ MIỄN DỊCH';

  @override
  String get runWonSubtitle => 'Mầm bệnh bị tiêu diệt. Vật chủ đã sống sót.';

  @override
  String get runWonNewRun => 'LƯỢT MỚI';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count tế bào nhớ',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Lần sau: miễn dịch với $enemy ($bonus sát thương)';
  }

  @override
  String get roomChoiceTitle => 'CHỌN ĐƯỜNG';

  @override
  String get upgradeChoiceTitle => 'CHỌN CYTOKINE / THỤ THỂ';

  @override
  String get upgradeInfoTooltip => 'Đây là gì? (Từ điển)';

  @override
  String hudStartingIn(int secs) {
    return 'BẮT ĐẦU SAU $secs giây';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ĐỢT $wave SAU $secs giây';
  }

  @override
  String hudWave(int wave) {
    return 'ĐỢT $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ĐỢT $wave — ĐÃ DỌN SẠCH!';
  }

  @override
  String bookToastOne(String name) {
    return 'Trang mới trong sách: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Trang mới trong sách: $name và thêm ($count)';
  }
}
