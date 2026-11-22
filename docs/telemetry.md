# Anonymous gameplay statistics

ImmunoRun sends a small set of anonymous gameplay events through
[`ol1n_telemetry`](https://github.com/lioilsources/Ol1nTelemetry) so the
owner can see what new players do in their first session, how long runs
last, where players die, which upgrades and rooms they pick, whether they
open the Lexikon zdraví, and when they stop. This file is the **event
dictionary**: the constant `immunoDictionary`
(`immunorun/lib/telemetry/telemetry.dart`) and this document list exactly the
same events and properties, and `immunorun/test/telemetry_test.dart` fails
when they drift apart.

Adding an event or a property is a change to the privacy policy
(`docs/privacy.html`) and to the store privacy answers. Ask the owner first,
and change the dictionary at most once per release.

## Rules

The rules of `ol1n_telemetry` apply unchanged (see its README):

- **No persistent identifier.** No install, device or advertising id. Each
  session gets a random 128-bit id that lives in memory; unsent events in the
  offline queue carry it and are deleted once sent.
- **Cohorts are computed on the device.** Only bands leave it.
- **Only enums, bands and numbers.** No free text, no name, no device model.
  Upgrade, room and cause ids are catalogue constants of the game. Nothing
  from inside the book leaves the device: no chapter, no page, no quiz
  answer.
- **No key, no network.** Without `TELEMETRY_KEY` and an `https`
  `TELEMETRY_HOST` nothing is recorded or sent, and the menu switch is
  hidden. Local builds, forks and tests are silent.
- **The game never waits**, **off wipes the queue at once**, and
  **measuring never steers the game**: nothing in the game reads anything
  back. The game only reports to `GameObserver`
  (`immunorun/lib/game/game_observer.dart`); the deterministic domain
  (`lib/domain/`, `lib/game/systems/`) knows nothing about it.
- The queue lives in the app's own `shared_preferences` under `telemetry_*`
  keys (`PrefsTelemetryStore`).

## Audience

The store texts say "for children from 10 and adults". Measuring is built
for all platforms, but the key must not be set before the owner decides how
the app is listed (Apple Kids category, Google Play target audience and
Families, plan 04 §10.3, book OQ-8). If the app is listed for children under
13 on a store, `Telemetry.init` must not run on that platform (as in Lexify:
not on Android).

## Screens

A game has no routes; `Telemetry.screen()` follows the overlays:
`menu` (main menu), `play` (a run on screen, including room transitions),
`pause` (pause menu), `upgrade` (upgrade choice after a cleared room),
`room_choice` (door choice at a fork), `result` (game over or run won),
`book` (Lexikon zdraví open on top of any screen).

## Runs

A run is the flow `run_start` / `run_end`, with the names shared by all ol1n
games (plan §6.3): `result`, `secs`, `level`, `cause`.

- `run_start` when a run begins: START RUN in the menu, TRY AGAIN / NEW RUN on
  the result screen, RESTART RUN in the pause menu.
- `run_end` when it ends: `death` (HP or fever gave out; played to the end),
  `won` (the boss is beaten; played to the end), `restart` (RESTART RUN in
  the pause menu), `menu` (BACK TO MENU from the pause menu), `background`
  (the app went to the background mid-run and the process never came back;
  parked by the package with the values at the time of the pause).
- `level` is the room the run is in: 1 is the first room, the boss room is 4.

## Activation

The first run played to the end on this install (`run_end` with
`result: death` or `won`). Once per install.

## Features

Used by `feature_snapshot` (3rd, 6th and 11th session) to tell which parts of
the game experienced players actually touch:

| Feature | When |
|---|---|
| `book` | the Lexikon opened from the menu or the pause menu |
| `book_hint` | the Lexikon opened from a hint in the game (upgrade card, fever info, cause of death, memory cells) |
| `quiz` | a chapter quiz finished |
| `font_size` | the book font size changed |
| `parents` | the page for parents and teachers opened |
| `sound_off` | the sound switched off |
| `elite_room` | an elite room chosen at a fork |
| `treasure_room` | a treasure room chosen at a fork |

There are no error states the player sees and nothing locked in this
version, so `error_shown` and `locked_tap` are not in the dictionary.

## Common properties

Sent with every event.

| Property | Type | Values |
|---|---|---|
| `app_version` | enum | the app version (`kAppVersion`, checked against `pubspec.yaml`) |
| `platform` | enum | `ios`, `android`, `macos`, `windows`, `linux`, `other` |
| `lang` | enum | the app's resolved language: `ar`, `bn`, `ca`, `cs`, `da`, `de`, `el`, `en`, `es`, `fi`, `fr`, `gu`, `he`, `hi`, `hr`, `hu`, `id`, `it`, `ja`, `kn`, `ko`, `ml`, `mr`, `ms`, `nb`, `nl`, `or`, `pa`, `pl`, `pt`, `pt_BR`, `ro`, `ru`, `sk`, `sl`, `sv`, `ta`, `te`, `th`, `tr`, `uk`, `ur`, `vi`, `zh`, `zh_Hant` |
| `session_band` | band | session number: `1`, `2`, `3-5`, `6-10`, `11+` |
| `days_band` | band | days since measuring began: `0`, `1`, `2-6`, `7-29`, `30+`, `pre` (played before measuring began) |
| `first_session` | bool | the very first session of a new install |
| `tester` | bool | tester build (`--dart-define=TESTER=true`) |

## Events

Each event answers a question from the plan (`DevConventions`
`Prompts/04-PLAN-analytika.md` §1).

### `app_open`

Cold start, or a new session after more than 30 minutes in the background.
*New player: what happens after the first launch; do they come back.*

| Property | Type | Values |
|---|---|---|
| `start` | enum | `cold`, `resume` |
| `session_band_first` | bool | the first session of this install in its `session_band` |
| `days_band_first` | bool | the first session of this install in its `days_band` |
| `campaign` | campaign | optional; QR campaign of a new install, `^[a-z0-9-]{1,24}$` (not sent by ImmunoRun yet) |

### `screen_view`

A game screen appeared. *First-session funnel; where players go.*

| Property | Type | Values |
|---|---|---|
| `screen` | enum | `menu`, `play`, `pause`, `upgrade`, `room_choice`, `result`, `book`, `other` |
| `prev` | enum | the previous screen, or `none` |

### `screen_leave`

A game screen was left. *How long players stay on each screen; long
choices without action.*

| Property | Type | Values |
|---|---|---|
| `screen` | enum | as in `screen_view` |
| `secs` | int | foreground seconds on the screen |
| `actions` | int | app events and feature uses during the stay |

### `session_pause`

The app went to the background or is closing. Sent at once.
*When and where players stop; how much time a session takes.*

| Property | Type | Values |
|---|---|---|
| `active_secs` | int | foreground seconds in this session |
| `screen` | enum | the screen at the time, or `none` |
| `screen_secs` | int | foreground seconds on that screen |
| `runs` | int | runs started this session |

### `activation`

The first run played to the end on this install. Once per install.
*New player: how fast they reach the first real game.*

| Property | Type | Values |
|---|---|---|
| `secs` | int | seconds since this session's `app_open` |

### `feature_use`

The first use of a feature in a session (see Features).
*Experienced player: what they use.*

| Property | Type | Values |
|---|---|---|
| `feature` | enum | `book`, `book_hint`, `quiz`, `font_size`, `parents`, `sound_off`, `elite_room`, `treasure_room` |

### `feature_snapshot`

After `app_open` of the 3rd, 6th and 11th session: which features this
install has ever used. *Experienced player: what they never use.*

| Property | Type | Values |
|---|---|---|
| `f_book` | bool | Lexikon opened from a menu |
| `f_book_hint` | bool | Lexikon opened from a hint |
| `f_quiz` | bool | a quiz finished |
| `f_font_size` | bool | font size changed |
| `f_parents` | bool | parents page opened |
| `f_sound_off` | bool | sound switched off |
| `f_elite_room` | bool | elite room chosen |
| `f_treasure_room` | bool | treasure room chosen |
| `features_used` | int | how many of them |

### `menu_ready`

The main menu is usable (game, shaders, images and audio loaded). Once per
launch. *Load time: does a slow start lose new players.*

| Property | Type | Values |
|---|---|---|
| `ms` | int | milliseconds since the process started, up to 600000 |

### `run_start`

A run begins. *Funnel from menu to play; how often runs are restarted.*

| Property | Type | Values |
|---|---|---|
| `from` | enum | `menu` (START RUN), `result` (TRY AGAIN / NEW RUN), `pause` (RESTART RUN) |
| `vaccinated` | bool | the run starts with a vaccination from the last death |

### `run_end`

The run ends. *Where players struggle: how long runs last, how far they get,
what kills them, how often they give up.*

| Property | Type | Values |
|---|---|---|
| `result` | enum | `death`, `won`, `restart`, `menu`, `background`; `ok`, `cancel`, `error` exist in every flow and are unused |
| `secs` | int | foreground seconds of the run |
| `level` | int | the room the run is in, 1 = first, 4 = boss |
| `room` | enum | type of that room: `combat`, `elite`, `treasure`, `boss` |
| `cause` | enum | what ended a `death`: `fever`, `swarmer`, `tank`, `boss` (`other` for a source added later); `none` otherwise |
| `rooms` | int | rooms cleared |
| `upgrades` | int | upgrades taken |
| `cells` | int | memory cells earned (0 unless played to the end) |

### `room_choose`

A door picked at a fork. *Experienced player: do they take the elite and
treasure paths or avoid them.*

| Property | Type | Values |
|---|---|---|
| `room` | enum | `combat`, `elite`, `treasure`, `boss` |
| `level` | int | the room it leads to, 1 = first |

### `upgrade_pick`

An upgrade card picked after a cleared room. *Experienced player: which
upgrades they rely on and which they never take.*

| Property | Type | Values |
|---|---|---|
| `upgrade` | enum | `opsonin`, `histamin`, `pyrogen`, `treg`, `mitochondrie`, `membrana`, `cytotoxin` |
| `level` | int | the room it was picked in, 1 = first |

## Reading the data

`store-metrics report immunorun` on JODA (tester builds excluded). Useful
cuts:

1. First-session funnel: `app_open` → `menu_ready` → `run_start` →
   `activation` → second session (`session_band_first` with band `2`).
2. Where sessions end: the last `session_pause` per session by `screen`
   and `active_secs`.
3. Runs: `run_end` by `result`, median `secs`, `level` and `cause`, split
   by `session_band`; share of `restart` and `menu`.
4. Upgrades and paths: `upgrade_pick` and `room_choose` counts by
   `session_band`.
5. Book: time on `book` from `screen_leave`, `book` vs `book_hint`.
6. Load time: `menu_ready.ms` p50/p90 by `platform`.

## Build and checking by hand

| `--dart-define` | Meaning |
|---|---|
| `TELEMETRY_KEY` | the app key at the receiver; empty → nothing is sent |
| `TELEMETRY_HOST` | the receiver, `https`; empty → nothing is sent |
| `TELEMETRY_DEBUG` | `true` prints events to the console instead of sending them |
| `TESTER` | `true` marks the build as a tester build |

The release workflows (`release-ios`, `release-android`) pass the key and
host from the GitHub secrets of the same names; an absent secret makes a
silent build. The key and the receiver address never go into this public
repository.

```bash
cd immunorun
flutter run --profile --dart-define=TELEMETRY_DEBUG=true
```

prints one event per line; play one full run and compare with this file.
