// Všechna laditelná čísla hry — žádná magic numbers mimo tento soubor.
// Konvence: skupiny odděleny prázdným řádkem, názvy popisné.

abstract final class Balance {
  // ── Aréna ────────────────────────────────────────────────────────────────
  static const double arenaWidth  = 3200.0;
  static const double arenaHeight = 2400.0;

  // ── Hráč ─────────────────────────────────────────────────────────────────
  static const double playerSpeed        = 280.0; // px/s
  static const double playerRadius       = 24.0;  // px (hitbox poloměr)
  static const int    playerMaxHp        = 100;

  // ── Joystick ──────────────────────────────────────────────────────────────
  static const double joystickKnobRadius = 24.0;  // px
  static const double joystickBaseRadius = 64.0;  // px
  static const double joystickDeadzone   = 0.12;  // 0..1, pod tím = nula

  // ── Fluid shader ──────────────────────────────────────────────────────────
  static const double fluidTimeScale     = 0.15;  // rychlost animace

  // ── Paralaxní pozadí ──────────────────────────────────────────────────────
  // Každá vrstva: (scrollSpeedFactor, alpha)
  static const List<(double, double)> parallaxLayers = [
    (0.10, 0.55), // vzdálená vrstva — pomalejší, průhledná
    (0.25, 0.75), // střední vrstva
    (0.60, 1.00), // přední vrstva — nejrychlejší
  ];

  // ── Juice ─────────────────────────────────────────────────────────────────
  static const double hitStopDuration    = 0.05;  // s, zmrazení hry při hitu
  static const double knockbackImpulse   = 280.0; // px/s, síla odrazu nepřítele
  static const double knockbackDecay     = 12.0;  // koeficient útlumu za frame
  static const int    hitParticleCount   = 6;
  static const int    deathParticleCount = 14;
  static const double particleSpeed      = 180.0; // px/s
  static const double particleLifetime   = 0.4;   // s

  // ── Dash ─────────────────────────────────────────────────────────────────
  static const double dashSpeed           = 900.0;  // px/s
  static const double dashDuration        = 0.12;   // s
  static const double dashCooldown        = 0.5;    // s
  static const double dashIframes         = 0.3;    // s (delší než dashDuration)
  static const double hitInvulnerability  = 0.5;    // s i-frames po zásahu

  // ── Primární zbraň ────────────────────────────────────────────────────────
  static const double primaryFireRate     = 2.0;    // výstřelů/s
  static const double primaryRange        = 380.0;  // px, auto-aim radius
  static const double projectileSpeed     = 620.0;  // px/s
  static const double projectileDamage    = 15.0;   // base damage
  static const double projectileLifetime  = 1.2;    // s

  // ── Swarmer ───────────────────────────────────────────────────────────────
  static const double swarmerContactInterval = 0.6; // s mezi kontaktními zásahy

  // ── Spawner / Wave ────────────────────────────────────────────────────────
  static const double spawnRadius         = 550.0;  // px od hráče
  static const int    maxActiveEnemies    = 20;
  static const double waveCountdown       = 3.0;    // s před začátkem vlny
  static const double waveClearDelay      = 3.0;    // s po vyčištění vlny
  static const int    waveBaseEnemies     = 3;      // enemies ve vlně 1
  static const int    waveEnemiesPerWave  = 2;      // +N za každou vlnu
  // ── Arena brány ───────────────────────────────────────────────────────────
  static const double gateSize            = 120.0;  // šířka/výška brány

  // ── Mini-boss ─────────────────────────────────────────────────────────────
  static const double bossOrbitRadius       = 300.0;  // px od středu arény
  static const double bossPhase1OrbitSpeed  = 80.0;   // px/s po obvodu
  static const double bossPhase1FireRate    = 0.8;    // výstřelů/s
  static const double bossPhase2OrbitSpeed  = 170.0;  // px/s
  static const double bossPhase2FireRate    = 1.8;    // výstřelů/s (burst 3×)
  static const double bossFeverTrigger      = 39.5;   // °C → přechod do fáze 2
  static const double bossPhase2HpFraction  = 0.5;    // HP pod 50 % → fáze 2
  static const double bossProjectileSpeed   = 360.0;  // px/s
  static const double bossProjectileRadius  = 10.0;   // px
  static const double bossProjectileDamage  = 15.0;   // HP
  static const double bossProjectileLife    = 2.0;    // s
  static const double bossPhase2Spread      = 0.35;   // rad, úhel burstu

  // ── Místnosti / přechody ──────────────────────────────────────────────────
  static const double transitionFadeDuration = 0.5;   // s (černá obrazovka)
  static const double gateDetectDepth        = 80.0;  // px detekce vstupu do brány
  static const double eliteEnemyMultiplier   = 1.5;   // počet swarmers × 1.5
  static const int    treasureHealAmount     = 25;    // HP bonus v treasure místnosti

  // ── Horečka ───────────────────────────────────────────────────────────────
  static const double feverMin                  = 36.5;
  static const double feverMax                  = 42.0;
  static const double feverFebrilStart          = 38.0;
  static const double feverHyperStart           = 40.0;
  static const double feverCriticalStart        = 41.5;
  static const double feverCriticalKillDelay    = 3.0;  // s kumulativně nad kritickou
  static const double feverRisePerHit           = 0.3;
  static const double feverRisePerAbility       = 0.15;
  static const double feverRisePassivePerEnemy  = 0.02; // /s
  static const double feverDecayBaseline        = 0.1;  // /s
  static const double feverDecayRoomClear       = 0.4;  // /s bonus
  static const double feverAtkSpeedMin          = 1.0;
  static const double feverAtkSpeedMax          = 1.25;
  static const double feverHpDrainHyper         = 2.0;  // HP/s
}
