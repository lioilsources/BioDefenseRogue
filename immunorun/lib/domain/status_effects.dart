// Čistý Dart — bez Flame importů.

import '../config/balance.dart';

enum StatusEffect { opsonized, inflamed, trapped, slowed, stunned }

class ActiveStatus {
  ActiveStatus({required this.effect, required this.duration});

  final StatusEffect effect;
  double duration; // zbývající čas v sekundách
}

/// Výchozí trvání efektu při aplikaci (0 = efekt zatím nemá gameplay).
double statusBaseDuration(StatusEffect effect) => switch (effect) {
  StatusEffect.opsonized => Balance.opsonizedDuration,
  StatusEffect.slowed    => Balance.slowedDuration,
  _                      => 0.0,
};

/// Multiplikátor příchozího poškození cíle podle aktivních statusů.
double damageTakenMultiOf(Iterable<ActiveStatus> statuses) {
  var multi = 1.0;
  for (final s in statuses) {
    if (s.effect == StatusEffect.opsonized) {
      multi *= Balance.opsonizedDamageTakenMulti;
    }
  }
  return multi;
}

/// Multiplikátor rychlosti pohybu podle aktivních statusů.
double speedMultiOf(Iterable<ActiveStatus> statuses) {
  var multi = 1.0;
  for (final s in statuses) {
    if (s.effect == StatusEffect.slowed) {
      multi *= Balance.slowedSpeedMulti;
    }
  }
  return multi;
}
