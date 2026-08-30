import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';
import 'package:immunorun/domain/room_type.dart';
import 'package:immunorun/game/systems/wave_composition.dart';

void main() {
  group('composeWave', () {
    test('boss a treasure nespawní nic', () {
      expect(composeWave(roomType: RoomType.boss, difficulty: 3),
          (swarmers: 0, tanks: 0));
      expect(composeWave(roomType: RoomType.treasure, difficulty: 3),
          (swarmers: 0, tanks: 0));
    });

    test('první místnost bez tanků', () {
      final c = composeWave(roomType: RoomType.combat, difficulty: 0);
      expect(c.tanks, 0);
      expect(c.swarmers, greaterThan(0));
    });

    test('tanky od tankStartDifficulty', () {
      final c = composeWave(
        roomType:   RoomType.combat,
        difficulty: Balance.tankStartDifficulty,
      );
      expect(c.tanks, greaterThan(0));
    });

    test('elite má víc tanků než combat při stejné obtížnosti', () {
      final combat = composeWave(
        roomType:   RoomType.combat,
        difficulty: Balance.tankStartDifficulty,
      );
      final elite = composeWave(
        roomType:   RoomType.elite,
        difficulty: Balance.tankStartDifficulty,
      );
      expect(elite.tanks, greaterThan(combat.tanks));
    });

    test('počet tanků je capnutý', () {
      final c = composeWave(roomType: RoomType.elite, difficulty: 20);
      expect(c.tanks, lessThanOrEqualTo(Balance.tankMaxPerWave));
      expect(c.swarmers, greaterThanOrEqualTo(1));
    });
  });
}
