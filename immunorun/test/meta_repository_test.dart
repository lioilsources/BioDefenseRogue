import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/data/meta_repository.dart';
import 'package:immunorun/domain/meta_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPrefsMetaRepository', () {
    test('load z prázdných prefs vrací výchozí metu', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SharedPrefsMetaRepository();
      final meta = await repo.load();
      expect(meta.memoryCells, 0);
      expect(meta.totalRuns, 0);
      expect(meta.lastKilledByType, isNull);
    });

    test('save/load round-trip', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SharedPrefsMetaRepository();
      const meta = MetaProgress(
        memoryCells:      7,
        totalRuns:        3,
        wins:             1,
        lastKilledByType: 'fever',
        bookFontStep:     1,
        seenLore:         {'enemy.swarmer'},
        lastChapter:      '03-nepratele',
      );
      await repo.save(meta);
      final loaded = await repo.load();
      expect(loaded.bookFontStep, 1);
      expect(loaded.seenLore, {'enemy.swarmer'});
      expect(loaded.lastChapter, '03-nepratele');
      expect(loaded.memoryCells, 7);
      expect(loaded.totalRuns, 3);
      expect(loaded.wins, 1);
      expect(loaded.lastKilledByType, 'fever');
    });

    test('výhra smaže lastKilledByType i v prefs', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SharedPrefsMetaRepository();
      await repo.save(const MetaProgress(lastKilledByType: 'tank'));
      await repo.save(const MetaProgress());
      final loaded = await repo.load();
      expect(loaded.lastKilledByType, isNull);
    });
  });

  group('InMemoryMetaRepository', () {
    test('save/load round-trip', () async {
      final repo = InMemoryMetaRepository();
      await repo.save(const MetaProgress(memoryCells: 2));
      expect((await repo.load()).memoryCells, 2);
    });
  });
}
