# IMMUNE ROGUELIKE — Systems Deep Dive

> Companion k `IMMUNE_ROGUELIKE_PLAN.md`
> Inspirace: **Bio-Defense** (Tymac/Game Gems, 1984, Atari 8-bit) × struktura **Hades**
> Téma: dungeon crawler, edukativní, věrný imunologii

---

## 0. Co bereme z Bio-Defense

Originál stál na jediném centrálním čísle — **teplotě pacienta**. Byla to obtížnost
(4 levely podle startovní teploty), fail-state (moc zásahů → teplota stoupá) i
napětí. Hráč ovládal bílou krvinku v bludišti a požíral bakterie; tyčinkovité
struktury ho při kontaktu zpomalovaly.

**Co přenášíme:**
- Teplota jako *centrální* systém (ne vedlejší stat) → **HOREČKA**.
- Ovládání jedné krvinky, "požírání" patogenů (fagocytóza zůstává core melee).
- Tělo jako prostor, který procházíš (z mřížky → z Hades biomů).

**Co přidáváme (čeho originál neměl):** mutace mezi runy, buildy, bossové s fázemi,
arzenál leukocytů, meta-progrese (paměť/očkování).

---

## 1. Mapování na strukturu Hades

| Hades | IMMUNE ROGUELIKE | Poznámka |
|-------|------------------|----------|
| House of Hades (hub) | **Kostní dřeň / Thymus** | zrod a výcvik leukocytů, meta |
| Biomy (Tartarus→Styx) | **tkáně** (epitel → krev → orgán → systém) | eskalace innate→adaptive |
| Komnaty (rooms) | místnosti tkáně | procedurální graf |
| Boony bohů | **cytokinové signály** orgánů | build modifikátory |
| Daedalus hammer | **maturační upgrady** zbraně | in-run weapon upgrade |
| Chaos boony | **mutagenní boony** (risk: nakrátko oslab, pak silný) | risk/reward |
| 6 Infernal Arms + aspekty | **6 leukocytů + aspekty** | viz §3 |
| Mirror of Night (meta) | **paměťové buňky** | permanentní unlock |
| Pact of Punishment (Heat) | **startovní HOREČKA** | obtížnostní páka, §4 |
| Boss na konci biomu | **dominantní patogen** | fáze, §2 |

---

## 2. Bossové — mechaniky a fáze

Každý boss = reálný patogen, multi-fázový, telegrafované útoky, arénové hazardy. Klíč:
**každý boss má jiný vztah k horečce** — některý ji proti tobě zneužije, jiný ti ji
naopak sráží. To nutí hráče horečku aktivně řídit, ne jen maximalizovat.

### 2.1 BIOME 1 — Epitel · „The Coagulase Crown" (*Staphylococcus aureus*)
Extracelulární bakterie, tvoří absces a biofilm.

- **Fáze 1 — Kolonie:** spawnuje swarm minionů (cocci), klasický clear. Učí swarm management.
- **Fáze 2 — Biofilm:** zdi z biofilmu stahují arénu, coagulase štíty pohlcují dmg.
  Counter: NETs / Th17 prolomí biofilm.
- **Fáze 3 — MRSA shift** *(spustí se jen při horečce > 39,5 °C)*: pod tepelným tlakem
  mutuje na methicilin-rezistentní formu — vypne tvůj „antibiotický" boon, zrychlí se.
  **Pointa:** pokud bosse přehříváš kvůli rychlému burstu, sám si spustíš jeho tvrdší fázi.

### 2.2 BIOME 2 — Krevní řečiště · „The Drift Engine" (chřipkový virus)
Intracelulární. Ztělesnění interakce horečka × mutace.

- **Fáze 1 — Únik do hostitele:** schovává se v host-buňkách. Nejde střílet zvenčí —
  musíš zasáhnout *infikované buňky* (NK / CD8). Učí MHC a „missing-self".
- **Fáze 2 — Antigenní drift:** uprostřed boje změní povrchové antigeny → tvoje
  protilátkové boony přestanou trackovat, musíš znovu „kalibrovat" (affinity maturation).
- **Fáze 3 — Cytokinová bouře:** prudce ti **žene horečku nahoru** a snaží se tě
  dotlačit přes 41,5 °C. Závod: zabij ho dřív, než tě tvoje vlastní horečka zabije.
  Treg/antipyretika tady rozhodují.

### 2.3 BIOME 3 — Cílový orgán (plíce) · „The Mycelial Sovereign" (*Aspergillus*)
Houba. Tanky, biofilm, spory. **Invertuje** horečkový tlak.

- **Fáze 1 — Sporová pole:** DoT zóny, hyfy se rozrůstají arénou.
- **Fáze 2 — Imunosuprese:** aura **sráží tvoji horečku** pod febrilní sweet spot →
  ztrácíš buffy. Poprvé ti hra horečku *bere*, ne přidává.
- **Fáze 3 — Invaze:** pokud máš horečku moc nízkou, přeroste tě. Musíš ji za boje
  znovu rozdmýchat (agresivní/zánětlivé schopnosti) a udržet, dokud houbu nespálíš.

### 2.4 FINÁLNÍ BOSS — Systémová sepse · „The Apex Strain"
**Tvoje nemesis.** Jeho kit je procedurálně složený z mutací, které tvoje patogeny
nasbíraly v *předchozích runech* (viz §5). Bojuje proti tobě rezistencemi, které sis
sám vyšlechtil. Každý hráč má jiného finálního bosse.

- Pokud jsi hrál ROS-heavy → má catalase (antioxidant), ROS skoro neúčinné.
- Pokud jsi spamoval protilátky → permanentní drift, tvoje paměť míjí.
- Pokud jsi běhal horký → plná termotolerance, febrilní zóna ho neoslabuje.
- **Counter:** meta-progrese (paměťové buňky + cílená vakcinace) + build diverzita.
  Hra tě finálním bossem nutí zúčtovat se svým vlastním stylem.

---

## 3. Leukocytové zbraně (6 Arms + aspekty)

Jako 6 Infernal Arms v Hades — 6 odlišných playstylů, každý s aspekty, které mění
chování. Každá zbraň má `Primary`, `Special`, `Cast` a vlastní mechaniku.

### 3.1 NEUTROFIL — „The Burst" · rychlý glass-cannon
- **Primary:** rychlé fagocytární kousnutí (krátký dosah, vysoký rate)
- **Special:** ROS oxidativní vzplanutí — AoE nuke, **stojí život** (neutrofil po
  degranulaci umírá)
- **Cast:** NET — past, drží swarm
- **Mechanika:** odpočet životnosti (degranulace). High risk, recykluj rychle.
- **Aspekty:** *Degranulace* (větší burst) · *NETóza* (trap-focus, control) ·
  *Roj* (přivolá neutrofilní spojence)

### 3.2 MAKROFÁG — „The Maw" · tank, fagocytóza
- **Primary:** pohlcení — sežere slabé nepřátele vcelku (heal + resource)
- **Special:** zánětlivý řev — cytokinové AoE (buff/taunt)
- **Cast:** prezentace antigenu — označí cíl (bonus antigen drop + dmg)
- **Mechanika:** APC ekonomika — generuje nejvíc antigenů na unlocky
- **Aspekty:** *M1* (agresivní, zánětlivý) · *M2* (healing/tank) · *APC* (antigen economy)

### 3.3 NK BUŇKA — „The Verdict" · anti-virus / anti-stealth
- **Primary:** cílený lytický úder — ignoruje „MHC kamufláž", vidí skryté/infikované
- **Special:** missing-self scan — odhalí a popraví nepřátele s nízkým MHC
- **Mechanika:** bonus vs. infikované host-buňky a stealth jednotky
- **Aspekty:** *Sentinel* (detekce) · *Perforin* (execute pod prahem HP)

### 3.4 B BUŇKA / PLAZMOCYT — „The Volley" · ranged, protilátky
- **Primary:** protilátkové projektily (opsonizace → mark pro bonus dmg)
- **Special:** class-switch — IgM ↔ IgG ↔ IgA ↔ IgE (mění chování projektilu)
- **Mechanika:** musí „kalibrovat" na nového nepřítele (affinity maturation) —
  první zásahy slabé, sílí. **Antigenní drift to resetuje** → přímá vazba na mutace.
- **Aspekty:** *IgE* (anti-parazit/alergická AoE) · *Memory* (drží kalibraci mezi
  místnostmi) · *Pentamer* (IgM, synergie s komplementem)

### 3.5 CYTOTOXICKÁ T (CD8) — „The Sentence" · preciznost, anti-intracelulární
- **Primary:** smrtící přesný úder na infikované buňky (lock-on přes MHC-I)
- **Special:** sériové zabíjení — chain execute
- **Mechanika:** brutální single-target, ale vyžaduje akvizici cíle; vs.
  MHC-down regulované nepřátele bezmocná → páruj s NK
- **Aspekty:** *Clone* (klonální expanze, dmg per kill) · *Memory T* (rychlejší vůči
  dříve viděným nepřátelům — synergie s meta)

### 3.6 EOSINOFIL / ŽÍRNÁ BUŇKA — „The Cascade" · zone control, fever-coupled
- **Primary:** degranulační kužel (histamin / major basic protein)
- **Special:** anafylaktická bomba — obří AoE, **prudce zvedne horečku**
- **Mechanika:** explicitně provázaná s horečkou — škáluje s horečkou a tlačí ji nahoru.
  Nejvíc „fever-build" zbraň.
- **Aspekty:** *Granulocyt* (raw dmg) · *IgE-coupling* (synergie s B-buňkou)

> **Maturační upgrady** (= Daedalus hammer): in-run dropy, které mění jednu zbraň
> (např. „Primary neutrofilu zasáhne ve vlně" / „Class-switch nemá cooldown").

---

## 4. HOREČKA — centrální systém

Globální metr **36,5 → 42 °C**. Dvojrole: okamžitý zdroj v boji **a** obtížnostní páka.

### 4.1 Zdroje a propady
- **Stoupá:** aktivita patogenů v místnosti, utržené zásahy, zánětlivé schopnosti,
  pyrogenní boony (IL-1/IL-6/TNF), anafylaktická bomba.
- **Klesá:** vyčištěná místnost, Treg / antipyretika, pomalu časem, odpočinek v hubu.

### 4.2 Křivka účinků (horečka je dobrá — do bodu)
| Zóna | Teplota | Efekt |
|------|---------|-------|
| **Normotermie** | 36,5–38 °C | baseline. Patogeny se replikují volně, ty jsi slabý. |
| **Febrilní (SWEET SPOT)** | 38–40 °C | +rychlost útoku, +dmg, **heat-shock proc** buffy; patogeny zpomalené. Tady chceš bojovat. |
| **Hyperpyrexie** | 40–41,5 °C | silné buffy, ale **host HP tikem klesá** (delirium); riziko „seizure" eventu (krátká ztráta kontroly); prudce roste mutační tlak. |
| **Kritická** | > 41,5 °C | death spiral. Trvalé → smrt pacienta = konec runu. |

### 4.3 Heat-shock proteiny (HSP)
V febrilní zóně se hromadí HSP stacky → buffy (např. odolnost, dmg). Vizuálně i
mechanicky odměňují *udržení* horečky v sweet spotu, ne jen její spike.

### 4.4 Startovní horečka = obtížnost (Pact of Punishment / 4 levely originálu)
Před runem volíš startovní teplotu. Vyšší = těžší run, ale lepší loot **a** víc
materiálu pro meta-progresi. Přímý dědic 4 obtížností Bio-Defense.

---

## 5. Mutační systém (mezi runy)

Každý druh patogenu má **genom vlastností** + rostoucí **resistance profile**. Po
každém runu hra vyhodnotí, **jak** jsi daný druh nejčastěji zabíjel, a podle toho
mutuje protiopatření:

| Tvoje dominantní taktika | Mutace patogenu | Důsledek |
|--------------------------|-----------------|----------|
| ROS / oxidativní | catalase (antioxidant) | ROS slabší |
| protilátky | antigenní drift | uložené protilátky míjí |
| fagocytóza | anti-fagocytární kapsule | engulf neúčinný |
| komplement | komplementové inhibitory | MAC neprorazí |
| **přežití vysoké horečky** | **termotolerance** | febrilní zóna neoslabuje |

### 5.1 Mutační body (mutation budget)
Patogen získá MB úměrně **selekčnímu tlaku, který přežil**. Klíčové:
**čím horčí run, tím víc MB** → vysoká horečka = rychlejší evoluce rezistence.
MB utrácí za traity z tabulky výše. Strop, aby hra nebyla nehratelná.

### 5.2 Arms race vs. meta
Proti jejich mutaci stojí **tvoje paměťové buňky a vakcinace** (meta). Cílená
vakcinace umí konkrétní linii resetnout/oslabit. To je hlavní long-game smyčka:
jejich evoluce vs. tvoje imunologická paměť.

---

## 6. Interakce HOREČKA × MUTACE (jádro hry)

Tohle je ta nejhodnotnější mechanika — krátkodobá síla proti dlouhodobé ceně.

### 6.1 Selekční tlak
- Většina patogenů je **tepelně citlivá** → ve febrilní zóně dostávají dmg / pomaleji
  se replikují. Horečka je tvůj *okamžitý* spojenec.
- ALE udržovaná vysoká horečka = **silný selekční tlak** → přeživší jedinci získají
  víc MB a mutují k termotoleranci a agresi. A tyhle mutace **přecházejí do dalšího runu**.

> **Tradeoff:** Hraj horko → vyhraješ tenhle run snáz, ale vyšlechtíš termotolerantní,
> tvrdší kmeny napříště. Hraj chladně → tenhle run je dřina, ale mutační engine
> hladovíš a budoucí runy zůstávají mírné. (Analogie nadužívání antibiotik.)

### 6.2 Stresové mutace uprostřed runu (SOS response)
Spike horečky umí spustit **okamžitou** mutaci u elit/bossů (bakteriální SOS response
reálně zvyšuje mutabilitu pod stresem). Příklad: dotlačíš bosse do hyperpyrexie kvůli
rychlému burstu → spustíš jeho rezistentní fázi (viz MRSA shift, §2.1). Přehřátí se
trestá *hned*, nejen příště.

### 6.3 „Selection Denier" strategie
Pokročilý hráč může horečku **úmyslně držet nízko** (Treg, antipyretika, chladné
zbraně), aby patogenům upřel MB. Strain se nevyvíjí → finální Apex Strain je slabý.
Cena: každý run je tvrdší bez febrilních buffů. Skill-expression v čisté podobě.

---

## 7. Příklad mutačního buildu (rozpis napříč runy)

Ukázka, jak systémy zapadají do sebe. „Build" tu není jen loadout — je to
**ko-evoluční stav tebe i patogenu napříč runy.**

### Run 1 — „Hot Burst" (agresivní start)
- **Loadout:** Neutrofil / *Aspekt Degranulace* + pyrogenní boony.
- **Styl:** úmyslně horko (febrilní→hyperpyrexie), ROS bursty na všechno.
- **Výsledek:** rychlý clear, ale dohraješ/umřeš při vysoké horečce.
- **Mutace po runu:** *Staphylococcus* získá **catalase** (ROS −40 %) + **termotolerance**
  (přežil tvé horko). Linie zalogována jako „ROS-resistant, thermotolerant".

### Run 2 — vynucený pivot
- ROS teď underperformuje, navíc patogeny díky termotoleranci replikují rychleji.
- **Pivot:** B-buňka / *Aspekt Memory*, opsonizace + komplement. Běháš chladněji.
- Funguje — dokud...
- **Mutace po runu:** antigenní **drift** → uložená kalibrace protilátek příště míjí.

### Run 3 — „Selection Denier" (vědomé zúčtování)
- **Loadout:** Makrofág / *M1* (fagocytóza, anti-kapsule maturace) + **Treg boon**
  (drží horečku nízko) + cílená **vakcinace** proti termotolerantní linii (meta).
- **Styl:** disciplinovaně nízká horečka → patogeny dostávají skoro žádné MB →
  mutační engine vyhladovělý. Drift z Run 2 obejdeš re-kalibrací díky M1 antigen
  ekonomice.
- **Finální boss (Apex Strain):** přijde obtěžkaný catalase + termotolerancí + driftem
  — vše, cos vyšlechtil v Run 1–2. Ale chladný build ho febrilně nekrmí, vakcinace
  ruší termotoleranci a M1 fagocytóza prorazí kapsuli. Zúčtováno.

**Pointa pro hráče:** žádná taktika není trvale optimální. Hra tě tlačí k diverzitě
a k vědomému řízení horečky jako evolučního tlaku — což je přesně reálná imunologie
a epidemiologie rezistence v jednom loopu.

---

## 8. Implementační poznámky (Flame / Dart)

- **Horečka:** jeden globální `FeverController` (čistý Dart, mimo Flame komponenty),
  publikuje stav do Riverpoodu pro HUD. Buffy řeš jako modifikátory v combat resolveru,
  ne hardcode.
- **Mutace:** persistuj `Map<SpeciesId, ResistanceProfile>` v Drift/SQLite. Po runu
  spusť `MutationEngine.applySelection(killStats, peakFever)`. Drž to data-driven —
  traity jako konfig, ne kód.
- **Apex Strain:** procedurálně poskládej boss kit z `ResistanceProfile` daného hráče
  při vstupu do finále. Determinismus přes run seed.
- **Bossové fáze:** behavior tree / state machine per boss; fázové přechody vázané na
  HP prahy **a** stav horečky (např. MRSA shift trigger = `fever > 39.5`).
- **Edukace:** každá mutace / boss / zbraň zapíše záznam do Codexu s reálným popisem —
  volitelná hloubka, neruší flow.
