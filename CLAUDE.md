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
│   ├── damage.dart          # DamageType, DamageResult
│   ├── enemy_archetype.dart # datové archetypy (swarmer, tank, boss)
│   ├── meta_progress.dart   # paměťové buňky, vakcinace (meta-progrese)
│   ├── room_type.dart       # RoomType enum + RoomNode
│   ├── status_effects.dart  # StatusEffect + multiplikátory
│   └── upgrade.dart         # definice in-run upgradů (receptory/cytokiny)
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
