# Otevřené otázky – synchronizace hry a knihy

Každá má navrženou odpověď; implementace se jí drží, dokud vlastník nerozhodne jinak.

## Před S1

- **OQ-1 Biologie tanku – ROZHODNUTO 2026-10-15.** Tank v biomu 1 je **shluk *Staphylococcus
  aureus* v biofilmu** (bakterie, ne houba); houba přijde s biomem 3 (*Aspergillus*) jako `planned`.
  Registr: `enemy.tank`, `nameCz` „Biofilm (shluk stafylokoků)", `realityCz`: biofilm je sliz
  (extracelulární matrix), ve kterém bakterie drží pohromadě a obránci i antibiotika se k nim hůř
  dostanou; proto tank snese víc a hůř se odstrčí (`knockbackResist`). Plán grafiky §1, §2 upraven:
  ametystová = slizová matrix, zlaté koky uvnitř; houby dostanou vlastní tón až s biomem 3.
- **OQ-2 Comba – ROZHODNUTO 2026-10-15: dostanou biologický výklad.** Mapování podle toho, co
  combo mechanicky dělá (`balance.dart` §Combo), ne podle názvu:

  | Combo | Mechanika ve hře | Záznam | Biologie | `realityCz` (honesty box) | Kapitola |
  |---|---|---|---|---|---|
  | Dash (flick) | rychlý posun, i-frames, 3 náboje | `ability.dash` | membránová fluidita, améboidní pohyb | buňka „neuhýbá" rychleji než bakterie; neporazitelnost je herní | 9 |
  | Nabitý dash (dvojflick) | delší a rychlejší průjezd, poškozuje, co projede | `ability.chargeDash` | **panožky (pseudopodia) a aktinový skelet** – makrofág se „přelije" dopředu a obalí, čeho se dotkne | makrofág do bakterií nenaráží, obaluje je; „průjezdový damage" je zkratka pro pohlcení za pohybu | 9 (pohyb), 4 (pohlcení) |
  | Juke (flick tam a zpět) | 1 náboj, neporazitelnost 0,45 s, pulz poškození v okruhu | `ability.oxidativeBurst` | **oxidativní vzplanutí (ROS)** – buňka kolem sebe uvolní reaktivní formy kyslíku | ROS poškozují i vlastní tkáň; nic jako neporazitelnost neexistuje, buňka se jen krátce „stáhne" | 4 |
  | Nova (kruhové gesto) | 12 střel do všech stran, stojí ATP | `ability.lysozymeBurst` | **lysozym** – enzym, který štěpí stěnu bakterií; makrofág ho vylučuje do okolí (je i v slzách a slinách) | lysozym není střela, je to molekula v tekutině kolem buňky; „12 střel" je jen obrázek pro „všemi směry" | 4 |
  | Special (drag) | vějíř 3 střel, stojí ATP | `ability.special` | sekreční granule (cytotoxické látky, NO) | makrofág nestřílí; vylučuje látky směrem k cíli | 4, 10 |

  Poznámky: (a) `architecture/SYSTEMS.md` §3.1 dává ROS burst neutrofilu jako special, který stojí
  život; to není rozpor – makrofágy ROS tvoří také, jen slaběji; až přijde neutrofil, bude mít
  vlastní záznam `ability.oxidativeBurst.neutrophil` a kniha v kapitole 2 vysvětlí rozdíl.
  (b) Všechna čtyři tvrzení o biologii (panožky/aktin, ROS, lysozym, sekrece) jsou učebnicová
  (Janeway kap. 3, Hořejší kap. o fagocytóze) – Opus doplní `sourceRef` v S1; do té doby `TODO-FACT`.
  (c) Lysozym v slzách a slinách je „Věděl/a jsi" kapitoly 4.
- **OQ-3 Název zóny horečky v HUD.** Dnes HUD ukazuje jen číslo a barvu. Návrh: název zóny z
  registru jako tooltip při dlouhém stisku (stejná interakce jako deep-link do knihy), ne stálý text.

## Před S5

- **OQ-4 Lhůta na dopsání kapitoly po přepnutí `planned → live`.** Test vynutí přepnutí záznamu,
  ne text kapitoly. Návrh: text v témže PR, nebo navazující PR do týdne; do té doby kapitola nese
  box „Tahle stránka se právě píše" (v release skrytý záznam není, protože `live` záznam text
  vyžaduje – tedy fakticky: release build bez textu neprojde testem). Vlastník rozhodne, zda je to
  příliš tvrdé.
- **OQ-5 Rozpory názvů architektura vs. registr.** `EnemyType.shooter` je v kódu boss; v
  architektuře „The Coagulase Crown". Návrh: id `enemy.boss.staph`, `nameCz` „Zlatý stafylokok
  (boss)", `ref: EnemyType.shooter`; při rozdělení na víc bossů se `shooter` přejmenuje v kódu.

## Před S4

- **OQ-6 Angličtina.** Registr má `nameCz`, `inGameCz`, `realityCz`. Návrh: až s anglickou knihou
  (05-kniha fáze 2) přejít na `Map<Locale, LoreStrings>`; teď jen nepsat do kódu nic, co by to
  blokovalo (žádné `Cz` v id, jen v názvech polí).
- **OQ-7 Report v appce.** `lore_report` běží jen z terminálu. Návrh: nepřidávat debug obrazovku do
  appky; stačí nástroj a CI artefakt.
