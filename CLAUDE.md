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
│   └── world/               # arena.dart, background.dart
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
- Comments and UI copy in Czech, code in English
- Rooms are self-contained — room type drives enemy spawning and layout (`wave_composition.dart`)
- UI state via Riverpod v3 `Notifier` API; game publishes snapshots per frame

## Hra ↔ kniha (Lexikon zdraví)

Plán: `Prompts/05-kniha/` (kniha) a `Prompts/06-sync/` (synchronizace). Pravidla:

- **Jeden zdroj.** Český název, věta „ve hře“ a „doopravdy“ každého herního pojmu žijí jen
  v `lib/domain/lore.dart`. UI je čte z registru (`lore.byRef(...)`), nikdy je nekopíruje.
- **Nový herní pojem začíná záznamem v `lore.dart`** (nejdřív `realityCz`, pak mechanika, pak kód,
  `03-mechaniky-z-biologie.md`). Nová hodnota enumu bez záznamu shodí `lore_registry_test`.
- **Žádná čísla v textech.** Registr, karty i kapitoly používají `{{balance.<konstanta>|<formát>}}`
  (pct, pctDelta, pctLess, s, degC, int) a `{{lore.<id>}}` pro názvy karet. Po změně názvů
  v `balance.dart`: `dart run tool/gen_balance_map.dart` (CI gen-check).
- **Kapitoly** jsou Markdown v `assets/book/cs/` podle `Prompts/05-kniha/03-redakcni-standard.md`.
  Každá uvádí své pojmy v `lore:` a má jejich kotvy. Kde hra lže, kapitola má box `[!doopravdy]`.
  Tvrzení o těle mají `<!-- src: KLÍČ … -->` nebo `<!-- TODO-FACT: KLÍČ – … -->` (klíče
  v `Prompts/05-kniha/sources.md`). Release (`--dart-define=BOOK_RELEASE=true`) nesmí mít TODO-FACT.
- **Hra → kniha jen přes `LoreEncounters`** (razítka). Kniha, kvíz ani razítka nemají vliv
  na gameplay, balance ani odemykání.
- Kontrola: `flutter test` (validace, BookSync, registr), report pokrytí
  `flutter test tool/lore_report.dart` (`--dart-define=LORE_RENDER=out/` vyrenderuje kapitoly
  pro garanta). Změna kapitoly → řádek v `assets/book/CHANGELOG.md`.

