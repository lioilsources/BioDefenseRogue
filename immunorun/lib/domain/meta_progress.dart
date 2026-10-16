// Čistý Dart — bez Flame importů.
// Meta-progrese: paměťové buňky přežívají smrt (očkování jako meta).

import 'dart:math';

import '../config/balance.dart';
import 'enemy_archetype.dart';
import 'lore.dart';

class MetaProgress {
  const MetaProgress({
    this.memoryCells      = 0,
    this.totalRuns        = 0,
    this.wins             = 0,
    this.lastKilledByType,
    this.bookFontStep     = 0,
  });

  final int     memoryCells;
  final int     totalRuns;
  final int     wins;
  /// 'swarmer' | 'tank' | 'boss' | 'fever' | null (bez smrti / výhra)
  final String? lastKilledByType;
  /// Velikost písma v knize: index do Balance.bookFontScales (0 = základní).
  final int     bookFontStep;

  static const empty = MetaProgress();

  /// Bonus startovního max HP z paměťových buněk (s capem).
  int get bonusStartHp =>
      min(memoryCells * Balance.memoryHpPerCell, Balance.memoryHpCap);

  MetaProgress copyWith({
    int?     memoryCells,
    int?     totalRuns,
    int?     wins,
    String?  lastKilledByType,
    bool     clearLastKilledBy = false,
    int?     bookFontStep,
  }) =>
      MetaProgress(
        memoryCells: memoryCells ?? this.memoryCells,
        totalRuns:   totalRuns   ?? this.totalRuns,
        wins:        wins        ?? this.wins,
        lastKilledByType: clearLastKilledBy
            ? null
            : (lastKilledByType ?? this.lastKilledByType),
        bookFontStep: bookFontStep ?? this.bookFontStep,
      );

  Map<String, Object?> toMap() => {
        'memoryCells':      memoryCells,
        'totalRuns':        totalRuns,
        'wins':             wins,
        'lastKilledByType': lastKilledByType,
        'bookFontStep':     bookFontStep,
      };

  factory MetaProgress.fromMap(Map<String, Object?> map) => MetaProgress(
        memoryCells:      (map['memoryCells'] as int?) ?? 0,
        totalRuns:        (map['totalRuns'] as int?) ?? 0,
        wins:             (map['wins'] as int?) ?? 0,
        lastKilledByType: map['lastKilledByType'] as String?,
        bookFontStep:     (map['bookFontStep'] as int?) ?? 0,
      );
}

/// Vakcinace: proti kterému EnemyType platí dmg bonus příští run.
/// 'fever' není nepřítel — vakcinace se neaplikuje.
EnemyType? vaccinationTarget(String? killedBy) => switch (killedBy) {
      'swarmer' => EnemyType.swarmer,
      'tank'    => EnemyType.tank,
      'boss'    => EnemyType.shooter,
      _         => null,
    };

/// Český popisek zabijáka pro game-over hint (3. pád z registru pojmů).
String? killedByLabelCz(String? killedBy) {
  final target = vaccinationTarget(killedBy);
  if (target != null) return lore.byRef(target).dativeCz;
  if (killedBy == 'fever') return lore.byId('mechanic.fever').dativeCz;
  return null;
}
