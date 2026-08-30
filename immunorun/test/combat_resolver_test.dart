import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';
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

    test('febrilní zóna: dmg bonus, ale bez atk-speed v damage', () {
      final snap = FeverSnapshot(
        tempC:         39.0,
        normalized:    0.45,
        zone:          FeverZone.febrile,
        atkSpeedMulti: 1.12,
      );
      final attacker = const Attacker(baseDamage: 10.0, type: DamageType.kinetic);
      final result   = resolver.resolveHit(attacker, target, snap);

      // atkSpeed jde do kadence (fireIntervalFor), NE do damage
      expect(result.amount, closeTo(10.0 * Balance.feverDamageMulti, 0.01));
      expect(result.isCritical, isFalse);
    });

    test('hyper zóna: kritický hit s krit multiplikátorem', () {
      final snap = FeverSnapshot(
        tempC:         41.0,
        normalized:    0.82,
        zone:          FeverZone.hyper,
        atkSpeedMulti: 1.25,
      );
      final attacker = const Attacker(baseDamage: 10.0, type: DamageType.kinetic);
      final result   = resolver.resolveHit(attacker, target, snap);

      expect(result.isCritical, isTrue);
      expect(
        result.amount,
        closeTo(10.0 * Balance.feverDamageMulti * Balance.feverCritMulti, 0.01),
      );
    });

    test('fireIntervalFor: normální zóna = base interval', () {
      final snap = FeverSnapshot(
        tempC:         36.5,
        normalized:    0.0,
        zone:          FeverZone.normal,
        atkSpeedMulti: 1.0,
      );
      expect(resolver.fireIntervalFor(2.0, snap), closeTo(0.5, 0.001));
    });

    test('fireIntervalFor: horečka zrychluje kadenci', () {
      final snap = FeverSnapshot(
        tempC:         40.0,
        normalized:    0.64,
        zone:          FeverZone.hyper,
        atkSpeedMulti: 1.25,
      );
      expect(resolver.fireIntervalFor(2.0, snap), closeTo(0.4, 0.001));
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
