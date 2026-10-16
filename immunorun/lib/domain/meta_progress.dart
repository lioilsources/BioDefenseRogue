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
    this.seenLore         = const {},
    this.lastChapter,
    this.quizDone         = const {},
  });

  final int     memoryCells;
  final int     totalRuns;
  final int     wins;
  /// 'swarmer' | 'tank' | 'boss' | 'fever' | null (bez smrti / výhra)
  final String? lastKilledByType;
  /// Velikost písma v knize: index do Balance.bookFontScales (0 = základní).
  final int     bookFontStep;
  /// Pojmy potkané ve hře (id registru) → razítka v knize (06-sync S3).
  final Set<String> seenLore;
  /// Poslední otevřená kapitola knihy.
  final String? lastChapter;
  /// Kapitoly s dokončeným kvízem → razítko „kvíz hotov" (jen kosmetika, ADR 0002).
  final Set<String> quizDone;

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
    Set<String>? seenLore,
    String?  lastChapter,
    Set<String>? quizDone,
  }) =>
      MetaProgress(
        memoryCells: memoryCells ?? this.memoryCells,
        totalRuns:   totalRuns   ?? this.totalRuns,
        wins:        wins        ?? this.wins,
        lastKilledByType: clearLastKilledBy
            ? null
            : (lastKilledByType ?? this.lastKilledByType),
        bookFontStep: bookFontStep ?? this.bookFontStep,
        seenLore:     seenLore ?? this.seenLore,
        lastChapter:  lastChapter ?? this.lastChapter,
        quizDone:     quizDone ?? this.quizDone,
      );

  Map<String, Object?> toMap() => {
        'memoryCells':      memoryCells,
        'totalRuns':        totalRuns,
        'wins':             wins,
        'lastKilledByType': lastKilledByType,
        'bookFontStep':     bookFontStep,
        'seenLore':         seenLore.toList()..sort(),
        'lastChapter':      lastChapter,
        'quizDone':         quizDone.toList()..sort(),
      };

  factory MetaProgress.fromMap(Map<String, Object?> map) => MetaProgress(
        memoryCells:      (map['memoryCells'] as int?) ?? 0,
        totalRuns:        (map['totalRuns'] as int?) ?? 0,
        wins:             (map['wins'] as int?) ?? 0,
        lastKilledByType: map['lastKilledByType'] as String?,
        bookFontStep:     (map['bookFontStep'] as int?) ?? 0,
        seenLore:         {...?(map['seenLore'] as List?)?.cast<String>()},
        lastChapter:      map['lastChapter'] as String?,
        quizDone:         {...?(map['quizDone'] as List?)?.cast<String>()},
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

/// Záznam registru pro příčinu smrti (game-over hint, „Co mě zabilo?").
LoreEntry? loreForKilledBy(String? killedBy, {LoreRegistry? registry}) {
  final reg    = registry ?? lore;
  final target = vaccinationTarget(killedBy);
  if (target != null) return reg.byRef(target);
  if (killedBy == 'fever') return reg.byId('mechanic.fever');
  return null;
}

/// Český popisek zabijáka pro game-over hint (3. pád z registru pojmů).
String? killedByLabelCz(String? killedBy) => loreForKilledBy(killedBy)?.dativeCz;
