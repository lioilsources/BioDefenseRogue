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
  static const double playerSpriteHeight  = 96.0;  // px výška spritu (šířka = aspect ratio)
  static const double swarmerSpriteHeight = 52.0;  // px výška spritu

  // ── Joystick ──────────────────────────────────────────────────────────────
  static const double joystickKnobRadius = 24.0;  // px
  static const double joystickBaseRadius = 64.0;  // px
  static const double joystickDeadzone   = 0.12;  // 0..1, pod tím = nula

  // ── Fluid shader ──────────────────────────────────────────────────────────
  static const double fluidTimeScale     = 0.15;  // rychlost animace

  // ── Plavání v roztoku (mikroskopový drift kamery) ─────────────────────────
  static const double swimDriftAmplitude = 14.0;   // px, max posun kamery
  static const double swimRotationMaxRad = 0.014;  // rad (~0.8°), max náklon
  static const double swimZoomAmplitude  = 0.012;  // ±1.2 % „dýchání" zoomu
  // Váhy sinusoid (součet 1.0) a fáze — sdílené všemi kanály
  static const List<double> swimWeights = [0.5, 0.3, 0.2];
  static const List<double> swimPhases  = [0.0, 1.7, 3.9];
  // Frekvence v Hz, poměry ~1:√2:√5 → neperiodický dojem
  static const List<double> swimFreqsX     = [0.053, 0.075, 0.118];
  static const List<double> swimFreqsY     = [0.061, 0.086, 0.137];
  static const List<double> swimFreqsAngle = [0.047, 0.066, 0.104];
  static const List<double> swimFreqsZoom  = [0.058, 0.082, 0.129];
  static const double microscopeIntensity  = 0.6;  // 0..1 síla overlay shaderu

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

  // ── ATP / Special ability ────────────────────────────────────────────────
  static const double atpMax             = 100.0;
  static const double atpRegen           = 8.0;   // /s (bez dropů zatím)
  static const double atpSpecialCost     = 35.0;
  static const double specialDamage      = 40.0;
  static const double specialSpeed       = 800.0;  // px/s
  static const double specialRadius      = 9.0;    // px
  static const double specialLifetime    = 1.4;    // s
  static const int    specialBurstCount  = 3;
  static const double specialBurstSpread = 0.30;   // rad, celkový úhel fanu

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
