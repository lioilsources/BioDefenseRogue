// Čistý Dart — bez Flame importů. Unit-testovatelné.
// Veškerá bojová matematika jde přes tento resolver.

import '../../config/balance.dart';
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
    double amount = attacker.baseDamage;

    // febrilní bonus k poškození — jen v horečnaté zóně
    // (atk speed jde do fireIntervalFor, ne do dmg — žádný double-dip)
    if (fever.zone == FeverZone.febrile || fever.zone == FeverZone.hyper) {
      amount *= Balance.feverDamageMulti;
    }

    final isCrit = fever.zone == FeverZone.hyper;
    if (isCrit) amount *= Balance.feverCritMulti;

    return DamageResult(
      amount:     amount,
      type:       attacker.type,
      isCritical: isCrit,
      feverRise:  _feverRiseForType(attacker.type),
    );
  }

  /// Interval mezi výstřely — horečka zrychluje kadenci (febrilní buff).
  double fireIntervalFor(double baseRate, FeverSnapshot fever) =>
      1.0 / (baseRate * fever.atkSpeedMulti);

  double _feverRiseForType(DamageType type) => switch (type) {
    DamageType.inflammatory => Balance.feverRisePerInflammatoryHit,
    DamageType.thermal      => Balance.feverRisePerThermalHit,
    _                       => 0.0,
  };
}
