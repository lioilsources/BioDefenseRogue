// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get menuSubtitle => 'ರೋಗನಿರೋಧಕ ಕೋಶ vs. ಸೋಂಕು';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp ಗರಿಷ್ಠ HP';
  }

  @override
  String get menuStartRun => 'ರನ್ ಆರಂಭಿಸು';

  @override
  String get menuBook => 'ನಿಘಂಟು';

  @override
  String get menuSoundOn => 'ಧ್ವನಿ: ಆನ್';

  @override
  String get menuSoundOff => 'ಧ್ವನಿ: ಆಫ್';

  @override
  String get pauseTitle => 'ವಿರಾಮ';

  @override
  String get pauseResume => 'ಮುಂದುವರಿಸು';

  @override
  String get pauseRestart => 'ರನ್ ಮತ್ತೆ ಆರಂಭಿಸು';

  @override
  String get backToMenu => 'ಮೆನುಗೆ ಹಿಂತಿರುಗು';

  @override
  String get gameOverTitle => 'ಆಟ ಮುಗಿಯಿತು';

  @override
  String gameOverWaves(int count) {
    return 'ತಡೆದುಕೊಂಡ ಅಲೆಗಳು: $count';
  }

  @override
  String get gameOverInstant => 'ನೀನು ತಕ್ಷಣ ಬಿದ್ದೆ.';

  @override
  String get gameOverCause => 'ನನ್ನನ್ನು ಯಾವುದು ಸೋಲಿಸಿತು?';

  @override
  String get gameOverRetry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸು';

  @override
  String get runWonTitle => 'ರೋಗನಿರೋಧಕತೆ ಸಾಧಿಸಲಾಯಿತು';

  @override
  String get runWonSubtitle => 'ರೋಗಕಾರಕ ನಾಶವಾಯಿತು. ಆತಿಥೇಯ ಬದುಕುಳಿಯಿತು.';

  @override
  String get runWonNewRun => 'ಹೊಸ ರನ್';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count ಸ್ಮೃತಿ ಕೋಶಗಳು',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'ಮುಂದಿನ ಬಾರಿ: ರೋಗನಿರೋಧಕತೆ — $enemy ($bonus ಹಾನಿ)';
  }

  @override
  String get roomChoiceTitle => 'ದಾರಿ ಆರಿಸು';

  @override
  String get upgradeChoiceTitle => 'ಸೈಟೋಕೈನ್ / ಗ್ರಾಹಕ ಆರಿಸು';

  @override
  String get upgradeInfoTooltip => 'ಇದು ಏನು? (ನಿಘಂಟು)';

  @override
  String hudStartingIn(int secs) {
    return '$secs ಸೆಕೆಂಡಿನಲ್ಲಿ ಆರಂಭ';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ಅಲೆ $wave — $secs ಸೆಕೆಂಡಿನಲ್ಲಿ';
  }

  @override
  String hudWave(int wave) {
    return 'ಅಲೆ $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ಅಲೆ $wave — ಸ್ವಚ್ಛ!';
  }

  @override
  String bookToastOne(String name) {
    return 'ಪುಸ್ತಕದಲ್ಲಿ ಹೊಸ ಪುಟ: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'ಪುಸ್ತಕದಲ್ಲಿ ಹೊಸ ಪುಟಗಳು: $name ಮತ್ತು ಇನ್ನಷ್ಟು ($count)';
  }
}
