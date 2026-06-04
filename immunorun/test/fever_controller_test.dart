import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';
import 'package:immunorun/game/systems/fever_controller.dart';

void main() {
  group('FeverController', () {
    test('startuje na feverMin', () {
      final fc = FeverController();
      expect(fc.tempC, closeTo(Balance.feverMin, 0.001));
    });

    test('zásah zvýší teplotu', () {
      final fc = FeverController();
      fc.onHit();
      expect(fc.tempC, closeTo(Balance.feverMin + Balance.feverRisePerHit, 0.001));
    });

    test('decay snižuje teplotu', () {
      final fc = FeverController();
      fc.onHit();
      fc.onHit();
      final before = fc.tempC;
      fc.update(1.0);
      expect(fc.tempC, lessThan(before));
    });

    test('room clear urychlí decay', () {
      final fc1 = FeverController()
        ..onHit()
        ..onHit()
        ..onHit();
      final fc2 = FeverController()
        ..onHit()
        ..onHit()
        ..onHit()
        ..setRoomClear(true);

      fc1.update(1.0);
      fc2.update(1.0);

      expect(fc2.tempC, lessThan(fc1.tempC));
    });

    test('kritický akumulátor → isDead po 3 s', () {
      final fc = FeverController();
      // Nastav teplotu na kritickou
      for (var i = 0; i < 20; i++) {
        fc.onHit();
      }

      expect(fc.tempC, greaterThanOrEqualTo(Balance.feverCriticalStart));

      // Simuluj 3.1 s v kritické zóně
      fc.update(Balance.feverCriticalKillDelay + 0.1);

      expect(fc.isDead, isTrue);
    });
  });
}
