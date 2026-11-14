// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get menuSubtitle => 'Ανοσοκύτταρο εναντίον λοίμωξης';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp μέγ. HP';
  }

  @override
  String get menuStartRun => 'ΕΝΑΡΞΗ RUN';

  @override
  String get menuBook => 'ΛΕΞΙΚΟ';

  @override
  String get menuSoundOn => 'ΗΧΟΣ: ΝΑΙ';

  @override
  String get menuSoundOff => 'ΗΧΟΣ: ΟΧΙ';

  @override
  String get menuStatsOn => 'ΣΤΑΤΙΣΤΙΚΑ: ΝΑΙ';

  @override
  String get menuStatsOff => 'ΣΤΑΤΙΣΤΙΚΑ: ΟΧΙ';

  @override
  String get pauseTitle => 'ΠΑΥΣΗ';

  @override
  String get pauseResume => 'ΣΥΝΕΧΕΙΑ';

  @override
  String get pauseRestart => 'ΕΠΑΝΕΚΚΙΝΗΣΗ RUN';

  @override
  String get backToMenu => 'ΠΙΣΩ ΣΤΟ ΜΕΝΟΥ';

  @override
  String get gameOverTitle => 'ΤΕΛΟΣ ΠΑΙΧΝΙΔΙΟΥ';

  @override
  String gameOverWaves(int count) {
    return 'Κύματα που επέζησες: $count';
  }

  @override
  String get gameOverInstant => 'Έπεσες αμέσως.';

  @override
  String get gameOverCause => 'ΤΙ ΜΕ ΣΚΟΤΩΣΕ;';

  @override
  String get gameOverRetry => 'ΞΑΝΑ';

  @override
  String get runWonTitle => 'ΑΝΟΣΙΑ ΕΠΙΤΕΥΧΘΗΚΕ';

  @override
  String get runWonSubtitle => 'Το παθογόνο καταστράφηκε. Ο ξενιστής επέζησε.';

  @override
  String get runWonNewRun => 'ΝΕΟ RUN';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count κύτταρα μνήμης',
      one: '+$count κύτταρο μνήμης',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Την επόμενη φορά: ανοσία — $enemy ($bonus ζημιά)';
  }

  @override
  String get roomChoiceTitle => 'ΔΙΑΛΕΞΕ ΔΡΟΜΟ';

  @override
  String get upgradeChoiceTitle => 'ΔΙΑΛΕΞΕ ΚΥΤΤΑΡΟΚΙΝΗ / ΥΠΟΔΟΧΕΑ';

  @override
  String get upgradeInfoTooltip => 'Τι είναι αυτό; (Λεξικό)';

  @override
  String hudStartingIn(int secs) {
    return 'ΞΕΚΙΝΑΜΕ ΣΕ $secs δ';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ΚΥΜΑ $wave ΣΕ $secs δ';
  }

  @override
  String hudWave(int wave) {
    return 'ΚΥΜΑ $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ΚΥΜΑ $wave — ΚΑΘΑΡΙΣΕ!';
  }

  @override
  String bookToastOne(String name) {
    return 'Νέα σελίδα στο βιβλίο: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Νέες σελίδες στο βιβλίο: $name και άλλες ($count)';
  }
}
