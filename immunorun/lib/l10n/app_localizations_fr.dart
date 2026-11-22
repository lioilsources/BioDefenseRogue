// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get menuSubtitle => 'Cellule immunitaire contre infection';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name : $count  ·  +$hp PV max';
  }

  @override
  String get menuStartRun => 'LANCER UNE PARTIE';

  @override
  String get menuBook => 'LEXIQUE';

  @override
  String get menuSoundOn => 'SON : OUI';

  @override
  String get menuSoundOff => 'SON : NON';

  @override
  String get menuStatsOn => 'STATISTIQUES : OUI';

  @override
  String get menuStatsOff => 'STATISTIQUES : NON';

  @override
  String get pauseTitle => 'PAUSE';

  @override
  String get pauseResume => 'CONTINUER';

  @override
  String get pauseRestart => 'RECOMMENCER LA PARTIE';

  @override
  String get backToMenu => 'RETOUR AU MENU';

  @override
  String get gameOverTitle => 'GAME OVER';

  @override
  String gameOverWaves(int count) {
    return 'Vagues survécues : $count';
  }

  @override
  String get gameOverInstant => 'Tu es tombé tout de suite.';

  @override
  String get gameOverCause => 'QU\'EST-CE QUI M\'A TUÉ ?';

  @override
  String get gameOverRetry => 'RÉESSAYER';

  @override
  String get runWonTitle => 'IMMUNITÉ ATTEINTE';

  @override
  String get runWonSubtitle => 'Pathogène détruit. L\'hôte a survécu.';

  @override
  String get runWonNewRun => 'NOUVELLE PARTIE';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count cellules mémoire',
      one: '+1 cellule mémoire',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'La prochaine fois : immunisé contre $enemy ($bonus dégâts)';
  }

  @override
  String get roomChoiceTitle => 'CHOISIS TON CHEMIN';

  @override
  String get upgradeChoiceTitle => 'CHOISIS UNE CYTOKINE / UN RÉCEPTEUR';

  @override
  String get upgradeInfoTooltip => 'Qu\'est-ce que c\'est ? (Lexique)';

  @override
  String hudStartingIn(int secs) {
    return 'DÉBUT DANS $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'VAGUE $wave DANS $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'VAGUE $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'VAGUE $wave — NETTOYÉE !';
  }

  @override
  String bookToastOne(String name) {
    return 'Nouvelle page dans le livre : $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Nouvelles pages dans le livre : $name et d\'autres ($count)';
  }
}
