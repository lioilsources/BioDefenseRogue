# IMMUNE ROGUELIKE — UX & Gameplay Flow

> Companion k `IMMUNE_ROGUELIKE_PLAN.md` a `IMMUNE_ROGUELIKE_SYSTEMS.md`
> Cíl: jak se hra **hraje a cítí** — obrazovka po obrazovce, minuta po minutě.
> Předpoklad: **mobil-first** (touch), s poznámkami pro desktop.

---

## 1. Celkový screen flow

```
[TITLE]
   │
   ▼
[HUB — Kostní dřeň / Thymus]  ◄────────────────────────┐
   │  • Mirror = Paměťové buňky (meta unlocky)          │
   │  • Thymus = výběr leukocytu + aspektu              │
   │  • Vakcinační stanice = pre-run imunita            │
   │  • Teploměr = startovní horečka (obtížnost)        │
   │  • Codex = encyklopedie patogenů                   │
   │  • DVEŘE = start runu                              │
   ▼                                                    │
[RUN SETUP] (rychlé potvrzení loadoutu)                 │
   │                                                    │
   ▼                                                    │
┌─────────── IN-RUN (Flame + HUD overlay) ──────────┐   │
│  místnost → boj → odměna → výběr dveří → ...      │   │
│  ...→ LYMFATICKÁ UZLINA (mid-run hub)→ ...        │   │
│  ...→ BOSS biomu → další biom → ... → FINÁLE      │   │
└───────────────────┬───────────────────────────────┘   │
                     │                                    │
          smrt  ◄────┴────►  clear                        │
            │                  │                          │
            ▼                  ▼                          │
   [MUTATION REVEAL]    [VICTORY + summary]               │
   „patogen se naučil…"        │                          │
            └──────── meta odměny ─────────────────────────┘
```

Technicky: Hub a menu = **Flutter widgety** (Riverpod). In-run = **`GameWidget`**
s Flame; HUD a pauza = Flame **overlays** (Flutter widgety nad canvasem).

---

## 2. HUB UX (mezi runy) — „House of Hades"

Prozkoumatelná místnost (kostní dřeň), ne jen menu. Hráč chodí mezi stanicemi:

- **Mirror of Night → „Genová banka paměti":** utrácíš trvalou měnu (memory tokens)
  za permanentní staty/unlocky. Dvě větve per upgrade (toggle), jako v Hades.
- **Thymus → výběr zbraně:** 6 leukocytů jako stojany; vybereš aktivní + aspekt.
  Zamčené jsou zašedlé s podmínkou unlocku.
- **Vakcinační stanice:** vybereš 1 patogenní linii, proti které startuješ imunizovaný
  (typicky ta, co tě zabila). Diegeticky: injekce.
- **Teploměr u dveří:** táhneš startovní horečku (obtížnost). Vyšší = víc rizika i loot.
  Vizuálně se mění barva celé místnosti (chladná → horká).
- **Codex:** sbírka odemčená hraním. Edukační hloubka stranou od flow.
- **Dveře:** start. Krátká animace nasazení do tkáně.

> Pravidlo: hub je **rychlý**. Veterán proletí za 20 s, nováček prozkoumává. Žádná
> stanice nesmí blokovat start.

---

## 3. RUN SETUP (potvrzovací vrstva)

Jedna lehká obrazovka shrnující volby (leukocyt + aspekt, vakcinace, startovní
horečka) + tlačítko „Nasadit". Skip-able pro veterány (drž → instant start).

---

## 4. IN-RUN HUD (mobil-first layout)

```
┌───────────────────────────────────────────────────────────┐
│ ♥♥♥♥♡  HOST HP            [minimap: graf místností]  ⚙ pauza │
│ 🌡 ───────████──────  39.1°C   ← TEPLOMĚR (hero element)    │
│         ↑ febrilní sweet spot (zelená zóna)                 │
│                                                             │
│                                                             │
│                  ⟦  HERNÍ PLOCHA (Flame)  ⟧                 │
│                                                             │
│                                                             │
│  ⚡ATP ▮▮▮▮▯   🧬antigen ×7   🔥inflammation ▮▮▯           │
│                                                             │
│ [◉ move]                          [primary] [special][cast] │
│  virtuální stick                   auto      drag    button │
└───────────────────────────────────────────────────────────┘
```

**Priorita pozornosti (shora):**
1. **Teploměr** — největší, vždy viditelný, barevně zónovaný. Hero prvek (dědic
   Bio-Defense teploty).
2. **Host HP** — kolik vydrží pacient.
3. **Cooldowny ability** — u tlačítek.
4. **Sekundární zdroje** (ATP, antigen, inflammation) — menší, dole.
5. **Minimap** — roh, jen na vyžádání/glance.

Desktop: stejné rozložení, ovládací prvky zmizí (klávesnice + myš / gamepad).

---

## 5. Ovládání

**Mobil (výchozí návrh, řeší twin-stick problém na telefonu):**
- **Levý stick** — pohyb (volný, 360°)
- **Primary** — automatický (auto-aim na nejbližší hrozbu); hráč řeší pozici, ne míření
- **Special** — drag-to-aim (přidrž a táhni = zacílíš)
- **Dash** — tap kamkoli na pravé půlce / dedikované tlačítko
- **Cast/ability** — 1–2 tlačítka vpravo dole

**Desktop:** WASD + myš (free aim), space dash, RMB special. Plný twin-stick feel.

> Rozhodnutí k otestování: auto-aim primary (přístupnost) vs. plné míření (skill
> ceiling). Doporučuju auto-aim primary + manuální special jako kompromis — viz
> otevřená otázka v plánu.

---

## 6. Horečka jako diegetický feedback (nejdůležitější UX detail)

Teploměr s číslem nestačí. Horečku musí hráč **cítit periferně**, aby ji řídil v boji,
ne aby na ni zíral:

| Zóna | Číslo | Vizuál / audio |
|------|-------|----------------|
| Normotermie | <38 °C | čistý obraz, klidný ambient, postava „pomalá" |
| **Febrilní** | 38–40 °C | jemný zlatavý glow kolem postavy (HSP buff), svižnější audio, lehké zteplé tónování |
| Hyperpyrexie | 40–41,5 °C | **červená vinětace sílí**, tepelné chvění okrajů, zrychlený tep v audiu, varovný puls teploměru |
| Kritická | >41,5 °C | obraz pulzuje, „delirium" rozostření, ovládání lehce drift, alarm |

Cíl: hráč ví, že přehořívá, **aniž by spustil oči z akce**. Sweet spot je vizuálně
příjemný (zlatý glow) → hra ho podvědomě táhne tam, kde má být.

---

## 7. Room loop — krok za krokem (90 % hraní)

1. **Vstup** dveřmi → krátký fade, kamera usadí arénu.
2. **Lockdown** → dveře se zatáhnou biofilmem/membránou. Spawn telegraf: patogeny
   „prosáknou" z tkáně (předvídatelné, ne instant).
3. **Boj** → pohyb + primary/special/dash. Aktivita patogenů + tvoje zánětlivé
   schopnosti **zvedají teploměr**. Hráč žongluje: tlačit se do febrilní zóny kvůli
   buffům × nepřekročit oranžovou.
4. **Drop feedback** → zabití dává okamžitý mikro-loot (ATP/antigen) s juicy pop-em.
5. **Clear** → poslední nepřítel padne, dveře povolí, krátké „room cleared" odlehčení
   (teploměr lehce klesne, host HP se mírně srovná).
6. **Door preview** → každé dveře nesou **ikonu odměny + ikonu rizika** (Hades-style):
   - 🧬 antigen room · ⚡ ATP · 💉 boon (cytokinový signál) · 🔥 fever hazard ·
     ☠ elite (těžší, lepší loot) · ❤ heal.
7. **Volba** = informované rozhodnutí riziko/odměna → další místnost.

> Tempo: místnost 30–60 s. Boj musí mít „juice" (hit-stop, knockback, particle burst),
> jinak edukační vrstva neudrží pozornost.

---

## 8. Lymfatická uzlina — mid-run hub (krok za krokem)

Po vyčištění biomu vstupuješ do bezpečné uzliny (žádný boj):

1. **Prezentace antigenů** → utratíš nasbírané antigeny za cílené upgrady proti
   druhům, které jsi potkal (data-driven nabídka).
2. **Th polarizace** → jednorázová/posilovaná volba archetypu (Th1/Th2/Th17/Treg),
   tvaruje zbytek runu.
3. **Rest** → mírně sníží horečku a doplní host HP (cena: čas / žádná).
4. **Náhled dalšího biomu** → ikona nadcházejícího bosse + jeho horečkový vztah
   (např. „sráží horečku" / „žene horečku") → hráč se připraví.

---

## 9. Boss UX (krok za krokem)

1. **Intro** → jméno bosse + krátký Codex teaser (kdo to je reálně). Skip-able.
2. **Boss health bar** nahoře + **fáze segmenty** (vidíš, kolik fází zbývá).
3. **Telegrafy** → každý velký útok má jasný wind-up (barevný indikátor zóny dopadu),
   honest hit-boxy. Hades pravidlo: smrt = chyba hráče, ne náhoda.
4. **Fever-warning** → když boss manipuluje horečku (Drift Engine ji žene nahoru,
   Mycelial Sovereign sráží dolů), teploměr blikne a UI to explicitně signalizuje.
5. **Phase shift** → vizuální + audio zlom; pokud byl spuštěn horečkou (MRSA shift),
   krátký textový flash „Pod tepelným stresem mutuje!" → učí kauzalitu.
6. **Kill** → slow-mo, burst, drop biome reward + cesta dál.

---

## 10. Death & Mutation Reveal (krok za krokem) — nejdůležitější meta moment

Smrt nesmí být frustrující prázdno. Je to **informace** a posun:

1. **Death fade** → klid, žádný „GAME OVER" křik.
2. **Run summary** → kolik biomů, peak horečka, dominantní taktika (auto-detekováno).
3. **MUTATION REVEAL** → klíčová obrazovka. Ukáže, **co se patogeny naučily**:
   > „Staphylococcus přežil tvé horké runy → získal **termotoleranci**.
   >  Tvoje ROS bursty ho už tolik nepálí (**catalase**)."
   Vizuálně: genom patogenu s nově rozsvícenými traity. Hráč chápe *proč* a *jak* se
   příště přizpůsobit.
4. **Meta odměny** → memory tokeny, případně nový unlock.
5. **Návrat do hubu** → s jasnou radou: „Zvaž vakcinaci proti této linii."

> Tohle je smyčka, co drží hráče: každá smrt = lekce + konkrétní příští krok. Žádná
> smrt není zbytečná, přesně jako u imunologické paměti.

---

## 11. Onboarding — první run, minuta po minutě

Jak nováček zažije prvních ~5 minut (žádné textové zdi, učení akcí):

- **0:00** — Nasazení do epitelu. Jediný pohyblivý stick aktivní. Šipka: „Jdi sem."
- **0:20** — První slabá bakterie. Auto-primary ji sundá → naučí se, že primary jede
  sám. Pop loot.
- **0:40** — Více bakterií + teploměr poprvé znatelně stoupne → zlatý glow febrilní
  zóny se rozsvítí, postava zrychlí. Hráč *cítí* odměnu za horečku, beze slov.
- **1:10** — První místnost clear → dveře se otevřou se 2 ikonami. Tooltip: „Vyber
  cestu." Učí door-preview volbu.
- **1:40** — Special button se odemkne s telegrafem (drag-to-aim demo).
- **2:30** — Mini-elite, který přežije jeden ROS → krátký flash o mutaci/rezistenci
  (zaseje koncept dřív, než ho run plně využije).
- **3:30** — Lymfatická uzlina: první volba upgradu + Th polarizace (2 jasné možnosti).
- **5:00** — Mini-boss epitelu s 2 fázemi → první „fever shift" varování.

> Princip onboardingu: **každý systém se představí akcí v momentě, kdy je poprvé
> relevantní**, ne dopředu textem. Hloubka (mutace, vakcinace) se odhalí postupně přes
> Death/Mutation Reveal, ne v tutoriálu.

---

## 12. UX checklist pro implementaci (Flame)

- [ ] Teploměr jako Flame overlay komponenta, vždy on-top, 60 fps plynulá interpolace.
- [ ] Horečkový post-process (vinětace/chvění) jako shader nebo vrstvená overlay
      reagující na `FeverController` value.
- [ ] Door-preview ikony generované z room-graph metadat.
- [ ] HUD overlay = Flutter widgety přes `GameWidget` (snadné theming, a11y).
- [ ] Pauza/menu jako overlay, ne nová route (zachová Flame stav).
- [ ] Haptika (mobil) na: spike horečky, phase shift, kritická zóna.
- [ ] Mutation Reveal jako samostatná Flutter route s daty z `MutationEngine`.
- [ ] „Skip intro / hold to start" pro veterány všude.
```
