// Čistý Dart — bez Flame importů. Unit-testovatelné.
// Veškerá bojová matematika jde přes tento resolver.

import '../../domain/damage.dart';
import 'fever_controller.dart';

class Attacker {
  const Attacker({required this.baseDamage, required this.type});
  final double     baseDamage;
  final DamageType type;
}

class Target {
  const Target({required this.currentHp, required this.maxHp});
  final int currentHp;
  final int maxHp;
}

class CombatResolver {
  DamageResult resolveHit(
    Attacker      attacker,
    Target        target,
    FeverSnapshot fever,
  ) {
    double amount = attacker.baseDamage * fever.atkSpeedMulti;

    // febrilní bonus k poškození — jen v horečnaté zóně
    if (fever.zone == FeverZone.febrile || fever.zone == FeverZone.hyper) {
      amount *= 1.1;
    }

    final isCrit = fever.zone == FeverZone.hyper;
    if (isCrit) amount *= 1.5;

    return DamageResult(
      amount:     amount,
      type:       attacker.type,
      isCritical: isCrit,
      feverRise:  _feverRiseForType(attacker.type),
    );
  }

  double _feverRiseForType(DamageType type) => switch (type) {
    DamageType.inflammatory => 0.15,
    DamageType.thermal      => 0.25,
    _                       => 0.0,
  };
}
