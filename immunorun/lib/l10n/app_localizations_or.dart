// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get menuSubtitle => 'ରୋଗପ୍ରତିରୋଧୀ କୋଷ ବନାମ ସଂକ୍ରମଣ';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp ସର୍ବାଧିକ HP';
  }

  @override
  String get menuStartRun => 'ରନ୍ ଆରମ୍ଭ କର';

  @override
  String get menuBook => 'ଶବ୍ଦକୋଷ';

  @override
  String get menuSoundOn => 'ଶବ୍ଦ: ଚାଲୁ';

  @override
  String get menuSoundOff => 'ଶବ୍ଦ: ବନ୍ଦ';

  @override
  String get pauseTitle => 'ବିରତି';

  @override
  String get pauseResume => 'ଜାରି ରଖ';

  @override
  String get pauseRestart => 'ରନ୍ ପୁଣି ଆରମ୍ଭ କର';

  @override
  String get backToMenu => 'ମେନୁକୁ ଫେରିଯାଅ';

  @override
  String get gameOverTitle => 'ଖେଳ ଶେଷ';

  @override
  String gameOverWaves(int count) {
    return 'ସହିଥିବା ଢେଉ: $count';
  }

  @override
  String get gameOverInstant => 'ତୁମେ ସଙ୍ଗେ ସଙ୍ଗେ ପଡ଼ିଗଲ।';

  @override
  String get gameOverCause => 'ମୋତେ କିଏ ହରାଇଲା?';

  @override
  String get gameOverRetry => 'ପୁଣି ଚେଷ୍ଟା କର';

  @override
  String get runWonTitle => 'ପ୍ରତିରୋଧ କ୍ଷମତା ମିଳିଲା';

  @override
  String get runWonSubtitle => 'ରୋଗଜୀବାଣୁ ନଷ୍ଟ ହେଲା। ଆଶ୍ରୟଦାତା ବଞ୍ଚିଗଲା।';

  @override
  String get runWonNewRun => 'ନୂଆ ରନ୍';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count ସ୍ମୃତି କୋଷ',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'ପରଥର: ପ୍ରତିରୋଧ — $enemy ($bonus କ୍ଷତି)';
  }

  @override
  String get roomChoiceTitle => 'ବାଟ ବାଛ';

  @override
  String get upgradeChoiceTitle => 'ସାଇଟୋକାଇନ୍ / ରିସେପ୍ଟର ବାଛ';

  @override
  String get upgradeInfoTooltip => 'ଏହା କଣ? (ଶବ୍ଦକୋଷ)';

  @override
  String hudStartingIn(int secs) {
    return '$secs ସେକେଣ୍ଡରେ ଆରମ୍ଭ';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ଢେଉ $wave — $secs ସେକେଣ୍ଡରେ';
  }

  @override
  String hudWave(int wave) {
    return 'ଢେଉ $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ଢେଉ $wave — ସଫା!';
  }

  @override
  String bookToastOne(String name) {
    return 'ବହିରେ ନୂଆ ପୃଷ୍ଠା: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'ବହିରେ ନୂଆ ପୃଷ୍ଠା: $name ଓ ଅଧିକ ($count)';
  }
}
