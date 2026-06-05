// Čistý Dart — bez Flame importů.
// Datové třídy pro archetypy nepřátel (data-driven).

enum EnemyType { swarmer, tank, shooter }

class EnemyArchetype {
  const EnemyArchetype({
    required this.type,
    required this.maxHp,
    required this.speed,
    required this.contactDamage,
    required this.feverRiseOnHit,
    required this.radius,
    required this.xpDrop,
  });

  final EnemyType type;
  final int       maxHp;
  final double    speed;        // px/s
  final double    contactDamage;
  final double    feverRiseOnHit;
  final double    radius;       // hitbox
  final int       xpDrop;
}

// Výchozí archetypy (tuning přes balance.dart)
const swarmerArchetype = EnemyArchetype(
  type:            EnemyType.swarmer,
  maxHp:           30,
  speed:           160.0,
  contactDamage:   8.0,
  feverRiseOnHit:  0.3,
  radius:          14.0,
  xpDrop:          5,
);

const bossArchetype = EnemyArchetype(
  type:            EnemyType.shooter,
  maxHp:           300,
  speed:           0.0,   // pohyb řeší orbit logika v MiniBoss
  contactDamage:   15.0,
  feverRiseOnHit:  0.5,
  radius:          40.0,
  xpDrop:          50,
);
