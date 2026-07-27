// Všechna laditelná čísla hry — žádná magic numbers mimo tento soubor.
// Konvence: skupiny odděleny prázdným řádkem, názvy popisné.

import 'dart:ui' show Color;

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

  // ── Gesta / ovládání (mobil) ───────────────────────────────────────────────
  // Pohyb = drift (pomalé tažení) + dash (flick). Combos = swipe vzory.
  static const double driftSpeed          = 155.0; // px/s pomalý drift (~0.55× playerSpeed)
  static const double gestureDriftRadius  = 96.0;  // px od originu = plný drift (screen space)
  static const double gestureDriftDeadzone = 0.10; // 0..1, pod tím = nula
  // Rozpoznávání gest (vše ve screen-space px / s)
  static const double gestureFlickMinSpeed   = 850.0; // px/s prstu = flick (dash); pod = drift
  static const double gestureFlickMinDist    = 44.0;  // px min. dráha flicku
  static const double gestureFlickMaxDuration = 0.28; // s max. trvání flicku
  static const double gestureComboMinLength  = 130.0; // px min. dráha, aby šlo o combo
  static const double gestureComboReturnDist = 70.0;  // px návrat k originu = combo (juke/AoE)
  static const double gestureAoeMinTurn      = 4.0;   // rad celkové otočení = kruh (AoE)
  static const double gestureDoubleFlickWindow = 0.34; // s okno pro dvojflick → charge dash
  static const double gestureDoubleFlickDot    = 0.55; // podobnost směru dvojflicku (dot)

  // ── Fluid shader ──────────────────────────────────────────────────────────
  static const double fluidTimeScale     = 0.15;  // rychlost animace

  // ── Paralaxní pozadí ──────────────────────────────────────────────────────
  // Každá vrstva: (scrollSpeedFactor, alpha)
  static const List<(double, double)> parallaxLayers = [
    (0.10, 0.55), // vzdálená vrstva — pomalejší, průhledná
    (0.25, 0.75), // střední vrstva
    (0.60, 1.00), // přední vrstva — nejrychlejší
  ];

  // ── Pohybová stopa (trail) ──────────────────────────────────────────────────
  static const double trailLifetime   = 0.5;   // s než bod zmizí (fade-out)
  static const double trailMinSpacing = 5.0;   // px min. posun pro nový bod
  static const double trailMaxSegment = 140.0; // px — delší spoj = teleport, nekreslit
  static const double trailBaseWidth  = 9.0;   // px šířka pruhu při pomalém pohybu
  static const double trailMaxWidth   = 22.0;  // px šířka při dash rychlosti
  static const double trailMaxAlpha   = 0.55;  // 0..1 průhlednost čela stopy
  static const Color  trailColor      = Color(0xFF4DE8E8); // azurová (ladí s dash pips)

  // ── Juice ─────────────────────────────────────────────────────────────────
  static const double hitStopDuration    = 0.05;  // s, zmrazení hry při hitu
  static const double knockbackImpulse   = 280.0; // px/s, síla odrazu nepřítele
  static const double knockbackDecay     = 12.0;  // koeficient útlumu za frame
  static const int    hitParticleCount   = 6;
  static const int    deathParticleCount = 14;
  static const double particleSpeed      = 180.0; // px/s
  static const double particleLifetime   = 0.4;   // s

  // ── Dash (nábojový systém) ─────────────────────────────────────────────────
  static const double dashSpeed           = 900.0;  // px/s
  static const double dashDuration        = 0.12;   // s
  static const double dashIframes         = 0.3;    // s (delší než dashDuration)
  static const int    dashMaxCharges      = 3;      // řetězení dashů = plynulý pohyb
  static const double dashChargeRegenTime = 0.7;    // s na obnovu 1 náboje
  static const double dashInputLockout    = 0.08;   // s minimální rozestup dvou dashů
  static const double hitInvulnerability  = 0.5;    // s i-frames po zásahu

  // ── Combo: charge dash (dvojflick) ──────────────────────────────────────────
  static const int    chargeDashCost      = 2;      // náboje
  static const double chargeDashSpeed     = 1080.0; // px/s
  static const double chargeDashDuration  = 0.22;   // s
  static const double chargeDashIframes   = 0.30;   // s
  static const double chargeDashDamage    = 30.0;   // dmg při průjezdu nepřítelem
  static const double chargeDashHitRadius = 46.0;   // px zásahový poloměr při průjezdu

  // ── Combo: juke (flick tam a zpět) ──────────────────────────────────────────
  static const int    jukeCost            = 1;      // náboj
  static const double jukeIframes         = 0.45;   // s neporazitelnost
  static const double jukePulseRadius     = 150.0;  // px dosah odrazové pulzace
  static const int    jukePulseDamage     = 6;      // dmg pulzace okolním nepřátelům

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
  // Combo: radiální nova (kruhové gesto) — 360° výstřel, stojí ATP
  static const int    aoeNovaCount       = 12;     // projektily rovnoměrně po kruhu

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
