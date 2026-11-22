# BioDefenseRogue — CLAUDE.md

## Overview

Flutter/Flame roguelite game (`immunorun`). Immune system defense theme — player controls immune cells fighting pathogens in procedurally generated rooms.

Flutter project lives in `immunorun/` subdirectory.

## Commands

```bash
cd immunorun

flutter pub get
flutter run                  # debug (connected device)
flutter run -d ios
flutter run -d android
flutter build apk
flutter build ios
flutter analyze
flutter test
```

Screenshoty do obchodů (cs + en, iPhone 6,9", iPad 13", Android telefon a 10" tablet):

```bash
tool/store_screenshots.sh [ios-phone ios-tablet android-phone android-tablet]  # → fastlane/metadata/…
python3 tool/upload_store_screenshots.py ios|android [--dry-run]               # nahradí screenshoty v obchodě
```

Scény řídí `integration_test/store_screenshots_test.dart` přes `debug*` metody `ImmunoGame`.

Verze Flutteru je připnutá v `immunorun/pubspec.yaml` (`environment.flutter`); CI i release
workflow ji čtou odtud (`flutter-version-file`). Zvedá se jen tam, s novým `pubspec.lock`
a goldeny knihy přegenerovanými na macOS.

## Architecture

```
immunorun/lib/
├── main.dart                # boot: async meta load → GameWidget + overlay mapa
├── config/
│   └── balance.dart         # VŠECHNA laditelná čísla — žádné magic numbers jinde
├── domain/                  # čistý Dart, bez Flame importů, unit-testované
│   ├── lore.dart            # registr pojmů: jediný zdroj názvů a vět pro hru i knihu
│   ├── lore_text.dart       # render placeholderů {{balance.X|fmt}} a {{lore.id}}
│   ├── damage.dart          # DamageType, DamageResult
│   ├── enemy_archetype.dart # datové archetypy (swarmer, tank, boss)
│   ├── meta_progress.dart   # paměťové buňky, vakcinace (meta-progrese)
│   ├── room_type.dart       # RoomType enum + RoomNode
│   ├── status_effects.dart  # StatusEffect + multiplikátory
│   └── upgrade.dart         # definice in-run upgradů (receptory/cytokiny)
├── book/                    # kniha Lexikon zdraví: model, parser, validace, report (čistý Dart)
│   ├── model/ parser/       # Markdown z assets/book/cs/ → Chapter/BookPage/Block
│   ├── validation/          # redakční standard + BookSync (kniha ↔ registr ↔ balance)
│   └── book_repository.dart # načtení z AssetManifestu
├── data/
│   └── meta_repository.dart # persistence mety (shared_preferences + in-memory)
├── game/
│   ├── immuno_game.dart     # FlameGame root — orchestrátor (menu/pauza, room graf, wiring)
│   ├── components/          # Flame komponenty (player/, enemies/, projectile, pickup, …)
│   ├── rooms/               # room_graph.dart — generátor runu
│   ├── systems/             # herní logika: fever, combat_resolver, waves, upgrady, audio, pooly
│   ├── world/               # arena.dart, background.dart
│   └── game_observer.dart   # háčky pro appku (měření); hra z nich nic nečte
├── telemetry/               # anonymní statistiky (ol1n_telemetry), slovník v docs/telemetry.md
└── ui/                      # Flutter overlay UI
    ├── hud/                 # HUD + Riverpod notifiery (fever, hp, wave, atp)
    ├── input/               # gesture pad (mobil)
    ├── overlays/            # menu, pauza, room/upgrade choice, game over/run won
    └── meta_providers.dart  # Riverpod provider mety
```

## Conventions

- Flame `PositionComponent` hierarchy for all game objects
- Domain types in `domain/` — pure Dart, no Flame imports; systems in `game/systems/` testable without render
- All tuning numbers live in `config/balance.dart`
- Rooms are self-contained — room type drives enemy spawning and layout (`wave_composition.dart`)
- UI state via Riverpod v3 `Notifier` API; game publishes snapshots per frame
- l10n: UI hry v ARB (`lib/l10n/app_cs.arb` je zdroj, ostatní jazyky překlady), názvy pojmů v UI přes
  `lore_l10n.dart` (`entry.name`, `entry.inGame`, tabulky `lib/l10n/lore/`). Kniha je zatím jen česky.

## Hra ↔ kniha (Lexikon zdraví)

Hra a kniha sdílejí jeden registr pojmů (`lib/domain/lore.dart`); pravidla synchronizace,
placeholdery `{{balance.…}}`, standard kapitol a kontroly: [docs/hra-kniha.md](docs/hra-kniha.md).

## Odchylky

- Odchylka od lang.md: komentáře česky. UI texty česky (zdroj `app_cs.arb`), kód a identifikátory anglicky.
