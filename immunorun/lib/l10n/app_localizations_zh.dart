// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get menuSubtitle => '免疫细胞大战感染';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name：$count  ·  最大 HP +$hp';
  }

  @override
  String get menuStartRun => '开始一局';

  @override
  String get menuBook => '百科';

  @override
  String get menuSoundOn => '声音：开';

  @override
  String get menuSoundOff => '声音：关';

  @override
  String get menuStatsOn => '统计：开';

  @override
  String get menuStatsOff => '统计：关';

  @override
  String get pauseTitle => '暂停';

  @override
  String get pauseResume => '继续';

  @override
  String get pauseRestart => '重新开始本局';

  @override
  String get backToMenu => '返回菜单';

  @override
  String get gameOverTitle => '游戏结束';

  @override
  String gameOverWaves(int count) {
    return '撑过的波次：$count';
  }

  @override
  String get gameOverInstant => '你一开始就倒下了。';

  @override
  String get gameOverCause => '我是被什么打败的？';

  @override
  String get gameOverRetry => '再试一次';

  @override
  String get runWonTitle => '获得免疫';

  @override
  String get runWonSubtitle => '病原体已被消灭。宿主活了下来。';

  @override
  String get runWonNewRun => '新的一局';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '记忆细胞 +$count',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return '下一局：已免疫 — $enemy（伤害 $bonus）';
  }

  @override
  String get roomChoiceTitle => '选择道路';

  @override
  String get upgradeChoiceTitle => '选择细胞因子 / 受体';

  @override
  String get upgradeInfoTooltip => '这是什么？（百科）';

  @override
  String hudStartingIn(int secs) {
    return '$secs 秒后开始';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return '$secs 秒后第 $wave 波';
  }

  @override
  String hudWave(int wave) {
    return '第 $wave 波';
  }

  @override
  String hudWaveCleared(int wave) {
    return '第 $wave 波 — 已清除！';
  }

  @override
  String bookToastOne(String name) {
    return '书中新页面：$name';
  }

  @override
  String bookToastMany(String name, int count) {
    return '书中新页面：$name 等（$count）';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get menuSubtitle => '免疫細胞大戰感染';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name：$count  ·  最大 HP +$hp';
  }

  @override
  String get menuStartRun => '開始一局';

  @override
  String get menuBook => '百科';

  @override
  String get menuSoundOn => '聲音：開';

  @override
  String get menuSoundOff => '聲音：關';

  @override
  String get menuStatsOn => '統計：開';

  @override
  String get menuStatsOff => '統計：關';

  @override
  String get pauseTitle => '暫停';

  @override
  String get pauseResume => '繼續';

  @override
  String get pauseRestart => '重新開始本局';

  @override
  String get backToMenu => '返回選單';

  @override
  String get gameOverTitle => '遊戲結束';

  @override
  String gameOverWaves(int count) {
    return '撐過的波次：$count';
  }

  @override
  String get gameOverInstant => '你一開始就倒下了。';

  @override
  String get gameOverCause => '我是被什麼打敗的？';

  @override
  String get gameOverRetry => '再試一次';

  @override
  String get runWonTitle => '獲得免疫';

  @override
  String get runWonSubtitle => '病原體已被消滅。宿主活了下來。';

  @override
  String get runWonNewRun => '新的一局';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '記憶細胞 +$count',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return '下一局：已免疫 — $enemy（傷害 $bonus）';
  }

  @override
  String get roomChoiceTitle => '選擇道路';

  @override
  String get upgradeChoiceTitle => '選擇細胞激素 / 受體';

  @override
  String get upgradeInfoTooltip => '這是什麼？（百科）';

  @override
  String hudStartingIn(int secs) {
    return '$secs 秒後開始';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return '$secs 秒後第 $wave 波';
  }

  @override
  String hudWave(int wave) {
    return '第 $wave 波';
  }

  @override
  String hudWaveCleared(int wave) {
    return '第 $wave 波 — 已清除！';
  }

  @override
  String bookToastOne(String name) {
    return '書中新頁面：$name';
  }

  @override
  String bookToastMany(String name, int count) {
    return '書中新頁面：$name 等（$count）';
  }
}
