# IMMUNORUN – Synchronizace hry a knihy: implementační plán pro Opus (v0.1, 2026-10-15)

Vstup: [01-scope.md](01-scope.md), [ADR/](ADR/), `../05-kniha/02-plan.md` (milníky K0–K7).
Tento plán **upřesňuje K1 (validace) a nahrazuje K5 (razítka)** a přidává to, co kniha sama
nepokrývá: CI na PR, registr pojmů, placeholdery, proces.

Pořadí vůči knize: **S0 → S1 → K0 → K1+S2 → K2 → K3/K4 → S3 (místo K5) → K6 → S4 → K7 → S5.**

---

## 0. Pevná rozhodnutí (neměnit bez dohody)

- **Registr `domain/lore.dart` je jediný zdroj** názvů, vět „ve hře", vět „doopravdy" a odkazů do
  knihy. `UpgradeDef.nameCz/descCz` se na něj přesměrují, nekopírují (ADR 0001).
- **Žádné číslo v textu** registru ani kapitol natvrdo; jen `{{balance.<konstanta>|<formát>}}`
  (ADR 0002). Výjimka: čísla, která nejsou tuning hry (37 °C normální teplota člověka, rok 1882) –
  ta mají zdroj v `sources.md`.
- **Sync test je brána.** Červené CI na každém PR, kde přibude enum hodnota bez záznamu, záznam bez
  kapitoly, kapitola bez záznamu, nebo placeholder bez konstanty (ADR 0003).
- **Hra → kniha jen `LoreEncounter`.** Žádný vliv knihy, kvízu ani razítek na gameplay (ADR 0004,
  05-kniha ADR 0002).
- **Architektura hry platí:** čistý Dart v `domain/`, čísla v `balance.dart`, čeština v UI, angličtina
  v kódu, Riverpod v3 `Notifier`.

---

## 1. Cíl a metriky

Po S5: změna konstanty v `balance.dart` se promítne do karty upgradu i do kapitoly bez ruční
úpravy textu; přidání `EnemyType.shooter` jako samostatného nepřítele bez záznamu v registru
rozbije CI; `dart run tool/lore_report.dart` vypíše matici pokrytí (pojem × kapitola × kotva ×
honesty box × obrázek × událost setkání × zdroj) a `BOOK_RELEASE` build neobsahuje žádný pahýl.

Metriky: pokrytí registru 100 % nad enumy `UpgradeId`, `EnemyType`, `StatusEffect` (aktivní),
`DamageType`, `RoomType`, zóny horečky, meta; 0 duplicitních českých názvů v `lib/`; CI < 6 min.

---

## 2. Struktura repozitáře (delta)

```
BioDefenseRogue/
├── .github/
│   ├── workflows/ci.yml             # S0: analyze + test + gen-check + velikost assetů, na PR i main
│   └── pull_request_template.md     # S4: checklist (domain změna → lore + kapitola + sync test)
├── CLAUDE.md                        # S4: pravidlo „nový pojem = záznam v lore + kapitola"
├── Prompts/06-sync/                 # tento plán
└── immunorun/
    ├── lib/domain/lore.dart         # S1: LoreEntry, LoreKind, LoreStatus, registr `allLore`
    ├── lib/domain/lore_text.dart    # S2: render placeholderů (čistý Dart), formáty pct|pctDelta|s|degC|int
    ├── lib/config/balance_map.g.dart# S2: generovaná mapa jméno → hodnota (dart run tool/gen_balance_map.dart)
    ├── lib/game/systems/lore_encounters.dart # S3: detekce prvního setkání (čistý Dart, testovatelné)
    ├── lib/book/validation/         # S2: BookSync (kapitoly ↔ registr ↔ balance), použito testy i reportem
    ├── tool/gen_balance_map.dart    # S2
    ├── tool/lore_report.dart        # S4: matice pokrytí + render knihy do čistého Markdownu pro garanta
    └── test/
        ├── lore_registry_test.dart  # S1: úplnost nad enumy, unikátní id a nameCz
        ├── lore_text_test.dart      # S2: placeholdery, formáty, chybějící konstanta = chyba
        ├── book_sync_test.dart      # S2: obousměrné pokrytí, honesty box, kotvy, planned v release
        ├── balance_map_test.dart    # S2: generovaný soubor aktuální
        └── lore_encounters_test.dart# S3
```

Dotčený stávající kód: `domain/upgrade.dart` (nameCz/descCz → lore), `domain/meta_progress.dart`
(`killedByLabelCz` → lore; `seenLore`), `data/meta_repository.dart`, `ui/overlays/*` (texty z lore),
`hud/thermometer.dart` (název zóny z lore), `immuno_game.dart` (volání `LoreEncounters`).

---

## 3. Milníky

### S0 – CI na pull request (den 1)
Úkoly:
- `.github/workflows/ci.yml`: `on: [pull_request, push: main]`; kroky: checkout, Flutter stable
  s cache, `flutter pub get`, `flutter analyze --fatal-infos`, `flutter test`, gen-check (zatím
  prázdný krok s komentářem, naplní S2), velikost `assets/` (zatím jen výpis; limit přidá K4).
- Branch protection na `main`: vyžadovat zelené `ci` (nastaví vlastník v GitHubu, mimo kód).
Acceptance: PR s rozbitým testem je červený; tento PR sám je zelený; doba běhu < 6 min.

### S1 – Registr pojmů (týden 1)
Úkoly:
- `domain/lore.dart` podle scope §5. Záznamy pro vše, co je ve hře dnes:
  - `upgrade.*` (7), `enemy.swarmer|tank|boss` (+ `enemy.boss.phase2`), `status.opsonized|slowed`
    (ostatní 3 jako `planned`), `damage.kinetic|inflammatory|toxic|thermal`,
    `fever.normo|febrile|hyper|critical`, `room.combat|elite|treasure|boss`,
    `meta.memoryCells|vaccination`, `ability.phagocytosis|dash|special`, `resource.atp`,
    `mechanic.microscope` (falešné barvy SEM).
  - `realityCz` tam, kde hra lže (horečka a rychlost útoku, střílející makrofág, ATP z mrtvol,
    vakcinace jako +dmg, histamin jako zpomalení nepřítele, „tank = houba" dokud není rozhodnuto).
  - `chapter`/`anchor` podle osnovy 05-kniha §4 (kapitoly ještě neexistují – kotvy se ověří v S2).
- `UpgradeDef`: `nameCz`/`descCz` jako gettery přes `lore.byRef(id)`; `killedByLabelCz` z lore;
  HUD název zóny horečky z lore. Žádná kopie textu.
- `test/lore_registry_test.dart`: každá hodnota `UpgradeId`, `EnemyType`, `DamageType`, `RoomType`
  a aktivní `StatusEffect` má právě jeden záznam s `ref`; id unikátní; `nameCz` unikátní; každý
  `live` záznam má `chapter`; každý záznam s `realityCz` má `sourceRef`.
- Dočasně `inGameCz` smí obsahovat čísla natvrdo (S2 je nahradí) – test to zatím nehlídá.
Acceptance: hra vypadá stejně (karty, game-over, HUD beze změny textu); `grep` nenajde
„Opsonizace (IgG)" mimo `lore.dart`; test úplnosti zelený a padá po přidání `EnemyType.x` bez záznamu.

### S2 – Placeholdery a obousměrná validace (týden 2, s K1)
Úkoly:
- `tool/gen_balance_map.dart`: projde `config/balance.dart`, vygeneruje `balance_map.g.dart`
  (`const Map<String, num> balanceLookup`), jen `static const` číselné konstanty. Test, že je
  aktuální (regenerace bez diffu); CI gen-check krok.
- `domain/lore_text.dart`: `renderLore(String, {Map<String,num> lookup})`, formáty `pct`,
  `pctDelta`, `s`, `degC`, `int`; neznámá konstanta nebo formát = výjimka s názvem. `pctDelta`
  u hodnoty < 1 vrátí „−40 %" (slovesa zůstávají v textu, znaménko hlídá test).
- `inGameCz` všech záznamů přepsat na placeholdery; `descCz` upgradů tím pádem také.
- `lib/book/validation/BookSync` (čistý Dart, nad modelem z K1): pro každou kapitolu `lore:` seznam
  existuje; každý `live` záznam má kapitolu, která ho uvádí v `lore:`, a kotvu, která v ní existuje;
  záznam s `realityCz` → kapitola má box `doopravdy`; všechny placeholdery v kapitolách renderují;
  v `BOOK_RELEASE` žádný `planned` záznam s neprázdným textem kapitoly.
- `test/book_sync_test.dart` nad reálnými assety + záměrně rozbité fixtury.
Acceptance: změna `Balance.opsonizedDamageTakenMulti` z 1.25 na 1.30 změní kartu i kapitolu 8 bez
úpravy textu; CI padne, když kapitola odkáže neexistující záznam nebo záznam neexistující kotvu.

### S3 – Události setkání a razítka (týden 3, nahrazuje K5)
Úkoly:
- `game/systems/lore_encounters.dart`: čistý Dart, `report(LoreId)` idempotentní, `Set<String> seen`;
  detekce: první spawn typu nepřítele, první vstup do zóny horečky (febrile, hyper, critical),
  první získaný upgrade, první aplikovaný status, první místnost typu, boss fáze 2, příčina smrti,
  první paměťová buňka, první vakcinace. Vstupní body v `immuno_game.dart` (`_wireNewEnemies`,
  `chooseUpgrade`, `_setupRoom`, `_finishRun`), ve `FeverController` (změna zóny) a v
  `CombatResolver` (status).
- `MetaProgress.seenLore` (set id) + `lastChapter` + `bookFontScale`; migrace `fromMap` s defaulty.
- Kniha: razítko na obálce kapitoly, když má aspoň jeden potkaný záznam; v kapitole malá značka u
  kotvy potkaného záznamu. Toast „Nová stránka v knize" max 1× za místnost, mimo boj (při room
  clear), neklikatelný.
- Deep-linky z K5 zůstávají (game-over „Co mě zabilo?" → `lore.byKilledBy(...).chapter`, ⓘ na
  kartách → `lore.byRef(UpgradeId).chapter#anchor`, teploměr → `fever.<zóna>`).
Acceptance: unit test setkání (idempotence, všechny vstupní body simulované); E2E ručně: první tank
→ po vyčištění místnosti toast → v knize razítko u kapitoly 3; po restartu appky zůstává.

### S4 – Proces a nástroje (týden 3–4)
Úkoly:
- `tool/lore_report.dart`: matice pokrytí (pojem × kapitola × kotva × honesty box × obrázek ×
  událost × zdroj) do stdout jako Markdown tabulka; `--render cs out/` vyrenderuje kapitoly s
  dosazenými čísly do čistého Markdownu pro garanta.
- `.github/pull_request_template.md`: checklist „Mění PR něco v `domain/` nebo `balance.dart`?
  → záznam v `lore.dart` / kapitola / `flutter test` zelený / `lore_report` přiložen, pokud přibyl
  pojem".
- `CLAUDE.md`: sekce „Hra ↔ kniha": pravidlo jednoho zdroje, placeholdery, kde se co doplňuje.
- `Prompts/05-kniha/sources.md`: `sourceRef` z registru musí existovat jako položka; test.
- Obsahový CHANGELOG: `assets/book/CHANGELOG.md`, řádek při změně kapitoly; release tag hry nese
  v poznámce verzi obsahu knihy (stejný tag, bez samostatného číslování).
Acceptance: `dart run tool/lore_report.dart` běží bez chyby a ukazuje 100 % pro `live` záznamy;
PR šablona se zobrazí; `CLAUDE.md` aktualizován.

### S5 – Roadmapa do registru (týden 4, průběžně dál)
Úkoly:
- Záznamy `planned` pro mechaniky z `architecture/`: `hero.neutrophil|macrophage|nk|bcell|cd8|
  eosinophil`, `biome.epithelium|blood|lung|marrow`, `boss.staph|flu|aspergillus|apex`,
  `mechanic.mutation|resistance|sos|thPolarization|antigenPresentation|clonalSelection|
  cytokineStorm|sepsis`, `status.inflamed|trapped|stunned`. Každý s `chapter` do pahýlu
  13/14 nebo do existující kapitoly (neutrofil → 2).
- Pahýly kapitol `13-evoluce-nepratel.md`, `14-kdyz-obrana-selze.md` se `status: planned`,
  v release skryté (K1 validace + S2).
- Pravidlo přechodu: PR, který přidá do `domain/` enum hodnotu odpovídající `planned` záznamu,
  musí záznam přepnout na `live` (test: `live` záznam s `ref` musí mít `ref` v kódu; `planned`
  záznam nesmí mít `ref`, který v kódu existuje). Text kapitoly se dopíše v témže PR nebo
  v navazujícím PR do týdne – zapsáno v `open-questions.md` jako OQ-4.
- Tabulka „mechanika hry → kapitola → stav" v `lore_report` jako část výstupu.
Acceptance: `lore_report` ukazuje plánované pojmy s cílovou kapitolou; release build je neobsahuje;
test přechodu `planned → live` padá, když enum přibyde bez přepnutí.

---

## 4. Průřezové požadavky

- **Čistý Dart** pro registr, render, validaci, setkání; žádné Flame/Flutter importy.
- **Žádná duplicita textu**: český název nebo věta existuje v `lib/` právě jednou (grep v review).
- **Generované soubory** (`balance_map.g.dart`) se needitují ručně; CI gen-check.
- **Testy** na reálných assetech i na rozbitých fixturách (negativní testy jsou povinné – test,
  který nikdy nepadá, nic nehlídá).
- **Výkon**: render placeholderů cache per kapitola; nic v game loopu kromě `LoreEncounters.report`
  (O(1), set lookup).
- **Soukromí**: `seenLore` zůstává lokálně v `shared_preferences`, nic se neodesílá.

---

## 5. Jak pracovat (instrukce pro Opus)

1. Začni S0; bez CI na PR nemají ostatní milníky zuby. Pak S1, pak teprve kniha (K0, K1 spolu s S2).
2. Každý milník = větev `s<N>-<slug>`, malé commity, PR s checklistem acceptance a výstupem
   `flutter analyze` + `flutter test` (a od S4 `lore_report`).
3. **Nekopíruj text.** Když potřebuješ český název pojmu v UI, čti ho z registru. Když ho tam
   nenajdeš, přidej záznam, ne řetězec do widgetu.
4. **Nepiš čísla.** Když věta potřebuje hodnotu, je to placeholder na konstantu v `balance.dart`.
   Když konstanta neexistuje, přidej ji do `balance.dart` (s komentářem), ne číslo do textu.
5. `realityCz` je tvrzení o biologii: platí 05-kniha ADR 0003 – zdroj, nebo `TODO-FACT` a nejde do
   release.
6. Nikdy nepropojuj knihu, kvíz ani razítka s balance, HP, ATP nebo odemykáním. Pokud úkol vypadá,
   že to vyžaduje, zastav se a zeptej.
7. Negativní test ke každému pravidlu validace: fixture, která pravidlo porušuje, musí test
   shodit. Bez negativního testu milník není hotový.
8. Když architektura hry (`Prompts/architecture/`) a tento plán nesouhlasí v názvu pojmu, vyhrává
   název v registru; zapiš rozpor do `open-questions.md`.
9. Otázky, které nejde rozhodnout ze scope a plánu, zapiš do `open-questions.md` s navrženou
   odpovědí a pokračuj podle návrhu, pokud to není nevratné.

---

## 6. Co zařídit mimo kód (vlastník)

| Co | K čemu | Kdy |
|---|---|---|
| Branch protection na `main` vyžadující `ci` | S0 má smysl jen s ní | po S0 |
| Rozhodnout biologii tanku (houba vs. biofilm *S. aureus*) – OQ-1 | `realityCz` a kapitola 3 | před S1 |
| Rozhodnout, zda comba (charge dash, juke, nova) dostanou biologický výklad – OQ-2 | rozsah registru | před S1 |
| Garant dostane `lore_report --render` místo surového Markdownu | recenze bez placeholderů | od S4 |
