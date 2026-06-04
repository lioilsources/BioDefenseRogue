# IMMUNORUN — Fáze 0–2 Implementation Plan (Flame)

> Spustitelný plán pro claude-code v terminálu. Cíl: **co nejdřív hratelný** vertical slice.
> Stack: Flutter + Flame. Vizuál: reálné EM fotky (NIAID/CDC PHIL) rozpohybované shaderem.
> Companion k `PLAN` / `SYSTEMS` / `UX` / `COMBAT`.

---

## 0. Jak to rozjet nejrychleji

Iteruj na **webu** (nejrychlejší hot-reload) nebo na **desktopu**:

```bash
flutter create immunorun
cd immunorun
# přidat balíčky (claude-code: použij latest stable z pub.dev)
flutter pub add flame flutter_riverpod
flutter run -d chrome        # nejrychlejší iterace
# nebo: flutter run -d macos / -d linux / -d <device-id>
```

> Pozn.: nepinuju verze balíčků — nech `flutter pub add` vyřešit latest stable.
> Fragment shadery fungují na webu (CanvasKit) i nativně.

---

## 1. Stack & závislosti

| Balíček | Účel | Kdy |
|---------|------|-----|
| `flame` | game engine, komponenty, kolize, render | F0 |
| `flutter_riverpod` | meta/UI stav mimo game loop | F1 (HUD) |
| `flame_audio` | zvuk | později (F2+) |

Vlastní (žádný balíček): fluid shader (`assets/shaders/*.frag`), object pool, fever
systém, room graf.

---

## 2. Adresářová struktura

```
immunorun/
├── pubspec.yaml
├── assets/
│   ├── images/
│   │   ├── bg/            # EM pozadí (tkáň, plazma) — paralaxní pláty
│   │   ├── cells/         # player sprity (makrofág SEM)
│   │   └── pathogens/     # enemy sprity (cocci, atd.)
│   └── shaders/
│       ├── fluid.frag     # fluid displacement (rozpohybování pozadí)
│       └── fever.frag     # post-process vinětace/glow podle horečky
├── lib/
│   ├── main.dart
│   ├── game/
│   │   ├── immuno_game.dart        # FlameGame root
│   │   ├── world/
│   │   │   ├── arena.dart          # hranice, pozadí, kamera
│   │   │   └── background.dart     # paralaxní EM pláty + fluid shader
│   │   ├── components/
│   │   │   ├── player/
│   │   │   │   ├── player.dart
│   │   │   │   └── player_controller.dart
│   │   │   ├── enemies/
│   │   │   │   ├── enemy.dart           # base
│   │   │   │   ├── swarmer.dart         # 1. archetyp
│   │   │   │   └── enemy_spawner.dart
│   │   │   └── projectile.dart
│   │   ├── systems/
│   │   │   ├── fever_controller.dart    # CENTRÁLNÍ systém
│   │   │   ├── combat_resolver.dart     # čistý Dart, testovatelný
│   │   │   └── object_pool.dart
│   │   └── rooms/
│   │       ├── room.dart
│   │       ├── room_graph.dart
│   │       └── door.dart
│   ├── domain/                  # čistý Dart, bez Flame, unit-testy
│   │   ├── damage.dart
│   │   ├── status_effects.dart
│   │   └── enemy_archetype.dart
│   ├── ui/
│   │   ├── hud/
│   │   │   ├── hud_overlay.dart
│   │   │   └── thermometer.dart      # hero prvek
│   │   └── input/
│   │       └── virtual_joystick.dart
│   └── config/
│       └── balance.dart             # všechna tuning čísla (data-driven)
└── test/
    ├── combat_resolver_test.dart
    └── fever_controller_test.dart
```

**Princip:** simulace (Flame) oddělená od čisté logiky (`domain/`, `systems/` resolver
& fever). Logiku testuj bez renderu. UI = Flame overlays (Flutter widgety nad canvasem).

---

## 3. Vizuální pipeline — EM fotky, rozpohybované

### 3.1 Sourcing (licence!)
- **NIAID Flickr** — hlavní galerie EM/mikroskopie. Per-image licence (většinou CC BY 2.0).
- **CDC PHIL** (phil.cdc.gov) — mnoho public domain. Kredit vyžádán.
- **Wikimedia Commons** — filtruj dle licence.
- **NIH BioArt Source** (bioart.niaid.nih.gov) — public domain ilustrace pro UI/ikony.

> **Pravidlo:** u KAŽDÉHO snímku ověř konkrétní licenci (PD nebo CC BY). Veď
> `assets/CREDITS.md` se zdrojem + licencí + autorem pro každý soubor. Kredit
> např. „Courtesy: NIAID" / „CDC PHIL #18257".

### 3.2 Processing (před importem do hry)
1. **Crop** entity z fotky (cocci, makrofág) → odděl od pozadí (alpha).
2. **Recolor** na koherentní paletu (SEM je černobílý; kolorizace = tvoje art
   direction — sjednoť odstíny napříč hrou).
3. **Tile/extend** pozadí (tkáň) na bezešvé pláty pro paralax.
4. Export PNG do `assets/images/`.

### 3.3 Flame integrace
- **Pozadí:** 2–3 paralaxní vrstvy (foreground rozmazaná membrána, gameplay plát,
  background rozostřené buňky). Každá pomalu driftuje + **fluid shader**.
- **Entity:** `SpriteComponent` z cropnutých EM sprity. Hráč = makrofág SEM, swarmer
  = cocci SEM. Lehké „dýchání" (scale tween) + rotace pro život.
- **Fever post-process:** `fever.frag` na celou scénu — sílící vinětace/glow podle
  `FeverController.tempC`.

### 3.4 Fluid displacement shader (rozpohybování) — `assets/shaders/fluid.frag`

```glsl
#version 460 core
#include <flutter/runtime_effect.glsl>
precision mediump float;

uniform vec2  uResolution;
uniform float uTime;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;

    // vrstvené sinusové posuny -> dojem fluidního driftu tkáně
    float t = uTime * 0.15;
    vec2 disp;
    disp.x = sin(uv.y *  8.0 + t * 1.3) * 0.004
           + sin(uv.y * 19.0 - t * 0.7) * 0.0020;
    disp.y = cos(uv.x *  7.0 - t * 1.1) * 0.004
           + cos(uv.x * 23.0 + t * 0.9) * 0.0015;

    // jemné "dýchání" měřítka kolem středu
    vec2 c = uv - 0.5;
    float breathe = 1.0 + 0.01 * sin(t * 0.8);
    vec2 suv = (c * breathe + 0.5) + disp;

    fragColor = texture(uTexture, suv);
}
```

**Wiring (Flutter-level, nezávislé na verzi Flame):** načti přes
`FragmentProgram.fromAsset('shaders/fluid.frag')`, v render override pozadí nastav
uniformy (`uResolution`, `uTime`, `uTexture`) a kresli plát přes
`canvas.drawRect(rect, Paint()..shader = fragShader)`. `uTime` inkrementuj v `update(dt)`.

> claude-code: ověř aktuální Flame API pro shadery (Decorator vs. přímý paint);
> Flutter-level cesta výše funguje vždy. Registruj `.frag` v `pubspec.yaml` pod `shaders:`.

### 3.5 Fever post-process — `assets/shaders/fever.frag`
Vstup `uFever` (0..1 normalizováno z 36.5..42). Efekt: lerp vinětace (modrá→zlatá
febrilní→červená), nad ~0.8 přidat chvění UV + puls. Aplikuj na výsledný frame.

---

## 4. FÁZE 0 — Bootable skeleton

Cíl: chodící buňka v ohraničené aréně. **Po F0 to jde spustit a hýbat se.**

| Milník | Obsah | Definition of Done |
|--------|-------|--------------------|
| M0.1 | Flutter+Flame projekt, `ImmunoGame extends FlameGame`, `GameWidget` v `main.dart` | `flutter run -d chrome` ukáže prázdnou arénu |
| M0.2 | `Player` (`SpriteComponent`/placeholder), `PlayerController`, virtuální joystick (mobil) + WASD (desktop) | hráč se pohybuje 360° |
| M0.3 | `CameraComponent` následuje hráče; hranice arény; kolize se zdmi (`HitboxComponent`) | hráč nevyjede z arény |
| M0.4 | Paralaxní EM pozadí (statické zatím) + `fluid.frag` | pozadí žije, vlní se |

---

## 5. FÁZE 1 — Combat feel

Cíl: bojovat se swarmem, jezdit na horečce, a aby to **dobře hrálo**.

| Milník | Obsah | Definition of Done |
|--------|-------|--------------------|
| M1.1 | **Dash** s i-frames (`invulnerableUntil`), cooldown | dash projde skrz nepřítele bez dmg |
| M1.2 | **Primary** auto-aim (nejbližší cíl), projektil/melee | drž/tap → automaticky pálí na nejbližšího |
| M1.3 | **Special** drag-to-aim, stojí ATP | manuální mířený silný útok |
| M1.4 | `Swarmer` archetyp: steering AI (boids), HP, smrt, drop | swarm tě honí, umírá, dropuje |
| M1.5 | `ObjectPool` pro swarmery | desítky nepřátel bez GC hitchů |
| M1.6 | **`FeverController`** (viz §7): rise/decay, zóny, febrilní buff, kritická smrt; `Thermometer` v HUD | horečka stoupá v boji, buffuje ve sweet spotu, zabíjí nad 41.5 |
| M1.7 | Juice: hit-stop, knockback, particle per dmg type, fever vinětace | hit „kopne", přehřátí je cítit |

**Po F1 = jádro hry.** Tady strav nejvíc času na tuning (balance.dart).

---

## 6. FÁZE 2 — Room/run struktura → MVP slice

Cíl: krátký kompletní run: pár místností → boss → smrt/výhra → restart.

| Milník | Obsah | Definition of Done |
|--------|-------|--------------------|
| M2.1 | `Room`: spawn vln, **lock dveří** dokud není clear | po vstupu se zamkne, po clearu otevře |
| M2.2 | `RoomGraph`: jednoduchá větvící mapa; door-preview ikony | vybíráš z 2 dveří dle ikony odměny |
| M2.3 | Přechod mezi místnostmi (fade, reset arény) | plynulý průchod runem |
| M2.4 | Mini-boss s 2 fázemi + **fever-triggered fáze** (např. > 39.5) | boss mění fázi dle HP i horečky |
| M2.5 | Death → restart loop (zatím bez meta) | smrt → restart runu od začátku |

**Po F2 = hratelný vertical slice.** To je tvůj „zahrát si co nejdřív" cíl.

---

## 7. Klíčové moduly — specifikace

### 7.1 `FeverController` (centrální, čistý Dart)
```
tempC: double   // 36.5 .. 42.0
zóny: normo <38 | febrilní 38–40 | hyper 40–41.5 | kritická >41.5
```
Startovní tuning (vše do `balance.dart`, lad!):
- **Rise:** zásah +0.3 · zánětlivá ability +0.15 · pasivně +0.02×aktivníNepřátelé /s
- **Decay:** −0.1/s baseline · −0.4/s když místnost clear
- **Febrilní buff:** atkSpeed = lerp(1.0→1.25 přes 38→40); +malý dmg; HSP stack
- **Hyper penalta:** host HP −2/s; šance na „seizure" jitter ovládání
- **Kritická:** tempC > 41.5 déle než 3 s (kumulativně) → host death

Publikuje snapshot do Riverpoodu (HUD) i do `CombatResolver`.

### 7.2 `CombatResolver` (čistý Dart, unit-testovaný)
```dart
DamageResult resolveHit(Attacker a, Target t, FeverSnapshot fever);
// aplikuje fever modifikátory, statusy (opsonized/inflamed/trapped), vrací dmg+efekty
```
Žádné Flame importy → testovatelné bez renderu (`test/combat_resolver_test.dart`).

### 7.3 `ObjectPool<T extends Component>`
acquire/release; swarmery recyklují místo alokace per-spawn. Hlavní perf opatření.

### 7.4 `RoomGraph`
Uzly = místnosti (typ: combat/elite/treasure/boss), hrany = dveře. F2 stačí ručně
poskládané prefab room layouty + RNG větvení. Plná procedurální geometrie až po MVP.

---

## 8. Doporučené pořadí (play-ASAP path)

1. M0.1–M0.3 → **chodíš po aréně** (pár hodin práce).
2. M1.1 + M1.2 + M1.4 → **dash + střelba + jeden nepřítel** = první „hra".
3. M1.6 → **horečka** = duše projektu, zapni co nejdřív, je to ten hook.
4. M1.7 → juice, ať to chutná.
5. M2.1 + M2.5 → **místnost + restart loop** = smyčka.
6. M2.4 → boss = peak.
7. Zbytek (M2.2/2.3, paralax polish) doplň.

> Vždy commituj spustitelný stav. Každý milník = hratelný build.

---

## 9. Claude-code kickoff prompt (vlož do terminálu)

```
Stavíme top-down roguelike "IMMUNORUN" ve Flutter + Flame podle plánu
v IMMUNORUN_PHASE0-2_PLAN.md. Začni Fází 0:

1. `flutter create immunorun`, přidej flame + flutter_riverpod (latest stable).
2. Vytvoř adresářovou strukturu z §2 plánu.
3. Implementuj M0.1–M0.4: FlameGame root, Player s controllerem (joystick + WASD),
   kamera s následováním a hranicemi arény, kolize, a paralaxní pozadí s fluid.frag
   shaderem z §3.4.
4. Drž logiku oddělenou: systems/ a domain/ bez Flame importů, UI jako overlays.
5. Po každém milníku ověř `flutter run -d chrome` a commitni.

Pravidla: Go-style čistota, vše tuning do config/balance.dart, žádné magic numbers
v kódu. Komentáře česky, kód anglicky. Po Fázi 0 se zastav a ukaž mi build.
```

---

## 10. Co schválně NEdělat v F0–2
Žádná meta-progrese, mutace, vakcinace, Th polarizace, víc než 1 boss/biom, víc než
2 enemy archetypy, persistence (Drift). Až core loop **baví bez nich**. To je obsah
Fáze 3+.
