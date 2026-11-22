// Háčky hry pro vrstvu appky (anonymní statistiky, docs/telemetry.md).
// Hra sem jen hlásí, nikdy z nich nic nečte: měření neřídí hru.

import '../domain/room_type.dart';
import '../domain/upgrade.dart';

/// Co hráč právě vidí. Hra nemá trasy, obrazovky jsou stavy overlayů.
enum GameScreen {
  menu('menu'),
  play('play'),
  pause('pause'),
  upgrade('upgrade'),
  roomChoice('room_choice'),
  result('result'),
  book('book');

  const GameScreen(this.id);

  /// Hodnota, jak ji hlásí měření.
  final String id;
}

/// Odkud run začal.
enum RunFrom {
  /// Hlavní menu.
  menu,

  /// Obrazovka konce runu (znovu / nový run).
  result,

  /// Restart z pauzy.
  pause,
}

/// Jak run skončil.
enum RunEnd {
  /// Hráč padl (HP nebo horečka): run dohraný do konce.
  death,

  /// Boss poražen: run dohraný do konce.
  won,

  /// Restart z pauzy.
  restart,

  /// Odchod do hlavního menu z pauzy.
  menu,
}

/// Stav runu v okamžiku hlášení (jen čísla a výčty).
class RunStats {
  const RunStats({
    required this.level,
    required this.room,
    required this.roomsCleared,
    required this.upgrades,
    required this.cellsEarned,
    this.killedBy,
  });

  /// Pořadí místnosti, ve které run je (1 = první).
  final int level;

  /// Typ místnosti, ve které run je.
  final RoomType room;

  final int roomsCleared;

  /// Počet získaných upgradů.
  final int upgrades;

  /// Paměťové buňky získané v runu (jen u dohraného runu, jinak 0).
  final int cellsEarned;

  /// Kdo zabil (`fever`, `swarmer`, `tank`, `boss`), jen u [RunEnd.death].
  final String? killedBy;
}

/// Pozoruje hru z vrstvy appky. Výchozí implementace nic nedělá.
abstract interface class GameObserver {
  void screenChanged(GameScreen screen);

  /// Run začal. [live] vrátí aktuální stav (pro run, který skončí v pozadí).
  void runStarted(RunFrom from,
      {required bool vaccinated, required RunStats Function() live});

  /// Run skončil, ještě před vyčištěním jeho stavu.
  void runEnded(RunEnd end, RunStats stats);

  /// Hráč na rozcestí vybral dveře.
  void roomChosen(RoomType room, int level);

  /// Hráč vybral upgrade.
  void upgradePicked(UpgradeId id, int level);

  /// Kniha se otevřela; [fromHint] = z odkazu ve hře (karta, horečka, příčina).
  void bookOpened({required bool fromHint});

  /// Dokončený kvíz kapitoly.
  void quizDone();

  /// Změna velikosti písma v knize.
  void bookFontChanged();
}
