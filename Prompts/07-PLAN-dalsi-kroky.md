# IMMUNORUN — plán dalších kroků (zadání pro Opus)

Stav k 2026-11-12, po vydání `v1.0.1`. Tento soubor je zadání pro další session: říká, co je hotové,
co je rozbité, v jakém pořadí pokračovat a kde se zastavit a zeptat vlastníka.

Pravidla projektu jsou v `CLAUDE.md` a platí celá. Tady je jen to, co z nich neplyne.

## 0. Stav plnění (2026-11-13)

Všechny PR níže (#26–#37) jsou 13. 11. mergnuté do `main` (squash). Nejdřív šel #29 (pin
Flutteru 3.47.9; stable 3.50.0 shazoval `analyze --fatal-infos`), konflikty mezi #26, #31, #32 a #35
jsou vyřešené. Celek prošel gate na macOS (274 testů včetně goldenů). Nový tag ani release zatím
není. Grafika G3/G4 se generuje na L40S podle `art/fx/BRIEF.md` (větev `art/fx-bg`).

| bod | PR | stav |
|---|---|---|
| 2.0 hotfix vyčištění místnosti | #27 | test bez opravy padá, s ní projde; na zařízení neověřeno |
| 2.1 PR #26 lokalizace | #26 | merge `main`, nový lock; příčina byl lock ze staršího Flutteru, ne CI |
| 2.2 goldeny knihy | #28 | tolerance 0,01 %, přegenerované, `failures/` pryč; na macOS 247/247 |
| 2.3 pin Flutteru | #29 | `environment.flutter` v pubspec + `flutter-version-file` |
| 2.4 verze z tagu, pre-release | #30 | úryvek otestovaný lokálně; workflow neběžel |
| 2.5 #1 a staré větve | – | čeká na R5 |
| §9 hitboxy | #31 | test u 6 komponent; balance neladěná |
| §9 přetečení dialogu, obrázky karet | #32 | `FitToScreen`, `cacheWidth`, velikost v `balance.dart` |
| §9 filtrování spritů | #33 | ověřeno okem; výkon na zařízení neměřen |
| §9 dokumentace, `install.py` | #34 | `install.py` vyzkoušený na kopii repa |
| §9 ikona v `LoreEntry` | – | návrh do registru, čeká na vlastníka |
| 3 karty místností (G1) | #35 | existující ikony; Léčení = červená krvinka (k rozhodnutí) |
| 3 FX, pozadí, menu (G3, G4) | art/fx-wiring | obrázky z L40S (`art/fx/`); `fluid.frag` dál procedurální, aréna ho zakrývá |
| 4 OQ-29 odkazy pro rodiče | #36 | dialog + `url_launcher`; otevřená rodičovská brána pro Kids/Families |
| 4 balíček pro garanta | – | připravený lokálně (zip), poslat garantovi je na vlastníkovi |
| 5 screenshoty pro story | – | nezačato |

## 1. Kde jsme

- `main` = `d81a17b`, tag `v1.0.1`. Build je v TestFlightu a ve Firebase App Distribution (skupina
  „Alfa“). Obsahuje fotorealistické ikony ve hře, na kartách upgradů a v knize (PR #23, #24, #25).
- CI na `main` je zelená, ale golden testy knihy v ní neběží (`skip: !Platform.isMacOS`). Na macOS,
  jediné platformě, kde běží, jsou 4 ze 7 červené (viz 2.2).
- Code review PR #23 a #24 našlo chybu, která je ve vydaném `v1.0.1`: místnost se může vyhodnotit
  jako vyčištěná dřív, než se nepřítel načte (viz 2.0). To je první úkol.
- Otevřené PR: **#26** lokalizace do 45 jazyků (CI červená, viz 2.1) a **#1** z července (zastaralé
  docs, viz 2.5).
- Kniha Lexikon zdraví je obsahově hotová (13 kapitol), ale `release-checklist.md` v
  `Prompts/05-kniha/` nemá zaškrtnutou ani jednu položku. V obsahu je 241 `TODO-FACT`.
- Dva pracovní stromy: `BioDefenseRogue/` stojí na už mergnuté větvi `art/card-icons`,
  `BioDefenseRogue-book/` na `release/v1.0.1` (= `main`). Začni `git switch main && git pull`.

## 2. Etapa A — úklid po vydání (malé PR, bez čekání na vlastníka)

Každý bod je samostatný PR. Bod 2.0 jde první. Dál je pořadí závazné jen u 2.1 → 2.3 (pin
Flutteru změní lock).

### 2.0 Hotfix: místnost se vyčistí dřív, než se nepřítel načte

- Mechanismus: `WaveController` (`wave_controller.dart:66,75`) počítá nepřátele přes
  `world.children.whereType<Enemy>()`, tedy jen už připojené komponenty. Od PR #23 čekají
  `MiniBoss.onLoad` (`mini_boss.dart:42–43`, dva obrázky po sobě) a `Tank.onLoad` (`tank.dart:22`)
  na dekódování ikony, stejně jako `Swarmer` (`swarmer.dart:32`). Dokud se obrázek dekóduje,
  nepřítel v `children` není, počet je 0 a zavolá se `_onCleared()`.
- Dopad: u prvního bosse po spuštění appky (studená cache obrázků) může `_onWaveCleared` rovnou
  zavolat `_triggerRunWon()` (`immuno_game.dart:362–363`): výhra a paměťové buňky bez boje, boss
  se připojí až pod obrazovkou výhry. Totéž hrozí u první vlny koků: upgrade zdarma a otevřené
  brány, zatímco nepřátelé žijí.
- Stav ověření: review to potvrdilo zkušebním testem (boss připojen ~32 ms po `add`, snímek trvá
  16,6 ms). Mechanismus jsem ověřil čtením kódu. **Na zařízení to nikdo nezkoušel**, první krok je
  reprodukce: studený start, dojít k bossovi.
- Oprava na dvou místech, obě chtějí test:
  1. Přednačti pět herních ikon v `ImmunoGame.onLoad` vedle `audio.preload()`
     (`immuno_game.dart:192`): `makrofag`, `kok`, `biofilm`, `stafylokok`, `stafylokok-faze2`.
  2. `WaveController` ať počítá i nepřátele, kteří jsou přidaní, ale ještě nepřipojení (čítač
     spawnů snižovaný při smrti, nebo čekání na `loaded`). Samotné přednačtení závod jen zkrátí.
- Regresní test: bossova místnost se studenou cache se nesmí vyčistit, dokud boss žije. K tomu
  test, že všechna id ikon použitá v herním kódu existují v `assets/images/icons/` (dnes to
  `test/upgrade_icons_test.dart` hlídá jen pro karty).
- Po merge navrhni vlastníkovi `v1.0.2`. Tag nedělej sám.

### 2.1 PR #26: zezelenat a připravit k merge

- CI padá jen v kroku Gen-check: po `flutter pub get` se změní `pubspec.lock` a
  `git diff --exit-code` selže. Analyze i testy (242) prošly. Lock na větvi nejspíš vznikl jinou
  verzí Flutteru, než má CI (`channel: stable` bez pinu). Tuhle příčinu jsem neověřoval, ověř ji.
- Větev je 9 commitů za `main`. Zkušební merge je textově čistý.
- Postup: mergni `main` do `i18n/all-langs`, `flutter pub get`, commitni lock, pusť celou bránu.
- Na co si dát pozor po merge: #24 měnil `upgrade_choice_overlay.dart` (ikony na kartách) a #26
  tentýž soubor (směrové varianty pro RTL). Textově se to nepere, ale ověř to pohledem ve hře,
  aspoň v češtině a v jednom RTL jazyce. `test/l10n_test.dart` musí zůstat zelený i s texty,
  které do `main` přibyly po odbočení větve.
- Merge do `main` nech na vlastníkovi (590 souborů, strojové překlady bez kontroly rodilým mluvčím).

### 2.2 Golden testy knihy jsou červené a nic je nehlídá

- `test/book/book_golden_test.dart` běží jen na macOS (`_skip = !Platform.isMacOS`, řádek 14), CI
  na Linuxu je přeskakuje. Na macOS se 4 ze 7 goldenů liší o 3–12 px (0,00 %): `book_list`,
  `horecka_p3_zvedave`, `horecka_p4_doopravdy`, `horecka_p5_prakticky`. Padaly už před PR #23.
- Příčinu jsem nehledal. Nejdřív se podívej na rozdílové obrázky v `test/book/failures/`. Když jde
  jen o vyhlazování hran (typicky po zvednutí Flutteru), přegeneruj goldeny na macOS
  (`flutter test --update-goldens test/book/book_golden_test.dart`) a zvaž malou toleranci ve
  vlastním `GoldenFileComparator`. Když je rozdíl v obsahu, je to chyba knihy a patří do PR zvlášť.
- Pin Flutteru (2.3) má platit i lokálně, jinak se goldeny rozjedou znovu.
- V `main` je omylem 16 sledovaných PNG v `immunorun/test/book/failures/` (přišly commitem
  `89a561a` z PR #24). Složka je v `.gitignore`, ale soubory už sledované jsou. Odeber je
  `git rm --cached` ve stejném PR. Do appky se nebalí, je to jen nepořádek v repu.

### 2.3 Pin verze Flutteru v CI a release workflow

- `ci.yml`, `release-android.yml` i `release-ios.yml` berou `channel: stable` bez verze. Každé
  vydání Flutteru může rozbít Gen-check (lock) i goldeny.
- Připni `flutter-version` ve všech třech na verzi, kterou CI teď skutečně používá (zjisti z logu
  posledního běhu na `main`), a do `CLAUDE.md` připiš jednu větu, kde se verze zvedá.

### 2.4 Release workflow: štítky a verze

- `release-android.yml:83` má `prerelease: true` natvrdo, `release-ios.yml:144` to odvozuje z tagu
  (alpha/beta/rc). Oba zapisují do téhož GitHub releasu, takže `v1.0.1` skončil jako pre-release.
  Dej do Androidu stejný výraz jako v iOS.
- Verze appky se bere z `pubspec.yaml` a zvedá se ručně. Při `v1.0.1` jsem ji musel dorovnat
  commitem přímo do `main`. Odvoď základ verze z tagu (`v1.0.1-alpha` → `1.0.1`), při
  `workflow_dispatch` nech pubspec.
- Skupina Firebase `Alfa` (`release-android.yml:91`): beze změny, dokud vlastník neřekne jinak.
- Workflow nespouštěj. Změnu ověř čtením a `actionlint`, ostrý běh je až další release.

### 2.5 Úklid

- PR #1 (z 2026-07-13, `Prompts/03-PLAN-phase-3-7.md` + revize architektury): navrhni vlastníkovi
  zavřít, nebo z něj vytáhni plán Fází 3–7 do nového PR. Nezavírej sám.
- Větve `art/icons`, `art/card-icons`, `art/book-icons` jsou mergnuté (#25 squashem, takže
  `git branch -d` ho neuzná). Mazání vzdálených větví jen se souhlasem vlastníka.

## 3. Etapa B — dokončení grafiky (`Prompts/04-PLAN-grafika.md`)

Stav milníků oproti plánu:

| Milník | Stav |
|--------|------|
| G1 karty | upgrady hotové (7), **místnosti chybí**: 4 Material ikony v `room_choice_overlay.dart:58–61` |
| G2 entity | hotovo (hráč, koky, tank, boss i 2. fáze jako sprity) |
| G3 pozadí a FX | **nezačato**: `projectile.dart`, `pickup.dart` a střela bosse jsou kruhy, `fluid.frag` nemá sampler |
| G4 UI | ikona appky hotová; **chybí** pozadí menu, obrazovky konce runu, ikony mety |

- Generování běží na SPARKu (`art/icons/`, `art/book/gen.py`, adresa přes `SPARK_HOST`). Bez
  přístupu k němu připrav prompty a zapojení do kódu za existující ikony, obrázky dodá vlastník.
- Každý nový soubor v `assets/images/` potřebuje řádek v `assets/CREDITS.md`.
- `art/book/manifest.json` má `license_verified: false` (OQ-2). Ověření licencí modelů je podmínka
  veřejného vydání, ne testovacích buildů.
- Pořadí: karty místností (hráč je vidí po každé místnosti) → FX → pozadí → menu.

## 4. Etapa C — kniha k veřejnému vydání

Většina `release-checklist.md` čeká na lidi (garant, čtenářský test se 3 dětmi, průchod na
zařízení). Co jde udělat bez nich:

- Balíček pro garanta: `flutter test tool/lore_report.dart --dart-define=LORE_RENDER=out/`,
  k tomu `garant-todo-fact.md`. Kapitola 12 (očkování) jde první (OQ-10, OQ-21).
- OQ-29: odkazy ze strany pro rodiče mají otevírat prohlížeč až po potvrzení. Zjisti stav a dodělej.
- `BOOK_RELEASE=true` dnes nepouští žádný workflow, `v1.0.1` vyšel s `TODO-FACT` v obsahu. Pro
  testery to nevadí. Před odesláním do storů musí existovat brána (viz rozhodnutí R3).
- `TODO-FACT` sám neodstraňuj a zdroje nedoplňuj z hlavy. Smí je uzavřít jen garant nebo ověřená
  citace z `sources.md`.

## 5. Etapa D — story

- `fastlane/metadata/` (iOS 50 složek, Android 44) přijde s #26. Nahrání je ruční, workflow chybí.
- Screenshoty do storů nejsou. Navrhni generování z integračního testu (aspoň cs + en, telefon a
  tablet).
- Kniha je jen česky, store texty to v ostatních jazycích přiznávají.

## 6. Etapa E — gameplay

V `lib/domain/lore.dart` je 26 záznamů `planned` (roadmapa z 06-sync S5), fázový plán je v
`Prompts/architecture/IMMUNE_ROGUELIKE_PLAN.md` §11. Další obsah (patra, nepřátelé, Th polarizace)
nezačínej bez zadání od vlastníka. Každý nový pojem jde přes `lore.dart` dřív než přes kód.

## 7. Rozhodnutí, která patří vlastníkovi

- **R0** Vydat `v1.0.2` hned po opravě 2.0, nebo počkat na další změny?
- **R1** Merge #26: strojové překlady pustit hned, nebo až po kontrole vybraných jazyků?
- **R2** Ochrana `main`: `enforce_admins` je vypnuté, takže vlastník pushne i bez zelené „ci“.
  Zapnout?
- **R3** Kde bude brána `BOOK_RELEASE`: doporučuju u odeslání do storů, ne u tagu, protože tagy bez
  přípony se používají i pro testovací buildy.
- **R4** Firebase skupina a `prerelease` u tagů bez přípony (2.4).
- **R5** PR #1 a staré vzdálené větve (`docs/*`, `claude/jak-dal-r2cbif`): zavřít a smazat?
- **R6** Priorita mezi etapami B, C, D, E po dokončení etapy A.

## 8. Jak pracovat

- Jeden bod = jedna větev z `main` = jeden PR. Do `main` nepushuj přímo, ani když to GitHub dovolí.
- Brána před každým PR: `flutter analyze --fatal-infos`, `flutter test`,
  `dart run tool/gen_balance_map.dart` bez diffu. U změn UI navíc spuštění appky a pohled.
- Tag, release, nahrání do storů, merge do `main`, mazání větví a změna nastavení repa jen na
  výslovný pokyn vlastníka.
- Když se zjištění z repa rozchází s tímhle plánem, platí repo. Rozdíl napiš do PR.

## 9. Nálezy z code review

Review z 2026-11-12 pokrylo PR #23 a #24 (`main...art/card-icons`). PR #25 (ikony v knize) a #26
(lokalizace) v něm nejsou. Nejzávažnější nález je bod 2.0, zbytek je tady. U každého nejdřív ověř,
že na `main` ještě platí.

**Chování hry**

- **Hitbox mimo sprite** (`enemy.dart:63`, `player.dart:104`): `CircleHitbox(radius, anchor:
  Anchor.center)` nemá pozici, takže sedí na levém horním rohu rodiče, ne ve středu. Posun je
  (−r, −r), u bosse (r = 40) 56 px. Review simulovalo střely mířené přesně na bosse z 24 směrů a
  6 minulo. Chyba je starší než sprity (#23 stejnou příčinu opravil jen pro sprite přes
  `center: size / 2`). Oprava změní, jak často zásahy sedí, takže po ní projdi obtížnost a napiš to
  do PR.
- **Dialog upgradů přetéká na malých telefonech na šířku** (`upgrade_choice_overlay.dart:94`):
  ikona vyrostla z 38 na 72 px, dialog má 362–377 px. Při 800×360 přetéká o 2–17 px, při 667×375
  o 2 px. Přidej widget test v 800×360.

**Testy a jeden zdroj**

- Cesta k ikoně se skládá na třech místech: `SwimSprite.icon` (`swim_sprite.dart:38`), přímé
  `Sprite.load` v `mini_boss.dart:43` a `upgradeIconAsset`. Sjednoť do jednoho pomocníka.
- Přiřazení pojem → ikona je natvrdo v overlayi a v třídách nepřátel, přitom
  `art/icons/manifest.json` má ikony pod lore id. Návrh z review: pole `icon` v `LoreEntry` a test
  shody s manifestem. Zasahuje do registru, takže nejdřív krátký návrh v PR.

**Výkon a úklid**

- `Image.asset` na kartě dekóduje celých 512×512 pro slot 72 pt a nemá `errorBuilder`
  (`block_view.dart:249` to dělá správně přes `cacheWidth`). Velikost 72 patří do `balance.dart`.
- `SwimSprite` kreslí ikony 512 px ve velikosti 36–96 pt s výchozím `FilterQuality.none`.
  Nejspíš to zrní a třpytí se při pohybu, okem to nikdo neověřil. Zkus `FilterQuality.medium`.
- Balí se celá složka `assets/images/icons/` (24 ikon). Ke commitu review jich kód používal 12,
  po #25 jich bude víc. Přepočítej na `main`, než něco vyhodíš.
- Dokumentace si odporuje: `assets/CREDITS.md` nahoře tvrdí „žádné externí snímky“ nad novým
  oddílem ikon, `art/icons/BRIEF.md` mluví o 21 ikonách včetně protilátky (manifest jich má 24
  a protilátku ne), `Prompts/04-PLAN-grafika.md` odkazuje na smazané soubory.
- `art/icons/install.py` nemaže staré výstupy, může skončit v půlce a model má natvrdo.
