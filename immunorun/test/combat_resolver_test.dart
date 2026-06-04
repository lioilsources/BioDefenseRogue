import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/domain/damage.dart';
import 'package:immunorun/game/systems/combat_resolver.dart';
import 'package:immunorun/game/systems/fever_controller.dart';

void main() {
  group('CombatResolver', () {
    final resolver = CombatResolver();
    const target   = Target(currentHp: 100, maxHp: 100);

    test('základní dmg bez horečky', () {
      final snap = FeverSnapshot(
        tempC:         36.5,
        normalized:    0.0,
        zone:          FeverZone.normal,
        atkSpeedMulti: 1.0,
      );
      final attacker = const Attacker(baseDamage: 10.0, type: DamageType.kinetic);
      final result   = resolver.resolveHit(attacker, target, snap);

      expect(result.amount, closeTo(10.0, 0.01));
      expect(result.isCritical, isFalse);
    });

    test('febrilní zóna: +10% dmg', () {
      final snap = FeverSnapshot(
        tempC:         39.0,
        normalized:    0.45,
        zone:          FeverZone.febrile,
        atkSpeedMulti: 1.12,
      );
      final attacker = const Attacker(baseDamage: 10.0, type: DamageType.kinetic);
      final result   = resolver.resolveHit(attacker, target, snap);

      // 10 * 1.12 (atkSpeed) * 1.1 (febrile bonus) = 12.32
      expect(result.amount, closeTo(12.32, 0.05));
      expect(result.isCritical, isFalse);
    });

    test('hyper zóna: kritický hit', () {
      final snap = FeverSnapshot(
        tempC:         41.0,
        normalized:    0.82,
        zone:          FeverZone.hyper,
        atkSpeedMulti: 1.25,
      );
      final attacker = const Attacker(baseDamage: 10.0, type: DamageType.kinetic);
      final result   = resolver.resolveHit(attacker, target, snap);

      expect(result.isCritical, isTrue);
    });

    test('inflammatory útok zvyšuje horečku', () {
      final snap = FeverSnapshot(
        tempC:         37.0,
        normalized:    0.09,
        zone:          FeverZone.normal,
        atkSpeedMulti: 1.0,
      );
      final attacker = const Attacker(
        baseDamage: 10.0,
        type:       DamageType.inflammatory,
      );
      final result = resolver.resolveHit(attacker, target, snap);

      expect(result.feverRise, greaterThan(0.0));
    });
  });
}
