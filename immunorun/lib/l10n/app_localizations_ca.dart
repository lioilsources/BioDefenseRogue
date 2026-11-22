// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get menuSubtitle => 'Cèl·lula immunitària contra infecció';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp PV màx.';
  }

  @override
  String get menuStartRun => 'COMENÇAR PARTIDA';

  @override
  String get menuBook => 'LÈXIC';

  @override
  String get menuSoundOn => 'SO: SÍ';

  @override
  String get menuSoundOff => 'SO: NO';

  @override
  String get menuStatsOn => 'ESTADÍSTIQUES: SÍ';

  @override
  String get menuStatsOff => 'ESTADÍSTIQUES: NO';

  @override
  String get pauseTitle => 'PAUSA';

  @override
  String get pauseResume => 'CONTINUAR';

  @override
  String get pauseRestart => 'REINICIAR PARTIDA';

  @override
  String get backToMenu => 'TORNAR AL MENÚ';

  @override
  String get gameOverTitle => 'FI DEL JOC';

  @override
  String gameOverWaves(int count) {
    return 'Onades superades: $count';
  }

  @override
  String get gameOverInstant => 'Has caigut de seguida.';

  @override
  String get gameOverCause => 'QUÈ M\'HA MATAT?';

  @override
  String get gameOverRetry => 'TORNA-HO A PROVAR';

  @override
  String get runWonTitle => 'IMMUNITAT ASSOLIDA';

  @override
  String get runWonSubtitle => 'Patogen destruït. L\'hoste ha sobreviscut.';

  @override
  String get runWonNewRun => 'NOVA PARTIDA';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count cèl·lules de memòria',
      one: '+1 cèl·lula de memòria',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'La propera vegada: immunitzat contra $enemy ($bonus de dany)';
  }

  @override
  String get roomChoiceTitle => 'TRIA EL CAMÍ';

  @override
  String get upgradeChoiceTitle => 'TRIA CITOCINA / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'Què és això? (Lèxic)';

  @override
  String hudStartingIn(int secs) {
    return 'COMENCEM D\'AQUÍ A $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ONADA $wave D\'AQUÍ A $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'ONADA $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ONADA $wave — NETEJADA!';
  }

  @override
  String bookToastOne(String name) {
    return 'Pàgina nova al llibre: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Pàgines noves al llibre: $name i més ($count)';
  }
}
