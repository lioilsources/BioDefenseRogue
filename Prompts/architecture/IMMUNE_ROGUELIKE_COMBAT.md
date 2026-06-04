# IMMUNE ROGUELIKE — Combat System

> Companion k `PLAN` / `SYSTEMS` / `UX`
> Téma: rychlý, dash-centric top-down kombat à la Hades, řízený horečkou

---

## 1. Perspektiva — rozhodnutí: 2D TOP-DOWN (mikroskop)

**Verdikt: 2D top-down, NE izometrie.** S rámováním „pohled mikroskopem" +
paralaxní hloubkou.

### Srovnání
| | 2D top-down | Izometrie (Hades) | Side-scroller (Dead Cells) |
|--|-------------|-------------------|----------------------------|
| Flame náročnost | **nízká** (nativní 2D) | vysoká (depth sort, fake-Z) | střední (gravitace, platformy) |
| Art cost (solo) | **nejnižší** | vysoký (8-dir / 3D render) | střední |
| Kolize | **triviální** | fiklavá iso matematika | OK |
| Čitelnost telegrafů | **nejlepší** (vidíš celou arénu) | horší (hloubková nejednoznačnost) | OK |
| Mobil real-estate | **dobré** | špatné (diagonála) | dobré |
| Fit tématu | **dokonalý** (mikroskop = pohled shora) | slabý | špatný (buňky neplavou v gravitaci) |
| Fever vinětace UX | **plně funguje** | částečně blokováno | OK |

### „Jiný nápad" — hloubka bez ceny iso
Zůstaň top-down, ale přidej **paralaxní depth-of-field vrstvy**:
- **Foreground:** rozmazaná tkáň/membrána, lehce přejíždí (parallax).
- **Gameplay vrstva:** ostrá, kde se bojuje.
- **Background:** rozostřené buňky mimo fokus, pomalý drift.
- **Fluid motion:** vše se jemně vznáší (buňky plavou v plazmě), ne statické.

Výsledek: prémiový, živý pocit + posílená mikroskopová diegeze za zlomek nákladů
izometrie. Tohle je sweet spot pro solo Flame projekt.

---

## 2. Combat pilíře

1. **Pozicování > míření.** Hlavní skill je pohyb a dash, ne přesné cílení.
2. **Dash je defenzivní jádro.** I-frames, repozice, „risk přiblížení" (Hades feel).
3. **Agrese se odměňuje.** Heal jen přes fagocytózu (lifesteal) → tlak dovnitř, ne kemp.
4. **Horečka je vetkaná do každé výměny.** Není to oddělený metr, je to combat zdroj.
5. **Honest telegrafy.** Smrt = chyba hráče. Každý velký útok má čitelný wind-up.
6. **Juice.** Hit-stop, knockback, particle burst — bez šťávy edukace neudrží pozornost.

---

## 3. Combat verby (5 vstupů)

| Verb | Vstup (mobil) | Funkce |
|------|---------------|--------|
| **Move** | levý stick | pozicování, 360° |
| **Primary** | auto (auto-aim na nejbližší) | sustained základ, levný |
| **Special** | drag-to-aim button | high-impact, stojí ATP, manuální cíl |
| **Cast** | tap button | utilita/ability (NET, antigen mark, scan…) |
| **Dash** | tap pravá půlka / button | i-frames, repozice, jádro defenzivy |

> Auto-aim primary řeší twin-stick problém na telefonu; manuální special drží skill
> ceiling. Pohyb zůstává plně v rukou hráče = veškerá obtížnost je v pozici, ne v míření.

---

## 4. Damage & defense model

- **Host HP** = sdílený život pacienta. Zásah ubere HP **a zvedne horečku** (dvojí trest).
- **Žádný mid-combat regen** kromě **fagocytózy** (Makrofág/Neutrofil sežere slabého →
  malý heal). → ekonomika agrese: chceš-li žít, musíš zabíjet zblízka.
- **Dash i-frames:** krátké okno nezranitelnosti; cooldown krátký, řetězení omezené
  staminou/ATP, aby nešel spamovat.
- **Knockback** škáluje s dmg; těžké hity mají hit-stop (krátké zamrznutí = pocit váhy).
- **Death = fever > 41,5 °C** sustained, NEBO host HP na nule. Dva fail vektory, hráč
  balancuje oba.

---

## 5. Fever-combat smyčka (unikátní vrstva)

Tohle odlišuje náš kombat od každého jiného top-down roguelike:

```
agresivní akce / utržený zásah / aktivita patogenů
        │  zvyšují
        ▼
   🌡 HOREČKA stoupá
        │
        ├── febrilní zóna (38–40°C) → COMBAT BUFFY (atk speed, dmg, HSP)
        │        „flow state" — sem se chceš dostat a držet se
        │
        └── hyperpyrexie (40+) → host HP tik, riziko seizure, mutační tlak
                 │
            dash / clear room / Treg ability
                 │ odvětrá teplo
                 ▼
            zpět do sweet spotu
```

Hráč **„jezdí" na horečce**: spike kvůli síle během těžké výměny, pak repozice/clear
na zchlazení. Vyčištění místnosti = primární „vent". Tohle nahrazuje many/stamину metr
z jiných her — ale na rozdíl od many tě horečka může zabít, takže je to risk/reward
v reálném čase, ne jen budget.

---

## 6. Cytokine momentum (combo systém)

- **Cytokine metr** roste z **rozmanitosti akcí** (primary → special → cast → kill),
  ne ze spamu jednoho tlačítka. Spam = diminishing returns.
- Plný metr → **burst odpověď** (silná aktivace na pár sekund / jednorázový nuke).
- Diegeze: imunitní signalizace je kaskáda různých cytokinů — monokultura nefunguje,
  potřebuješ orchestraci. Mechanika učí, že imunita = koordinace, ne jeden nástroj.

---

## 7. Enemy combat archetypy (combat textura)

| Archetyp | Patogen | Combat role | Nutí hráče |
|----------|---------|-------------|------------|
| **Swarmer** | bakterie cocci | hodně slabých, melee | pozicovat, AoE/clear |
| **Spitter** | toxin-producent | ranged DoT | pohybovat se, krýt se |
| **Tank** | houba/biofilm | soak, blokuje prostor | sustained dmg, control |
| **Burrower/stealth** | intracelulární virus | schová se v host-buňce | NK/CD8, detekce |
| **Heavy/telegraf** | velký patogen | jeden velký wind-up útok | timing dash, mini-boss feel |

Mix archetypů v místnosti = combat puzzle. Burrower navíc trestá „střílení naslepo" —
musíš zasáhnout správný cíl (učí MHC/missing-self).

---

## 8. Status efekty (biologicky tematické)

| Status | Biologie | Efekt |
|--------|----------|-------|
| **Opsonized** | protilátka/komplement označí | +dmg taken, viditelnější |
| **Inflamed** | lokální zánět | DoT + lokálně zvedá horečku |
| **Trapped** | NET | imobilizace na čas |
| **Lysed** | perforin/MAC | execute stav pod prahem HP |
| **Cloaked** | MHC downregulace (virus) | neviditelný pro běžné cíle, jen NK ho vidí |

---

## 9. Game feel / juice checklist

- **Hit-stop** na těžké hity (2–4 frame freeze).
- **Squash & stretch** na fagocytóze (gulp).
- **Particle jazyk per damage type:** ROS = oranžový burst, komplement = praskání
  membrány, protilátka = glyf značky, histamin = vlna.
- **Screen shake** úsporně (jen bursty/boss fáze), ať fever-shake zůstane čitelný.
- **Audio:** tep zrychluje s horečkou (diegetický metr), squelch fagocytózy, „pop" killů.
- **Time-to-kill:** swarm trash umírá rychle (1–2 hity), elity dávají odpor, bossové
  jsou maraton. Tempo místnosti 30–60 s.

---

## 10. Flame implementace

- **Kolize:** Flame `HitboxComponent` (circle/rect). Top-down = žádné fake-Z, čisté 2D.
- **Combat resolver:** čistý Dart mimo komponenty — `resolveHit(attacker, target,
  feverState)` vrací dmg + statusy. Plně unit-testovatelné bez renderu.
- **Auto-aim primary:** dotaz na nejbližší cíl v dosahu (spatial query / jednoduchý
  broad-phase nad poolovanými nepřáteli).
- **Object pooling:** swarmy recyklují komponenty (hlavní perf riziko na mobilu).
- **Swarm AI:** boids/steering (ne per-entity A*). Heavy/boss = behavior tree / FSM.
- **Dash i-frames:** stav na `PlayerComponent` (`invulnerableUntil`), resolver ho ctí.
- **Fever hook:** resolver bere `FeverController` snapshot → aplikuje buffy/penalizace
  jako modifikátory, ne hardcode. Vše data-driven (dmg, statusy, prahy v konfigu).
- **Particle/juice:** Flame `ParticleSystemComponent` + krátké tween efekty; hit-stop
  přes lokální time-scale, ne globální pauzu (boss telegrafy musí běžet dál).
```
