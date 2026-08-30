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
      );
      final restored = MetaProgress.fromMap(original.toMap());
      expect(restored.memoryCells, 12);
      expect(restored.totalRuns, 5);
      expect(restored.wins, 1);
      expect(restored.lastKilledByType, 'tank');
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
