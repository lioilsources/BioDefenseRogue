import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';
import 'package:immunorun/domain/status_effects.dart';

void main() {
  group('Status efekty', () {
    test('bez statusů jsou multiplikátory 1.0', () {
      expect(damageTakenMultiOf([]), 2.0); // ZÁMĚRNĚ ROZBITO (ověření CI)
      expect(speedMultiOf([]), 1.0);
    });

    test('opsonized zvyšuje příchozí dmg', () {
      final statuses = [
        ActiveStatus(effect: StatusEffect.opsonized, duration: 2.0),
      ];
      expect(damageTakenMultiOf(statuses), Balance.opsonizedDamageTakenMulti);
      expect(speedMultiOf(statuses), 1.0);
    });

    test('slowed snižuje rychlost', () {
      final statuses = [
        ActiveStatus(effect: StatusEffect.slowed, duration: 1.0),
      ];
      expect(speedMultiOf(statuses), Balance.slowedSpeedMulti);
      expect(damageTakenMultiOf(statuses), 1.0);
    });

    test('výchozí trvání dle Balance; neimplementované efekty 0', () {
      expect(statusBaseDuration(StatusEffect.opsonized),
          Balance.opsonizedDuration);
      expect(statusBaseDuration(StatusEffect.slowed), Balance.slowedDuration);
      expect(statusBaseDuration(StatusEffect.stunned), 0.0);
    });
  });
}
