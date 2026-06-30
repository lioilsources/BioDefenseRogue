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
├── main.dart
├── domain/                  # Game domain models
│   ├── damage.dart          # Damage types
│   ├── enemy_archetype.dart # Enemy type definitions
│   ├── room_type.dart       # Room type enum
│   └── status_effects.dart  # Status effect system
├── game/                    # Flame game root
│   └── immuno_game.dart     # FlameGame subclass
├── rooms/                   # Room generation and layout
├── systems/                 # ECS-style game systems
├── world/                   # World state, level progression
├── components/              # Flame PositionComponent subclasses
└── ui/                      # Flutter overlay UI
```

## Conventions

- Flame `PositionComponent` hierarchy for all game objects
- Domain types (archetypes, damage, status effects) in `domain/` — pure Dart, no Flame imports
- Rooms are self-contained — room type drives enemy spawning and layout
