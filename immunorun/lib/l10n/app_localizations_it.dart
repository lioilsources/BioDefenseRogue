// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get menuSubtitle => 'Cellula immunitaria contro infezione';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp PS max';
  }

  @override
  String get menuStartRun => 'INIZIA PARTITA';

  @override
  String get menuBook => 'LESSICO';

  @override
  String get menuSoundOn => 'AUDIO: SÌ';

  @override
  String get menuSoundOff => 'AUDIO: NO';

  @override
  String get menuStatsOn => 'STATISTICHE: SÌ';

  @override
  String get menuStatsOff => 'STATISTICHE: NO';

  @override
  String get pauseTitle => 'PAUSA';

  @override
  String get pauseResume => 'CONTINUA';

  @override
  String get pauseRestart => 'RICOMINCIA PARTITA';

  @override
  String get backToMenu => 'TORNA AL MENU';

  @override
  String get gameOverTitle => 'GAME OVER';

  @override
  String gameOverWaves(int count) {
    return 'Ondate superate: $count';
  }

  @override
  String get gameOverInstant => 'Sei caduto subito.';

  @override
  String get gameOverCause => 'COSA MI HA UCCISO?';

  @override
  String get gameOverRetry => 'RIPROVA';

  @override
  String get runWonTitle => 'IMMUNITÀ RAGGIUNTA';

  @override
  String get runWonSubtitle => 'Patogeno distrutto. L\'ospite è sopravvissuto.';

  @override
  String get runWonNewRun => 'NUOVA PARTITA';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count cellule della memoria',
      one: '+1 cellula della memoria',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'La prossima volta: immunizzato contro $enemy ($bonus danni)';
  }

  @override
  String get roomChoiceTitle => 'SCEGLI LA STRADA';

  @override
  String get upgradeChoiceTitle => 'SCEGLI CITOCHINA / RECETTORE';

  @override
  String get upgradeInfoTooltip => 'Che cos\'è? (Lessico)';

  @override
  String hudStartingIn(int secs) {
    return 'SI PARTE TRA $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ONDATA $wave TRA $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'ONDATA $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ONDATA $wave — RIPULITA!';
  }

  @override
  String bookToastOne(String name) {
    return 'Nuova pagina nel libro: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nuove pagine nel libro: $name e altre ($count)';
  }
}
