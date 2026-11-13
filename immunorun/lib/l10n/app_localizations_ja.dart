// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get menuSubtitle => '免疫細胞 vs. 感染症';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name：$count  ·  最大HP +$hp';
  }

  @override
  String get menuStartRun => 'ラン開始';

  @override
  String get menuBook => '図鑑';

  @override
  String get menuSoundOn => 'サウンド：オン';

  @override
  String get menuSoundOff => 'サウンド：オフ';

  @override
  String get pauseTitle => 'ポーズ';

  @override
  String get pauseResume => 'つづける';

  @override
  String get pauseRestart => 'ランをやり直す';

  @override
  String get backToMenu => 'メニューへ戻る';

  @override
  String get gameOverTitle => 'ゲームオーバー';

  @override
  String gameOverWaves(int count) {
    return '生き延びたウェーブ：$count';
  }

  @override
  String get gameOverInstant => 'すぐにやられてしまった。';

  @override
  String get gameOverCause => '何にやられた？';

  @override
  String get gameOverRetry => 'もう一度';

  @override
  String get runWonTitle => '免疫を獲得';

  @override
  String get runWonSubtitle => '病原体を撃退。宿主は生き延びた。';

  @override
  String get runWonNewRun => '新しいラン';

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
    return '次回：免疫獲得 — $enemy（ダメージ $bonus）';
  }

  @override
  String get roomChoiceTitle => '道を選べ';

  @override
  String get upgradeChoiceTitle => 'サイトカイン／受容体を選べ';

  @override
  String get upgradeInfoTooltip => 'これは何？（図鑑）';

  @override
  String hudStartingIn(int secs) {
    return 'あと$secs秒で開始';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ウェーブ$waveまであと$secs秒';
  }

  @override
  String hudWave(int wave) {
    return 'ウェーブ$wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ウェーブ$wave — クリア！';
  }

  @override
  String bookToastOne(String name) {
    return '本に新しいページ：$name';
  }

  @override
  String bookToastMany(String name, int count) {
    return '本に新しいページ：$nameほか（$count）';
  }
}
