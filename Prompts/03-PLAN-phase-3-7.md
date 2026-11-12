# IMMUNORUN — Fáze 3–7 Implementation Plan

> Navazuje na `01-PLAN-phase-0-2.md` (Fáze 0–2 = hratelný vertical slice, hotový).
> Stejný formát: milník / obsah / Definition of Done. Companion k `PLAN` / `SYSTEMS` / `COMBAT` / `UX` / `REVIEW`.
> Zahrnuje **wiring úkoly** (rozpory plán↔kód z `REVIEW` §A3) a **biologické korekce** z `REVIEW` §A2.

---

## 0. Východisko — co po Fázi 2 existuje a co chybí

**Hotovo (F0–2):** pohyb + dash/i-frames, auto-aim primary, ATP special, swarmer (cocci) + object pool, `FeverController` + teploměr HUD, wave controller, room graph, mini-boss (2 fáze, fever-trigger), particles, hit-stop, restart loop.

**Klíčové mezery k dořešení dřív, než přidáme obsah** (viz `REVIEW` §A3):
- Živý boj **obchází** `CombatResolver` → fever buffy se neaplikují.
- `status_effects.dart` = **mrtvý kód**.
- Makrofág **střílí** místo fagocytózy.
- Febrilní duality (debuff patogenů + normotermická penalta) chybí.
- Boss bez patogenní identity.

> **Princip:** než přidáme leukocyty/biomy (F4+), zapojíme existující, ale mrtvé systémy (F3). Jinak stavíme obsah na nefunkčním jádru.

---

## 1. Reconciliace: Horečka vs. Zánět (rozhodnutí pro celý zbytek hry)

Rozpor: `PLAN §7` dělá risk mechanikou **inflammation stack + autoimunitu**; `SYSTEMS` povyšuje **horečku**; `UX §4` HUD ukazuje **oba** metry; kód má jen fever.

**Rozhodnutí — dva odlišné, ale propojené metry:**

| Metr | Rozsah | Zdroj | Risk | Reward | Snižuje |
|------|--------|-------|------|--------|---------|
| **Horečka (fever)** | *systémový* teplotní stav | aktivita patogenů, zásahy, zánětlivé ability | death spiral > 41,5 °C | febrilní buffy (atk speed, dmg, HSP) | clear místnosti, Treg, čas |
| **Inflammation** | *lokální / build-driven* stack | zánětlivé upgrady, agresivní styl | **imunopatologie** (self-damage do tkáně) + tlačí fever nahoru | vyšší dmg | jen Treg / IL-10 / kortizol |

Lekce se **nepřekrývají**: fever = systémové tepelné riziko; inflammation = poškození vlastní tkáně a vstup do cytokinové bouře. (Pozn.: „autoimunita" jako event = molekulární mimikry, oddělená od inflammation self-damage — viz `REVIEW` §A2 #7.)

**Rozhodnutí implementace:** inflammation přidat jako **druhý metr ve Fázi 3** (druhý HUD prvek pod teploměrem, dle `UX §4` mocku).

---

## 2. FÁZE 3 — Build systém, risk & zapojení mrtvých systémů

Cíl: fungující build loop + risk mechanika; zapojit vše, co je definované, ale nevyužité.

| Milník | Obsah | Definition of Done |
|--------|-------|--------------------|
| M3.1 | **Zapojit `CombatResolver` do živého boje** — `Projectile`/melee hit jde přes resolver; fever atk-speed/dmg/crit se reálně aplikují. | Zásah ve febrilní zóně měřitelně silnější než v normotermii. |
| M3.2 | **Febrilní duality** — patogeni ve febrilní zóně dostávají debuff (pomalejší/slabší); mírná **penalta v normotermii**. (`REVIEW` §A3 #2) | Ve febrilní zóně je vidět, že horečka škodí *i* nepřátelům. |
| M3.3 | **Status efekty** — implementovat aplikaci + tick + render `opsonized` (+dmg taken), `inflamed` (DoT + lokální fever), `trapped` (imobilizace). (`REVIEW` §A3 #3) | Zásah označí nepřítele viditelným statusem, který má efekt a doběhne. |
| M3.4 | **Fagocytóza (makrofág)** — přepsat primary z ranged na **melee „sežrání" slabého nepřítele → heal + resource**. (`REVIEW` §A2 #2) | Makrofág léčí jen zblízka pohlcením, ne střelbou. |
| M3.5 | **Inflammation metr + imunopatologie** — druhý metr; vysoký stack = self-damage; Treg/IL-10 ho snižuje. (§1) | Agresivní build tiká self-damage; Treg ho vypne. |
| M3.6 | **Upgrady + synergie** — 4–6 sbíratelných upgradů, min. 1 viditelná synergie (dle `PLAN §6`). | Sbíráš upgrady, které mění build; jedna kombinace je emergentní. |
| M3.7 | **Rename damage type** `kinetic → phagocytic/mechanical`. (`REVIEW` §A2 #10) | `domain/damage.dart` bez negeneričního biologicky-chybného typu. |

**Po F3 = build loop baví a jádro je konzistentní.**

---

## 3. FÁZE 4 — Obsah (leukocyty, patogeny, biomy, Th)

Cíl: rozšířit arzenál a bestiář; první nové biomy.

| Milník | Obsah | Definition of Done |
|--------|-------|--------------------|
| M4.1 | **Enemy archetypy** — zapojit `tank` (houba/biofilm), `shooter` (toxin-spitter), přidat `burrower` (intracel. virus, „cloaked", jen NK/CD8 ho vidí). | 3+ archetypy s odlišnou combat texturou. |
| M4.2 | **Neutrofil** — glass-cannon; ROS burst + NETs; „stojí život" navázat na **NETózu / časovač životnosti**, ne degranulaci. (`REVIEW` §A2 #4) | Druhá hratelná buňka s vlastní mechanikou. |
| M4.3 | **NK + CD8** — missing-self / low-MHC lock; counter k `burrower`/cloaked. (`REVIEW` §A1) | Cloaked nepřítele sundá jen NK/CD8. |
| M4.4 | **B-buňka** — protilátkové projektily, opsonizace, afinní maturace (ramp-up); class-switch jako **jednosměrný commit** s cenou. (`REVIEW` §A2 #5) | Kalibrace sílí; drift ji resetuje; switch nejde vzít zpět. |
| M4.5 | **Th polarizace** (Th1/Th2/Th17/Treg) v lymfatické uzlině; přidat **Tfh** k B-buňce/germinálním centrům. | Volba archetypu tvaruje zbytek runu. |
| M4.6 | **2.–3. biom** — krevní řečiště, cílový orgán; **boss identity**: S. aureus (koaguláza, biofilm, komplement-rezistence explicitně; MRSA shift jako *odhalení* pre-existující rezistence, `REVIEW` §A2 #1/#6/#8). | Boss má jméno, biologii a čitelný counter. |

---

## 4. FÁZE 5 — Meta-progrese (paměť / vakcinace)

| Milník | Obsah | Definition of Done |
|--------|-------|--------------------|
| M5.1 | **Persistence (Drift/SQLite)** — `Map<SpeciesId, ResistanceProfile>`, unlocky, statistiky. | Stav přežije restart appky. |
| M5.2 | **Paměťové buňky** (Mirror-of-Night styl) — permanentní unlocky/staty. | Smrt → trvalý zisk. |
| M5.3 | **Vakcinační stanice** — pre-run imunizace proti 1 linii; rozlišit **infekcí získanou** (dnešní death-loop) vs. **vakcinaci** (paměť zdarma). (`REVIEW` §C) | Před runem volíš imunizaci; UI vysvětlí rozdíl. |
| M5.4 | **Thymus hub** — výběr leukocytu + aspektu; negativní selekce = build crafting. | Prozkoumatelný hub místo menu. |
| M5.5 | **Mutation Reveal obrazovka** — po smrti; formulace **„rezistentní menšina už existovala → tvůj tlak jí dal převahu"** (NE „patogen se naučil"). (`REVIEW` §A2 #1) | Smrt = lekce s konkrétní radou; anti-lamarckovská formulace. |

---

## 5. FÁZE 6 — Mutace & balance

| Milník | Obsah | Definition of Done |
|--------|-------|--------------------|
| M6.1 | **`MutationEngine.applySelection(killStats, peakFever)`** — selekce **obohatí pre-existující** rezistentní varianty (ne „udělí" trait); traity data-driven. (`REVIEW` §A2 #1) | Po runu se rezistentní podíl posune dle tlaku, ne dle „potřeby". |
| M6.2 | **Horizontální přenos genů** — plazmidy / biofilm jako šíření rezistence mezi liniemi. (`REVIEW` §A2 #1) | Rezistence se šíří i bez přímé selekce. |
| M6.3 | **Apex Strain** — finální boss procedurálně z hráčovy `ResistanceProfile`; determinismus přes run seed. | Každý hráč má jiného finálního bosse. |
| M6.4 | **Balance & edukační tooltipy** — tuning, stropy mutací, kontextové vysvětlivky. | Hra je vyladěná a vysvětluje *proč*. |

---

## 6. FÁZE 7 — Polish & Codex

| Milník | Obsah | Definition of Done |
|--------|-------|--------------------|
| M7.1 | **Audio** — tep se zrychluje s horečkou (diegetický metr), squelch fagocytózy, killy. | Horečku slyšíš, ne jen vidíš. |
| M7.2 | **Onboarding** — dle `UX §11`, učení akcí, ne textem. | Nováček zvládne prvních 5 min bez textových zdí. |
| M7.3 | **Codex** — encyklopedie s **reálnými popisy** + korekce z `REVIEW` (fever vs. hyperthermie, MAC limity, class-switch nevratnost, náhodná-variace-pak-selekce). | Volitelná edukační hloubka, nese opravené biologické claimy. |

---

## 7. Chybějící biologie k doplnění (edukační obohacení)

> Priorita dle poměru edukační hodnota / cena. Detaily viz `REVIEW`.

**Tier 1 (nejvyšší hodnota, nízké riziko):**
- **⭐ Dendritická buňka jako most innate→adaptive** — DC pobere antigen v tkáni, migruje do uzliny, aktivuje naivní T-buňky; její doručení antigenu **odemyká** adaptivní upgrady. Spojuje patro 1 (epitel) s patrem 2 (uzlina). Nejcennější přidání.
- **Interferon (typ I)** — profylaktická „harden nearby cells" schopnost na intracel.-virus patře.
- **PAMPs / PRRs** — „receptor" pickupy = zisk PRR (TLR/NLR); kontrast innate (germline vzory) vs. adaptive (somatická specificita).
- **Self / non-self (friendly fire)** — host/self buňky v aréně; útok = imunopatologie. Napojí inflammation risk + thymus negativní selekci.

**Tier 2:** innate↔adaptive timing (adaptivní zbraně nabíhají); slizniční imunita / IgA / mikrobiom (nestřílej komenzály); cross-reaktivita / original antigenic sin (dvousečná vakcinace u chřipky); inflammation vs. fever (lokální vs. systémové).

**Tier 3 (codex-hloubka):** komplementové dráhy, chemotaxe/extravazace, efektorové funkce protilátek (ADCC/Fc), nutriční imunita.

---

## 8. Další kola a varianty (dlouhodobý výhled)

Kompletně rozepsané v `IMMUNE_ROGUELIKE_PLAN.md` §11 („Další kola a varianty"). Shrnutí:

- **Nové biomy:** střevo (mikrobiom/IgA), CNS (imunitní privilegium), kůže/rána, placenta (pasivní imunita).
- **⭐ „Hraj za patogen"** (asymetrický) — sázíš na náhodné mutace naslepo → zážitkově opraví lamarckovský problém; co-op/versus.
- **Scénáře reálných chorob:** chřipka (drift vs. shift), TBC, HIV (napadá tvé CD4 helpery), sepse, autoimunita, alergie, nádorová imunoeditace, transplantace.
- **Imunodeficience / komorbidity** jako obtížnostní modifikátory („uč se ztrátou").
- **Vakcinační varianty** (živá/mRNA/subjednotková/pasivní) + boostery / wanning immunity.
- **Daily seed jako klinický případ**; **sandbox / textbook / classroom** mód.
- **Meta-kampaň stewardship** na populační úrovni (AMR krize; resistance index) — povyšuje tezi z imunologie do epidemiologie.
- **Boss-roster:** Mycobacterium, Plasmodium, Salmonella, Streptococcus, Candida, helmint.

---

## 9. Doporučené pořadí

1. **M3.1–M3.4** (zapojení mrtvých systémů + fagocytóza) — nejdřív, jinak stavíme na nefunkčním jádru.
2. **M3.5–M3.6** (inflammation + upgrady) — dokončí risk/build loop.
3. **M4.1–M4.4** (archetypy + 2–3 leukocyty) — combat diverzita.
4. **M4.5–M4.6** (Th + biomy + boss identita) — první „plná" patra.
5. **F5** (meta) — až core loop baví bez ní.
6. **F6–F7** (mutace, polish, Codex) — dlouhá ocasní práce.

> Vždy commituj spustitelný stav. Každý milník = hratelný build.
