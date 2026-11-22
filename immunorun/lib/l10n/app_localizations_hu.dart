// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get menuSubtitle => 'Immunsejt a fertőzés ellen';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp max. HP';
  }

  @override
  String get menuStartRun => 'FUTAM INDÍTÁSA';

  @override
  String get menuBook => 'LEXIKON';

  @override
  String get menuSoundOn => 'HANG: BE';

  @override
  String get menuSoundOff => 'HANG: KI';

  @override
  String get menuStatsOn => 'STATISZTIKA: BE';

  @override
  String get menuStatsOff => 'STATISZTIKA: KI';

  @override
  String get pauseTitle => 'SZÜNET';

  @override
  String get pauseResume => 'FOLYTATÁS';

  @override
  String get pauseRestart => 'FUTAM ÚJRAKEZDÉSE';

  @override
  String get backToMenu => 'VISSZA A MENÜBE';

  @override
  String get gameOverTitle => 'VÉGE A JÁTÉKNAK';

  @override
  String gameOverWaves(int count) {
    return 'Túlélt hullámok: $count';
  }

  @override
  String get gameOverInstant => 'Azonnal elestél.';

  @override
  String get gameOverCause => 'MI ÖLT MEG?';

  @override
  String get gameOverRetry => 'ÚJRA';

  @override
  String get runWonTitle => 'IMMUNITÁS ELÉRVE';

  @override
  String get runWonSubtitle =>
      'A kórokozó elpusztult. A gazdaszervezet túlélte.';

  @override
  String get runWonNewRun => 'ÚJ FUTAM';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count memóriasejt',
      one: '+$count memóriasejt',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Legközelebb: immunitás – $enemy ($bonus sebzés)';
  }

  @override
  String get roomChoiceTitle => 'VÁLASSZ UTAT';

  @override
  String get upgradeChoiceTitle => 'VÁLASSZ CITOKINT / RECEPTORT';

  @override
  String get upgradeInfoTooltip => 'Mi ez? (Lexikon)';

  @override
  String hudStartingIn(int secs) {
    return 'KEZDÉS $secs mp MÚLVA';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return '$wave. HULLÁM $secs mp MÚLVA';
  }

  @override
  String hudWave(int wave) {
    return '$wave. HULLÁM';
  }

  @override
  String hudWaveCleared(int wave) {
    return '$wave. HULLÁM — MEGTISZTÍTVA!';
  }

  @override
  String bookToastOne(String name) {
    return 'Új oldal a könyvben: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Új oldalak a könyvben: $name és még ($count)';
  }
}
