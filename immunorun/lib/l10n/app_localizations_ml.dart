// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get menuSubtitle => 'പ്രതിരോധ കോശം vs. അണുബാധ';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp പരമാവധി HP';
  }

  @override
  String get menuStartRun => 'റൺ തുടങ്ങുക';

  @override
  String get menuBook => 'നിഘണ്ടു';

  @override
  String get menuSoundOn => 'ശബ്ദം: ഓൺ';

  @override
  String get menuSoundOff => 'ശബ്ദം: ഓഫ്';

  @override
  String get menuStatsOn => 'സ്ഥിതിവിവരം: ഓൺ';

  @override
  String get menuStatsOff => 'സ്ഥിതിവിവരം: ഓഫ്';

  @override
  String get pauseTitle => 'വിരാമം';

  @override
  String get pauseResume => 'തുടരുക';

  @override
  String get pauseRestart => 'റൺ വീണ്ടും തുടങ്ങുക';

  @override
  String get backToMenu => 'മെനുവിലേക്ക് മടങ്ങുക';

  @override
  String get gameOverTitle => 'കളി കഴിഞ്ഞു';

  @override
  String gameOverWaves(int count) {
    return 'അതിജീവിച്ച തിരമാലകൾ: $count';
  }

  @override
  String get gameOverInstant => 'നീ ഉടനെ വീണുപോയി.';

  @override
  String get gameOverCause => 'എന്നെ എന്താണ് തോൽപ്പിച്ചത്?';

  @override
  String get gameOverRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get runWonTitle => 'പ്രതിരോധശേഷി നേടി';

  @override
  String get runWonSubtitle => 'രോഗാണു നശിച്ചു. ആതിഥേയൻ രക്ഷപ്പെട്ടു.';

  @override
  String get runWonNewRun => 'പുതിയ റൺ';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count ഓർമ്മ കോശങ്ങൾ',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'അടുത്ത തവണ: പ്രതിരോധം — $enemy ($bonus കേട്)';
  }

  @override
  String get roomChoiceTitle => 'വഴി തിരഞ്ഞെടുക്കുക';

  @override
  String get upgradeChoiceTitle => 'സൈറ്റോകൈൻ / റിസപ്റ്റർ തിരഞ്ഞെടുക്കുക';

  @override
  String get upgradeInfoTooltip => 'ഇതെന്താണ്? (നിഘണ്ടു)';

  @override
  String hudStartingIn(int secs) {
    return '$secs സെക്കൻഡിൽ തുടക്കം';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'തിരമാല $wave — $secs സെക്കൻഡിൽ';
  }

  @override
  String hudWave(int wave) {
    return 'തിരമാല $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'തിരമാല $wave — വൃത്തിയായി!';
  }

  @override
  String bookToastOne(String name) {
    return 'പുസ്തകത്തിൽ പുതിയ പേജ്: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'പുസ്തകത്തിൽ പുതിയ പേജുകൾ: $name എന്നിവയും മറ്റും ($count)';
  }
}
