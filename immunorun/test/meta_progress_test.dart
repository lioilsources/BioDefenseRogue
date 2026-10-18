import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';
import 'package:immunorun/domain/enemy_archetype.dart';
import 'package:immunorun/domain/meta_progress.dart';

void main() {
  group('MetaProgress', () {
    test('serializace round-trip', () {
      const original = MetaProgress(
        memoryCells:      12,
        totalRuns:        5,
        wins:             1,
        lastKilledByType: 'tank',
        bookFontStep:     2,
      );
      final restored = MetaProgress.fromMap(original.toMap());
      expect(restored.bookFontStep, 2);
      expect(restored.memoryCells, 12);
      expect(restored.totalRuns, 5);
      expect(restored.wins, 1);
      expect(restored.lastKilledByType, 'tank');
    });

    test('migrace: stará meta bez bookFontStep dostane výchozí 0', () {
      final old = MetaProgress.fromMap({'memoryCells': 4, 'totalRuns': 2});
      expect(old.memoryCells, 4);
      expect(old.bookFontStep, 0);
    });

    test('copyWith bookFontStep zachová zbytek mety', () {
      const meta = MetaProgress(memoryCells: 9, lastKilledByType: 'fever');
      final big  = meta.copyWith(bookFontStep: 1);
      expect(big.bookFontStep, 1);
      expect(big.memoryCells, 9);
      expect(big.lastKilledByType, 'fever');
    });

    test('bonus HP je capnutý', () {
      const few  = MetaProgress(memoryCells: 3);
      const many = MetaProgress(memoryCells: 1000);
      expect(few.bonusStartHp, 3 * Balance.memoryHpPerCell);
      expect(many.bonusStartHp, Balance.memoryHpCap);
    });

    test('copyWith clearLastKilledBy smaže zabijáka (výhra)', () {
      const dead = MetaProgress(lastKilledByType: 'boss');
      final won  = dead.copyWith(clearLastKilledBy: true);
      expect(won.lastKilledByType, isNull);
    });

    test('vakcinace mapuje zabijáka na EnemyType', () {
      expect(vaccinationTarget('swarmer'), EnemyType.swarmer);
      expect(vaccinationTarget('tank'), EnemyType.tank);
      expect(vaccinationTarget('boss'), EnemyType.shooter);
      expect(vaccinationTarget('fever'), isNull);
      expect(vaccinationTarget(null), isNull);
    });
  });
}
