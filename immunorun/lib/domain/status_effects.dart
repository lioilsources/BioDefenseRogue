// Čistý Dart — bez Flame importů.

enum StatusEffect { opsonized, inflamed, trapped, slowed, stunned }

class ActiveStatus {
  ActiveStatus({required this.effect, required this.duration});

  final StatusEffect effect;
  double duration; // zbývající čas v sekundách
}
