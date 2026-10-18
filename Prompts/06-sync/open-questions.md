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

## Z implementace S1 (2026-10-15)

Rozhodnuto podle návrhu a implementováno; vlastník může změnit.

- **OQ-8 Id comb.** `02-plan.md` S1 uvádí `ability.juke|nova`, OQ-2 (závazné) `ability.oxidativeBurst|
  lysozymeBurst`. Návrh a stav: platí id z OQ-2; v plánu S1 opravit při příští revizi.
- **OQ-9 „Special" (vějíř 3 střel) ve hře už není.** ATP dnes utrácí jen nova (kruhové gesto / E);
  `Balance.specialBurstCount` a `specialBurstSpread` nikdo nečte. Karta Mitochondrie („Speciální
  útok stojí o 30 % méně ATP") tím fakticky mluví o nově. Stav: `ability.special` je `retired`.
  Návrh: osiřelé konstanty odstranit v herním PR; v S2 (placeholdery) přepsat text karty na název
  z registru (`ability.lysozymeBurst`).
- **OQ-10 Pády a skloňování.** Game-over potřebuje 3. pád („imunizace proti tankovi"). Stav: pole
  `dativeCz` u záznamů, které mohou zabít (`enemy.*`, `mechanic.fever`). Rozpor: tank je v registru
  „Biofilm (shluk stafylokoků)", ale 3. pád je „tankovi" – nechán kvůli acceptance S1 (texty beze
  změny). **S2: změněno na „biofilmu" (game-over „imunizace proti biofilmu").** Dál zůstává mimo registr „+N paměťových buněk"
  (2. pád množ.); návrh: přeformulovat na „Paměťové buňky: +N" místo dalšího pole pro pády.
- **OQ-11 Zastřešující `mechanic.fever`.** Plán S1 má jen zóny `fever.*`; příčina smrti „fever"
  (kritická zóna i HP drain ve vysoké horečce) potřebuje jeden záznam. Stav: přidán
  `mechanic.fever` „Horečka" (kapitola 5, kotva `horecka`).
- **OQ-12 `planned` záznam s existujícím enumem.** `StatusEffect.inflamed|trapped|stunned` a
  `DamageType.toxic|thermal` v kódu existují, ale nemají gameplay. Pravidlo S5 („`planned` nesmí
  mít `ref`, který v kódu existuje") by je zakázalo. Stav v S1: `planned` = ref existuje, ale bez
  gameplay. U statusů to test ověřuje oběma směry (`statusBaseDuration == 0`); u typů poškození
  doména neumí poznat, zda je nějaký útok používá, takže se nekontroluje. Návrh pro S5:
  přeformulovat pravidlo na „gameplay-aktivní ref ⇒ `live`", s predikátem per enum.
- **OQ-13 Id bosse.** S1 seznam říká `enemy.boss`, OQ-5 navrhuje `enemy.boss.staph`. Stav:
  `enemy.boss` (+ `enemy.boss.phase2`), `nameCz` podle OQ-5 „Zlatý stafylokok (boss)".
- **OQ-14 Název zóny v HUD.** HUD dnes název zóny nezobrazuje (jen číslo a barvu), takže v S1
  nebylo co přepojit. Názvy zón jsou v registru připravené pro tooltip z OQ-3. Pozn.: „Vysoká
  horečka" místo „hypertermie" – hypertermie je medicínsky jiný stav než horečka.
- **OQ-15 Čísla v UI mimo registr.** `run_end_overlays.dart` má natvrdo „(+15 % dmg)" (=
  `Balance.vaccinationDamageBonus`). **S2: hotovo**, text se renderuje přes
  `renderLore('… ({{balance.vaccinationDamageBonus|pctDelta}} dmg)')`.
- **OQ-16 Zdroje.** Všechny `realityCz` mají zatím `sourceRef: 'TODO-FACT: <kandidátní zdroj>'`
  (bez čísel stran – ty doplní K0 v `05-kniha/sources.md`). Podle 05-kniha ADR 0003 je to
  blokátor release; S4 přidá test, že `sourceRef` existuje v `sources.md`.
- **OQ-17 Hraniční hodnocení `lie`.** Jako `small` označeny, ale vlastník může zvýšit na `large`:
  `enemy.swarmer` (stafylokoky nemají bičík, za obráncem se nehoní), `meta.memoryCells`
  (paměť je specifická pro jednoho nepřítele, ne obecné +HP), `upgrade.cytotoxin` (granule má
  NK/CD8 T, ne makrofág). Nový `large` nález: `enemy.boss.phase2` – zapsán do
  `03-mechaniky-z-biologie.md` §1.

## Z implementace S2 (2026-10-16)

- **OQ-18 Formát `pctLess`.** Plán zná `pct|pctDelta|s|degC|int`. Karty Histamin a Mitochondrie
  říkají „zpomalují o 40 %", „o 30 % méně"; s `pctDelta` by vyšlo „o −40 %". Stav: přidán formát
  `pctLess` (0.6 → „40 %"), který **vyhodí výjimku pro hodnotu ≥ 1**. To je hlídání znaménka
  z ADR 0002: když se konstanta otočí na zrychlení, test spadne a text se musí přepsat.
- **OQ-19 Placeholder `{{lore.<id>}}`.** Kapitola potřebuje jména karet („karta Pyrogen (IL-6)").
  Stav: `{{lore.<id>}}` → `nameCz`; BookSync hlásí chybu, když je v kapitole název karty upgradu
  natvrdo. Pro ostatní druhy pojmů se to nehlídá (běžná slova jako „Horečka" by dávala falešné
  poplachy).
- **OQ-20 Chybějící kapitoly mimo release.** BookSync má hlásit „live záznam bez kapitoly", ale
  kapitoly 00–04 a 06–12 vzniknou až v K3. Stav: mimo `BOOK_RELEASE` se záznam s neexistující
  kapitolou přeskočí; v release je to chyba (a chybějící soubor kapitoly taky). Jakmile K3 dodá
  všech 13 souborů, podmínka „mimo release" se zruší.
- **OQ-21 Desetinná čárka na kartách.** Jediná viditelná změna textu karet v S2:
  „0.15 °C/s" → „0,15 °C/s" (05-kniha OQ-12).
