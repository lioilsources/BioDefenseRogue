# IMMUNE ROGUELIKE — Game Design & Architecture Plan

> Dungeon crawler (Isaac/Hades-style) · Flutter + Flame · edukativní, věrný imunologii
> Pracovní název: **IMMUNORUN** (placeholder)

---

## 0. Vysoká koncepce (one-liner)

Hraješ za imunitní buňku nasazenou do infikovaného těla. Procházíš tkáně po
místnostech, ničíš patogeny v reálném čase, sbíráš receptory a cytokiny do svého
"buildu". Tělo je dungeon, infekce eskaluje, a tvoje smrt není konec — **paměťové
buňky přežijí a příští run začínáš imunizovaný**. To je očkování jako meta-progrese.

Centrální designová teze: **imunitní systém JE roguelike.** Vlny nepřátel, permadeath
(smrt hostitele), získávání buildů (klonální selekce), eskalující obtížnost (mutace
patogenů), meta-progrese (imunologická paměť). Nic z toho nemusíme vymýšlet — jen to
věrně přeložit do mechanik.

---

## 1. Core loop

```
Nasazení do tkáně (tutorial floor / skin)
        │
        ▼
  ┌─────────────────────────────────────────┐
  │  PATRO = infikovaná lokace                │
  │  • místnosti propojené graf-mapou         │
  │  • real-time twin-stick combat            │
  │  • drop: antigen-vzorky, ATP, receptory   │
  │  • elite místnosti, treasure, event       │
  └─────────────────────────────────────────┘
        │ (boss = dominantní patogen patra)
        ▼
  LYMFATICKÁ UZLINA (hub mezi patry)
  • prezentace antigenů → odemčení cílených upgradů
  • volba diferenciace (Th1 / Th2 / Th17 / Treg)
  • "rest" / re-spec / nákup za antigeny
        │
        ▼
  Další patro (vyšší tier, mutovaní nepřátelé)
        │
        ▼
  FINÁLNÍ BOSS (superbug / systémová infekce)
        │
   smrt NEBO clear → META: paměťové buňky → další run silnější
```

---

## 2. Tělo jako dungeon — patrová struktura

Patra kopírují reálný průběh imunitní odpovědi (innate → adaptive). To dává hře
přirozený oblouk **a** edukační hodnotu zároveň.

| # | Patro | Biologie | Co se hráč naučí | Dostupné nástroje |
|---|-------|----------|------------------|-------------------|
| 1 | **Epitel / kůže** | první bariéra, místo průniku | bariéry, zánět | innate: fagocytóza, ROS |
| 2 | **Lymfatická uzlina** (HUB) | aktivace adaptivní imunity | prezentace antigenu, klonální selekce | odemyká adaptivní strom |
| 3 | **Krevní řečiště** | systémové šíření, rekrutace | chemotaxe, extravazace | komplement, protilátky |
| 4 | **Cílový orgán** (plíce/střevo) | tkáňově specifická obrana | slizniční imunita (IgA), Th17 | tkáňové rezidentní buňky |
| 5 | **Kostní dřeň / slezina** (finále) | zdroj buněk, systémový boss | imunitní paměť, regulace | full kit |

> **Tip na variabilitu:** cílový orgán (patro 4) procedurálně rotuj — plíce
> (respirační virus), střevo (slizniční bakterie), CNS (oportunní patogen). Každý
> orgán = jiná sada nepřátel a jiný optimální build. To je hlavní zdroj replayability.

---

## 3. Postava hráče — od naivní buňky ke specialistovi

Isaac/Hades drží **jednu postavu + buildy přes itemy**. My to uděláme stejně, ale s
biologickým twistem: začínáš jako **naivní efektorová buňka** a během runu se
**diferencuješ** podle toho, jaké receptory a cytokiny posbíráš.

**Startovní postavy (odemykatelné, = "weapon aspects" z Hades):**

- **Neutrofil** — rychlý, křehký, krátký život (soft časový limit na run-segment),
  burst damage (ROS), NETs jako trap. Agresivní glass-cannon.
- **Makrofág** — pomalý, tanky, fagocytóza (melee "sežrání" nepřátel = heal/resource),
  navíc APC (lepší antigen drop). Univerzál.
- **NK buňka** — specialista na virem-infikované buňky, ignoruje "MHC kamufláž".
  Counter k intracelulárním nepřátelům.
- **Dendritická buňka** (advanced unlock) — slabá v boji, ale super-APC: každý
  zabitý nepřítel dává masivní antigen → nejrychlejší build-up adaptivních upgradů.
  High-skill, high-reward.

---

## 4. Combat — mechaniky mapované 1:1 na imunologii

Každá herní mechanika má reálný protějšek. Žádný flavor "naoko" — názvy i funkce sedí.

| Mechanika ve hře | Imunologie | Herní efekt |
|------------------|-----------|-------------|
| Melee "sežrání" | **Fagocytóza** | makrofág/neutrofil pohltí slabého nepřítele → heal/resource |
| Ranged projektil | **Protilátky (IgG)** | opsonizace/neutralizace na dálku |
| AoE puls | **Cytokiny** (IL-6, TNF-α) | buff spojencům / debuff nepřátelům v oblasti |
| Stacking DoT | **Komplement (MAC)** | membrane attack complex prorazí stěnu, tik damage¹ |
| Burst nuke | **ROS / oxidativní vzplanutí** | neutrofilní burst, vysoký dmg, vyčerpá energii |
| Trap / snare | **NETs** (neutrophil extracellular traps) | síť, která drží swarm na místě |
| "Learn" enemy | **MHC prezentace** | po dostatku antigenů odemkneš cílený counter |
| Self-destruct kill | **Cytotoxická T (CD8)** | zabije host-buňku skrývající intracelulární virus |

> ¹ **Revize (viz `IMMUNE_ROGUELIKE_REVIEW.md` §A2 #6):** MAC (C5b–C9) lyzuje hlavně
> **gramnegativní**/obalené buňky; **grampozitivní** (tlustý peptidoglykan — *Staphylococcus*,
> *Streptococcus*) a houby jsou z velké části **MAC-rezistentní**. Hlavní role komplementu jsou
> navíc **opsonizace (C3b)** a **anafylatoxiny/chemotaxe (C3a/C5a)**, ne jen MAC. U grampozitivních
> bossů (S. aureus) udělat komplementovou rezistenci explicitní — je to reálná lekce, proč
> komplement není univerzální (counter přes NETs/Th17/fagocytózu).

**Zdroje (resource economy):**
- **ATP** — energie pro aktivní schopnosti (regeneruje pomalu / z killů)
- **Antigen-vzorky** — měna pro odemykání cílených upgradů v lymfatické uzlině
- **Cytokinové signály** — combo metr; při plném umožní "burst" odpověď

---

## 5. Nepřátelé — patogeny (věrné counter-systémy)

Klíč k edukační hodnotě: **každý typ patogenu má reálnou slabinu**, a hráč se ji učí
metodou pokus-omyl, přesně jako reálná imunita.

| Patogen | Chování | Slabina (counter) | Edukační pointa |
|---------|---------|-------------------|-----------------|
| **Extracelulární bakterie** | rychlé swarmy | fagocytóza + komplement + Th17/neutrofily | inntate stačí, pokud reaguješ rychle |
| **Intracelulární virus** | schová se v host-buňce | NK / cytotoxická T (CD8) + interferon | nejde "zastřelit" zvenčí |
| **Houby (fungi)** | tanky, tvoří biofilm | Th17 + neutrofily, sustained dmg | persistence > burst |
| **Parazit (helmint)** | velký HP-sponge | eozinofily + IgE (Th2) | jiný celý systém odpovědi |
| **Rezistentní superbug** (boss) | mutuje pod tlakem | nutná kombinace + paměť | proč antibiotická rezistence vzniká |

**Mutační mechanika (antigenní drift):** v populaci, na kterou tlačíš stále stejným
counterem, **převládne pre-existující rezistentní menšina** → stejný build dlouhodobě slábne.
To tlačí hráče k diverzifikaci odpovědi a je to reálná evoluce v přímém přenosu. Boss-superbug
tohle zneužívá: pokud ho biješ pořád stejně, jeho rezistentní varianta se vyselektuje.

> **Revize (viz `REVIEW` §A2 #1):** rámuj jako **selekci náhodných pre-existujících variant**
> (Luria–Delbrück), NE „nepřítel se přizpůsobí, protože ho biješ". Mutation Reveal formulace:
> „rezistentní menšina tu byla už předtím — tvůj tlak jí dal převahu." Nezakódovat lamarckovský
> model („organismus získá vlastnost, protože ji potřebuje").

---

## 6. Build systém — Th polarizace jako archetypy

Reálné větvení T-helper odpovědi = přirozené build-archetypy s tradeoffy. Volíš v
lymfatické uzlině (patro 2) a posiluješ během runu.

- **Th1** → intracelulární (viry, intracel. bakterie). Aktivuje makrofágy, IFN-γ,
  cytotoxicitu. *Build: vysoký single-target, anti-virus, ignoruje kamufláž.*
- **Th2** → paraziti, slizniční. Eozinofily, žírné buňky, IgE. *Build: anti-tank,
  DoT, control. Slabý proti rychlým swarmům.*
- **Th17** → extracelulární bakterie/houby na sliznicích. Rekrutuje neutrofily,
  IL-17. *Build: swarm-clear, sustained AoE, biofilm-breaker.*
- **Treg** → regulace (ne přímý damage). Tlumí zánět. *Support/defensive build:
  snižuje self-damage, prodlužuje run, umožní agresivní stacking bez cytokinové bouře.*

Synergie (à la Isaac): kombinace receptorů + protilátkových tříd (IgM→IgG class
switch jako "upgrade na lepší verzi") + cytokinů vytvářejí emergentní buildy.

---

## 7. Risk/reward — autoimunita & cytokinová bouře

Nejelegantnější edukační mechanika celé hry:

- Každý zánětlivý/agresivní upgrade přidává **Inflammation stack**.
- Vysoký inflammation = vyšší damage, **ALE** začne ti **tikat self-damage do
  hostitelské tkáně** (**imunopatologie**) a hrozí **cytokinová bouře** (instant-krizový stav).
- **Treg buňky / IL-10 / kortizol upgrade** = jediný způsob, jak inflammation snížit.

> **Revize (viz `REVIEW` §A2 #7):** self-damage z nadměrného zánětu je **imunopatologie**
> (kolaterální škoda), ne autoimunita. **Autoimunitu** (ztráta self-tolerance, útok na vlastní
> antigeny) rezervovat pro distinktní event — **molekulární mimikry** po boji s patogenem
> sdílejícím epitopy se self (revmatická horečka po Strep, GBS po *Campylobacter*). Přidá celý
> správný koncept místo rozmazání jednoho. Vztah inflammation↔fever viz `03-PLAN` §1.

Tohle učí reálnou pravdu: imunitní odpověď, která je příliš silná, zabije hostitele
stejně jistě jako patogen (sepse, těžký COVID, autoimunitní choroby). Hráč musí
balancovat ofenzivu proti vlastnímu přežití.

---

## 8. Meta-progrese — imunologická paměť (= očkování)

Po smrti/clearnutí runu:

1. **Paměťové B/T buňky přežijí** → permanentní odemčení (nové startovní buňky,
   receptory v poolu, vyšší base staty).
2. **"Vakcinace"** — před runem si vybereš, proti jakému patogenu jsi imunizovaný
   (pre-run buff na základě toho, co tě dřív zabilo). Doslova mechanika očkování.
3. **Thymus** (meta-hub) — "trénink" nových startovních loadoutů. Negativní selekce
   = odstraníš nevyhovující buňky (build crafting mezi runy).

> Návrhový princip: smrt nikdy není čistá ztráta. Vždy si odnášíš paměť → příští
> infekce stejným patogenem je snazší. To je nejvěrnější a zároveň nejlepší
> roguelike meta-loop, jaký imunologie nabízí.

---

## 9. Technická architektura — Flutter + Flame

### 9.1 Vrstvy

```
┌──────────────────────────────────────────────┐
│  Flutter widgets (UI shell)                    │
│  • menu, meta-progrese, lymph-node obchod      │
│  • HUD overlay přes GameWidget                  │
│  • state: Riverpod 2.x                          │
├──────────────────────────────────────────────┤
│  Flame (FlameGame) — simulace runu             │
│  • World + CameraComponent (top-down)          │
│  • PlayerComponent + Controller (twin-stick)   │
│  • Enemy components + spawner (object pooling)  │
│  • Collision (Flame HitboxComponent)           │
│  • RoomManager / FloorGraph (procedurální)     │
├──────────────────────────────────────────────┤
│  Doménová logika (čistý Dart, testovatelná)    │
│  • combat resolver, build/synergy engine       │
│  • mutation/adaptation systém                  │
│  • RNG seed management (deterministické runy)  │
├──────────────────────────────────────────────┤
│  Persistence: Drift / SQLite                   │
│  • meta-progrese, odemčení, statistiky         │
│  • run seed historie (sdílení seedů)           │
└──────────────────────────────────────────────┘
```

### 9.2 Klíčová designová rozhodnutí

- **Odděl simulaci od UI.** Flame má vlastní game loop; Riverpod drží meta/menu stav.
  Mezi nimi tenké rozhraní (events nahoru, commands dolů). Combat logiku drž v čistém
  Dartu mimo Flame komponenty → jednotkové testy bez renderu.
- **Object pooling pro swarmy.** Bakterie přijdou po desítkách. Recykluj komponenty,
  nealokuj per-spawn. Hlavní výkonnostní riziko na mobilu.
- **Steering / flow-field místo per-entity A\*** pro davy. Swarm AI = boids/steering,
  bossové dostanou vlastní state machine / behavior tree.
- **Procedurální generace:** graf místností (uzly = místnosti, hrany = dveře),
  prefab room templates s spawn-pointy. Začni s ručně designovanými prefaby +
  graf-layout RNG; čistě procedurální geometrii nech až po MVP.
- **Deterministické runy:** jeden seed → reprodukovatelný run. Umožní sdílení seedů
  a debug. Drž veškerou RNG v jednom seedovaném zdroji.
- **Datová definice obsahu:** patogeny, upgrady, místnosti jako data (JSON/Dart maps),
  ne hardcode. Snazší balancování a rozšiřování — a sedí to tvému stylu (data-driven).

### 9.3 Balíčky (výchozí sázka)

`flame`, `flame_audio`, `flutter_riverpod`, `drift` + `sqlite3`, `freezed`
(immutable doménové modely), `collection`. Animace: spritesheet přes Flame
`SpriteAnimationComponent` (Aseprite export).

---

## 10. MVP scope — co stavět nejdřív

Cíl MVP: **jeden hratelný, zábavný "gameplay vertical slice"**, ne celá hra.

**MVP (vertical slice):**
- 1 hratelná buňka (Makrofág — nejuniverzálnější)
- 1 patro (Epitel) s ~6–8 procedurálně poskládanými místnostmi + 1 boss
- 2 typy nepřátel (extracel. bakterie swarm + 1 elite)
- 3–4 sbíratelné upgrady s aspoň jednou viditelnou synergií
- Core combat loop: pohyb, melee fagocytóza, 1 ranged, dash
- 1 risk mechanika: inflammation stack + self-damage
- Smrt → restart (zatím bez meta)

**Co výslovně NEdělat v MVP:** plnou Th-polarizaci, všech 5 pater, meta-progresi,
mutační systém, všechny buňky. Přidávej až když core loop *baví bez nich*.

---

## 11. Fázový roadmap

| Fáze | Cíl | Výstup |
|------|-----|--------|
| **0** | Tech setup | Flame projekt, player movement, kamera, kolize |
| **1** | Combat core | melee + ranged + dash + 1 nepřítel, "game feel" |
| **2** | Room systém | graf místností, dveře, spawn, 1 boss → MVP slice |
| **3** | Build systém | upgrady, synergie, inflammation risk |
| **4** | Obsah | další patra, nepřátelé, buňky, Th polarizace |
| **5** | Meta-progrese | paměťové buňky, vakcinace, thymus, Drift persistence |
| **6** | Mutace & balance | adaptační systém, tuning, edukační tooltips |
| **7** | Polish | audio, juice, onboarding, codex (encyklopedie patogenů) |

> **Codex jako edukační vrstva:** každý poražený patogen / odemčená buňka přidá
> záznam do in-game encyklopedie s reálným popisem. Tady leží edukační hodnota,
> aniž by rušila hratelnost — volitelná hloubka pro zvědavé.

> **Akční milníky Fází 3–7** jsou rozepsané v `Prompts/03-PLAN-phase-3-7.md` (formát
> milník / obsah / DoD, včetně wiring úkolů a biologických korekcí z `REVIEW`).

---

## 11.5 Další kola a varianty (dlouhodobý výhled)

Nápady nad rámec základní kampaně. Detaily a learning objectives viz `03-PLAN` §8.

**Nové biomy:** střevo (mikrobiom / IgA / Th17, „nestřílej komenzály"), CNS (imunitní
privilegium, hematoencefalická bariéra), kůže/rána (bariéra, koagulace, hojení), placenta
(mateřsko-fetální tolerance, pasivní imunita).

**Herní módy:**
- **⭐ „Hraj za patogen"** (asymetrický) — sázíš na náhodné mutace *naslepo*, pak tě selekce
  vybere; HGT, intracelulární úkryt, MHC downregulace, biofilm, drift. Zážitkově opraví
  lamarckovský problém (`REVIEW` §A2 #1). Co-op/versus: innate+adaptive hráč vs. patogen-hráč.
- **Scénáře reálných chorob** (kampaň): chřipka (drift vs. shift), TBC (granulom, latence),
  **HIV** (napadá tvé CD4 helpery → vypne strom upgradů), sepse, autoimunita (invertovaný cíl:
  neútoč na self), alergie/astma (Th2/IgE na neškodný antigen), nádorová imunoeditace
  (MHC-loss, PD-L1 checkpoint + immunoterapie), transplantace/rejekce.
- **Imunodeficience / komorbidity** jako obtížnostní modifikátory („uč se ztrátou"): SCID,
  neutropenie, deficit komplementu, asplenie, imunosenescence, diabetes, kortizol, malnutrice.
- **Vakcinační varianty**: živá / mRNA / subjednotková / pasivní (monoklonály) + boostery /
  wanning immunity. Rozlišit infekcí získanou vs. vakcinací získanou imunitu.
- **Daily seed jako klinický případ** (diagnostikuj z chování, správně counteruj) + leaderboard.
- **Sandbox / textbook / classroom mód** — bez fail-state, scaffolded výzvy, sdílené seedy pro
  třídu, kvíz-gated Codex, CZ/EN bilingválnost jako a11y plus.

**Meta-kampaň — antibiotic stewardship na populační úrovni:** overworld pacientů; agresivní
jednonástrojové cleary zvyšují *regionální* rezistenci → pozdní hra = sebou zaviněná AMR krize
(resistance index). Povyšuje tezi z imunologie do **epidemiologie**.

**Rozšíření boss-rosteru:** Mycobacterium, Plasmodium, Salmonella (přežívá v makrofágu),
Streptococcus (evaze komplementu + postinfekční autoimunita), Candida, velký helmint.

---

## 12. Otevřené otázky — rozhodnutí (revize 2026-07)

> Původní otevřené otázky s doporučeným rozhodnutím (viz `COMBAT`/`UX` pro kontext).

1. **Časový model neutrofilu** — má krátká životnost být tvrdý limit, nebo jen debuff?
   → **Doporučení: měkký časovač** (soft limit) + NETóza jako suicidální cast (viz `REVIEW`
   §A2 #4). Tvrdý instant-limit frustruje; časovač + dobrovolná NETóza drží high-risk feel
   a je biologicky přesný (neutrofil žije hodiny–dny).
2. **Twin-stick vs. dash-aim** — → **Doporučení: auto-aim primary + drag-to-aim special**
   (`COMBAT §3`, implementováno). Řeší twin-stick problém na mobilu, drží skill ceiling.
3. **Délka runu** — → **Doporučení: 15–25 min** clear (mobilní sweet spot), místnost 30–60 s.
4. **Cílová platforma** — → **Doporučení: mobil-first (touch)**, desktop paritně (WASD+myš).
   `01-PLAN` iteruje na webu/desktopu kvůli hot-reloadu, ale ovládání navrhovat pro touch.
