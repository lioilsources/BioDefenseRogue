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
