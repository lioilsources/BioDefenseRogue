// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get menuSubtitle => '면역 세포 대 감염';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  최대 HP +$hp';
  }

  @override
  String get menuStartRun => '런 시작';

  @override
  String get menuBook => '백과사전';

  @override
  String get menuSoundOn => '소리: 켜짐';

  @override
  String get menuSoundOff => '소리: 꺼짐';

  @override
  String get menuStatsOn => '통계: 켜짐';

  @override
  String get menuStatsOff => '통계: 꺼짐';

  @override
  String get pauseTitle => '일시 정지';

  @override
  String get pauseResume => '계속하기';

  @override
  String get pauseRestart => '런 다시 시작';

  @override
  String get backToMenu => '메뉴로 돌아가기';

  @override
  String get gameOverTitle => '게임 오버';

  @override
  String gameOverWaves(int count) {
    return '버틴 웨이브: $count';
  }

  @override
  String get gameOverInstant => '곧바로 쓰러졌어요.';

  @override
  String get gameOverCause => '무엇에 당했을까?';

  @override
  String get gameOverRetry => '다시 도전';

  @override
  String get runWonTitle => '면역 획득';

  @override
  String get runWonSubtitle => '병원체를 물리쳤어요. 숙주가 살아남았어요.';

  @override
  String get runWonNewRun => '새 런';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '기억 세포 +$count',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return '다음 번: 면역 — $enemy (피해 $bonus)';
  }

  @override
  String get roomChoiceTitle => '길을 고르세요';

  @override
  String get upgradeChoiceTitle => '사이토카인 / 수용체를 고르세요';

  @override
  String get upgradeInfoTooltip => '이게 뭐예요? (백과사전)';

  @override
  String hudStartingIn(int secs) {
    return '$secs초 후 시작';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return '$secs초 후 웨이브 $wave';
  }

  @override
  String hudWave(int wave) {
    return '웨이브 $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return '웨이브 $wave — 클리어!';
  }

  @override
  String bookToastOne(String name) {
    return '책에 새 페이지: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return '책에 새 페이지: $name 외 ($count)';
  }
}
