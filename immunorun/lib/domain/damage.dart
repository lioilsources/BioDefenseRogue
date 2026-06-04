// Čistý Dart — bez Flame importů, plně unit-testovatelné.

enum DamageType { kinetic, inflammatory, toxic, thermal }

class DamageResult {
  const DamageResult({
    required this.amount,
    required this.type,
    this.isCritical = false,
    this.feverRise = 0.0,
  });

  final double      amount;
  final DamageType  type;
  final bool        isCritical;
  final double      feverRise; // kolik stupňů přidá zásah do horečky
}
