// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get menuSubtitle => 'Célula inmunitaria contra infección';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp PS máx.';
  }

  @override
  String get menuStartRun => 'EMPEZAR PARTIDA';

  @override
  String get menuBook => 'LÉXICO';

  @override
  String get menuSoundOn => 'SONIDO: SÍ';

  @override
  String get menuSoundOff => 'SONIDO: NO';

  @override
  String get menuStatsOn => 'ESTADÍSTICAS: SÍ';

  @override
  String get menuStatsOff => 'ESTADÍSTICAS: NO';

  @override
  String get pauseTitle => 'PAUSA';

  @override
  String get pauseResume => 'CONTINUAR';

  @override
  String get pauseRestart => 'REINICIAR PARTIDA';

  @override
  String get backToMenu => 'VOLVER AL MENÚ';

  @override
  String get gameOverTitle => 'FIN DEL JUEGO';

  @override
  String gameOverWaves(int count) {
    return 'Oleadas superadas: $count';
  }

  @override
  String get gameOverInstant => 'Caíste enseguida.';

  @override
  String get gameOverCause => '¿QUÉ ME MATÓ?';

  @override
  String get gameOverRetry => 'INTENTAR DE NUEVO';

  @override
  String get runWonTitle => 'INMUNIDAD CONSEGUIDA';

  @override
  String get runWonSubtitle => 'Patógeno destruido. El huésped sobrevivió.';

  @override
  String get runWonNewRun => 'NUEVA PARTIDA';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count células de memoria',
      one: '+1 célula de memoria',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'La próxima vez: inmunizado contra $enemy ($bonus daño)';
  }

  @override
  String get roomChoiceTitle => 'ELIGE TU CAMINO';

  @override
  String get upgradeChoiceTitle => 'ELIGE CITOCINA / RECEPTOR';

  @override
  String get upgradeInfoTooltip => '¿Qué es esto? (Léxico)';

  @override
  String hudStartingIn(int secs) {
    return 'EMPIEZA EN $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'OLEADA $wave EN $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'OLEADA $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'OLEADA $wave — ¡DESPEJADA!';
  }

  @override
  String bookToastOne(String name) {
    return 'Nueva página en el libro: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nuevas páginas en el libro: $name y más ($count)';
  }
}
