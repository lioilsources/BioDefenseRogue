// Persistence meta-progrese. V1 = shared_preferences (pár skalárů);
// rozhraní umožní pozdější výměnu za Drift, až přijde mutační systém.

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/meta_progress.dart';

abstract class MetaRepository {
  Future<MetaProgress> load();
  Future<void> save(MetaProgress progress);
}

class SharedPrefsMetaRepository implements MetaRepository {
  static const _kCells    = 'meta.memoryCells';
  static const _kRuns     = 'meta.totalRuns';
  static const _kWins     = 'meta.wins';
  static const _kKilledBy = 'meta.lastKilledByType';
  static const _kFontStep = 'meta.bookFontStep';
  static const _kSeenLore = 'meta.seenLore';
  static const _kLastChap = 'meta.lastChapter';

  @override
  Future<MetaProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    return MetaProgress(
      memoryCells:      prefs.getInt(_kCells) ?? 0,
      totalRuns:        prefs.getInt(_kRuns) ?? 0,
      wins:             prefs.getInt(_kWins) ?? 0,
      lastKilledByType: prefs.getString(_kKilledBy),
      bookFontStep:     prefs.getInt(_kFontStep) ?? 0,
      seenLore:         {...?prefs.getStringList(_kSeenLore)},
      lastChapter:      prefs.getString(_kLastChap),
    );
  }

  @override
  Future<void> save(MetaProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kCells, progress.memoryCells);
    await prefs.setInt(_kRuns, progress.totalRuns);
    await prefs.setInt(_kWins, progress.wins);
    await prefs.setInt(_kFontStep, progress.bookFontStep);
    await prefs.setStringList(_kSeenLore, progress.seenLore.toList()..sort());
    final last = progress.lastChapter;
    if (last == null) {
      await prefs.remove(_kLastChap);
    } else {
      await prefs.setString(_kLastChap, last);
    }
    final killedBy = progress.lastKilledByType;
    if (killedBy == null) {
      await prefs.remove(_kKilledBy);
    } else {
      await prefs.setString(_kKilledBy, killedBy);
    }
  }
}

/// Fallback / testy — nic neukládá na disk.
class InMemoryMetaRepository implements MetaRepository {
  MetaProgress _current = MetaProgress.empty;

  @override
  Future<MetaProgress> load() async => _current;

  @override
  Future<void> save(MetaProgress progress) async => _current = progress;
}
