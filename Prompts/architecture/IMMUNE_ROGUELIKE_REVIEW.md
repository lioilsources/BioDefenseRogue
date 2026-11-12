# IMMUNE ROGUELIKE — Revize: logická & edukační přesnost

> Companion k `PLAN` / `SYSTEMS` / `COMBAT` / `UX` / `01-PLAN-phase-0-2`.
> Revize designu i hratelného slice (Fáze 0–2) z hlediska **biologické přesnosti** a **edukační logiky**.
> Cíl: opravit místa, kde by hra učila chybný mentální model, doplnit chybějící biologii a zaznamenat rozpory plán↔kód.

---

## 0. Celkový verdikt

Nezvykle dobře zrešeršovaný design. Ústřední teze — **„imunitní systém JE roguelike"** — není natažená: klonální selekce, permadeath, paměť-jako-meta-progrese a antigenní drift skutečně sedí na roguelite strukturu. Zhruba **80 % konkrétních mechanik je biologicky obhajitelných** a několik z nich je *vynikajících* (NK missing-self, NK×CD8 komplementarita, afinní maturace jako „kalibrace", Th17→houby, Treg jako brzda zánětu, houby vs. horečka) — lepších než u většiny „science" her.

Chyby se shlukují do několika identifikovatelných míst: **lamarckovský rámec rezistence**, **eozinofil/anafylaxe → horečka**, a pár „boss ti manipuluje horečku" hand-wavů. Žádná není fatální; všechny jsou opravitelné bez újmy na hratelnosti.

---

## A1. Co je přesné a hodné zachování (nesahat)

Tyto designy jsou biologicky správné a patří k nejlepším — v revizích je **neoslabovat**:

- **Prahy horečky** — 36,5 / 38 / 40 / 41,5 / 42 °C jsou klinicky věrné. Normál ~37 °C, febrilie ≥38 °C, hyperpyrexie >41 °C, denaturace bílkovin ~42–43 °C.
- **„Febrilní sweet spot buffuje imunitu + zpomaluje patogeny"** — nejsilnější myšlenka designu a **reálná**: teplota ~38–40 °C zvyšuje motilitu a fagocytózu neutrofilů/makrofágů, proliferaci T-buněk, tvorbu protilátek, NK/CTL cytotoxicitu; upreguluje adhezní molekuly (ICAM-1) a chemokiny (CCL21) → rychlejší trafficking lymfocytů do uzlin (Repasky/Evans). Mnoho patogenů replikuje nejlépe při 37 °C a je při febrilii zpomaleno; horečka navíc žene sekvestraci železa/zinku („nutriční imunita"), čímž hladoví bakterie.
- **Heat-shock proteiny** — tepelný stres indukuje HSP70/90: (a) chaperonují/chrání proteiny → cytoprotektivní buff je správně, (b) imunologicky HSP70 pomáhá MHC-I cross-prezentaci a extracelulární HSP jsou DAMP aktivující APC. Oba buffy (defenzivní i ofenzivní) obhajitelné.
- **Analogie rezistence na antibiotika** (mutace pod selekčním tlakem; ROS→catalase, protilátky→antigenní drift, fagocytóza→anti-fagocytární kapsule) — edukačně vynikající. (Pozor na rámování, viz A2 #1.)
- **6 leukocytů** — mechanismy v jádru sedí (detaily/korekce viz A2).
- **NK × CD8 komplementarita** — virus sníží MHC-I → unikne CD8, ale odhalí se NK („cloaked" status). Přesné a elegantní; jedna z nejlepších mechanik.
- **Afinní maturace jako kalibrace** („první zásahy slabé, sílí; antigenní drift resetuje") — somatická hypermutace + selekce v germinálních centrech reálně produkují protilátky vyšší afinity a antigenní změna existující vazbu ruší. Nádherná mapa mechanika↔biologie.
- **Th1/Th2/Th17/Treg** archetypy a cíle — správně (Th17→houby je učebnicové: deficit IL-17 osy = chronická mukokutánní kandidóza; Treg jako brzda cytokinové bouře perfektně sedí).
- **Cytokinová bouře a imunopatologie jako risk** (příliš silná odpověď zabije hostitele — sepse, těžký COVID, CAR-T CRS) — přesné a vynikající.
- **Paměť = vakcinace jako meta-progrese** — nejvěrnější meta-loop, jaký imunologie nabízí. Respektuje specificitu (imunizuješ se proti jedné linii).
- **Houby vs. horečka** — endotermie a horečka jako antifungální bariéra (Casadevall) je aktuální, správná biologie.

---

## A2. Nepřesnosti a zjednodušení k opravě

> Seřazeno dle důležitosti. Většina = drobná korekce formulace + poznámka do Codexu.

### 1. ⭐ NEJDŮLEŽITĚJŠÍ — Lamarckovský rámec rezistence
**Problém:** Design říká „patogen *získá* rezistenci, protože *přežil* tvůj tlak" a „mutační budget úměrný přežitému selekčnímu tlaku". To učí **řízenou adaptaci** (organismus získá vlastnost, *protože ji potřebuje*) — přesně tu mylnou představu, proti které biologové bojují.

**Reálně (Luria–Delbrück, fluktuační test, 1943):** mutace vznikají **náhodně a předem**, nezávisle na selektoru. Selekce pak jen **obohatí** už existující rezistentní varianty. Selektor nesměruje, *který* mutant se objeví.

**Oprava:**
- Přerámovat na: *„malá rezistentní subpopulace už existovala → tvůj tlak jí dal převládnout"*. Vizuálně: přeživší rezistentní menšina viditelně repopuluje.
- **Mutation Reveal** obrazovka: „Rezistentní menšina tu byla už předtím — tvůj tlak jí dal převahu." (Správnější *a* silnější stewardship poselství.)
- **SOS response** (SYSTEMS §6.2) je správně, ale rámovat jako „mutuje *rychleji*" (víc losů do loterie), NE „mutuje *správným směrem*". Stres zvyšuje *rychlost* náhodné mutace, nesměruje ji.
- **Přidat horizontální přenos genů** (plazmidy, transformace, transdukce) — tak se reálná rezistence z velké části šíří; biofilm (už v designu) je HGT hotspot → přirozený fit pro S. aureus bosse.
- Varianta **„Hraj za patogen"** (COMBAT/varianty) tenhle problém opraví zážitkově: sázíš na náhodné mutace *naslepo* a pak tě selekce vybere.

### 2. Makrofág jako střelec (ranged) je biologicky chybný
Makrofág *fagocytuje* (pohltí), nestřílí. Design (COMBAT §4: fagocytóza = melee „sežrání" + heal) je **správný**, ale implementace udělala z hráče generického shootera → hratelná verze učí „imunitní buňka = střílečka". **Nejvýraznější rozpor plán↔kód s edukačním dopadem.** (Oprava = úkol Fáze 3, viz `03-PLAN`.)

### 3. Eozinofil/mastocyt „anafylaktická bomba zvedá horečku" — chybné
**Anafylaxe nezvyšuje horečku.** Histamin dělá vazodilataci, hypotenzi/šok a bronchospasmus — anafylaxe je typicky **afebrilní**. Horečku ženou pyrogenní cytokiny (IL-1, IL-6, TNF-α → PGE₂ → hypotalamický set-point), ne histamin.

**Oprava (zachovat „fever-build" fantazii, opravit mechanismus):**
- Fever-coupling navázat na **uvolnění pyrogenních cytokinů TNF-α / IL-6** — mastocyty jsou jejich preformovanou zásobárnou. Biologicky správné.
- Samotnou **anafylaxi** modelovat jako **host-shock / self-damage / near-death event** — sedne do autoimunitního/imunopatologického tématu mnohem líp než jako zdroj horečky.
- Kosmetika: „degranulační kužel (histamin/MBP)" míchá eozinofilní MBP s mastocytárním/bazofilním histaminem — lze rozlišit.

### 4. Neutrofil „ROS Special stojí život / umírá po degranulaci"
Degranulace sama **fatální není**. Suicidální forma buněčné smrti je **NETóza** (buňka zemře, aby uvolnila NET). Neutrofil je navíc intrinsicky **krátkověký** (hodiny–dny → apoptóza).

**Oprava:** „stojí život" navázat na **NETózu** nebo na **časovač krátké životnosti**; ROS burst nechat jako costly-but-not-necessarily-suicidal. Časovač životnosti je jinak přesný.

### 5. B-buňka class switch jako obousměrný toggle
Doc píše „IgM ↔ IgG ↔ IgA ↔ IgE" (reverzibilní). Reálná **class-switch rekombinace je nevratná a převážně jednosměrná** — deletuje konstantní geny mezi, takže z IgG zpět na IgM nelze a pořadí lokusu omezuje sekvenci.

**Oprava:** buď explicitně flagovat jako vědomé herní zjednodušení, nebo udělat přepnutí **jednosměrným commitem s cenou**. (IgM pentamer + synergie s komplementem je správně: IgM je pentamer a nejlepší aktivátor klasické dráhy.)
*Drobná mezera:* afinní maturace vyžaduje T-folikulární-helper (Tfh) v germinálních centrech — Tfh v Th rosteru chybí.

### 6. Komplement/MAC jako univerzální „prorazí stěnu" DoT
MAC (C5b–C9) tvoří póry → osmotická lýza; „stacking DoT" je fér model. **Ale:** MAC je účinný proti **gramnegativním** a obaleným buňkám; **grampozitivní** (tlustý peptidoglykan — *Staphylococcus*, *Streptococcus*) jsou z velké části **MAC-rezistentní**, houby též.

**Oprava:**
- U S. aureus bosse udělat komplementovou rezistenci **explicitní** (proto ho design správně counteruje NETs/Th17, ne komplementem) — je to reálná lekce, proč komplement není univerzální.
- Doplnit hlavní role komplementu: **opsonizace (C3b)** a **anafylatoxiny/chemotaxe (C3a/C5a)**, nejen MAC. „Komplementové inhibitory" jako mutace (patogeny rekrutují faktor H, exprimují proteázy) jsou reálné.

### 7. „Autoimunita" jako obecný self-damage
Striktně: **autoimunita** = ztráta self-tolerance / adaptivní útok na vlastní antigeny (autoreaktivní T/B, molekulární mimikry, selhání tolerance). **Imunopatologie** = kolaterální škoda z protipatogenní odpovědi. Nejsou totéž.

**Oprava:** self-damage z nadměrného zánětu přejmenovat na **„imunopatologie / kolaterální poškození"**; „autoimunitu" rezervovat pro **distinktní event** — molekulární mimikry po boji s patogenem sdílejícím epitopy se self (revmatická horečka po Strep, Guillain-Barré po *Campylobacter*). Přidá celý správný koncept místo rozmazání jednoho.

### 8. MRSA shift „spuštěný horečkou"
MRSA rezistence = gen **mecA** (pozměněný PBP2a) na **mobilním elementu SCCmec** — *předem přítomný / horizontálně získaný*, **ne teplem indukovaný**.

**Oprava:** přijatelné jako *metafora* „selekční tlak odhalí rezistentní subpopulaci", ale Codex musí uvést: kmen gen **už měl**, tvůj tlak ho jen vyselektoval (posiluje opravu #1).

### 9. Aspergillus „sráží tvoji horečku" — mechanismus obrácený
Neexistuje silný reálný mechanismus, jímž by Aspergillus aktivně *snižoval* horečku hostitele. Aspergillus je klasický **oportunista imunokompromitovaných** (neutropenie, kortikosteroidy).

**Oprava:** silnější a přesná biologie je opak — **houby jsou teplotně omezené**, drž horečku *nahoře*, ať houbu spálíš, jinak přeroste. „Snížení horečky" navázat na **imunosupresi/steroidy** (které jsou antipyretické *i* imunosupresivní), ne na antipyretický toxin houby.

### 10. „Kinetic" damage type není biologický
Přejmenovat na `phagocytic` / `mechanical` (příp. `perforin` pro lytické). — `immunorun/lib/domain/damage.dart`.

### 11. Fever vs. hyperthermie/hyperpyrexie
Regulovaná **horečka** (zvýšený hypotalamický set-point, až ~41 °C) je sama vzácně škodlivá; letální stavy jsou *neregulovaná* **hyperthermie**/úpal a hyperpyrexie. Hra „fever" a „přehřátí" slévá (dramaticky OK).

**Oprava:** Codex ať rozliší set-point fever od tepelného poškození. Klinicky „hyperpyrexie" > 41,1 °C.

---

## A3. Rozpory plán ↔ kód (implementace zaostává za designem)

Nejde o chyby designu, ale o místa, kde hratelný slice neodpovídá plánu. Patří do `03-PLAN-phase-3-7.md` jako úkoly Fáze 3.

| # | Rozpor | Dopad |
|---|--------|-------|
| 1 | **Fever buffy se reálně neaplikují** — `CombatResolver` (fever atk-speed/dmg/crit) je volán jen v testech; živý zásah `Projectile → Enemy.takeDamage` ho obchází. | Signature mechanika „jezdi na horečce" není v boji cítit. |
| 2 | **Febrilní buff jen z poloviny** — implementován je jen buff hráče (atk-speed 1,0→1,25); chybí **zpomalení/oslabení patogenů** ve febrilní zóně a **penalta v normotermii**. | Hráč se naučí jen „teplo = můj DPS ↑", mine reálnou lekci o duální roli horečky. |
| 3 | **Status efekty mrtvé** — `status_effects.dart` (opsonized, inflamed, trapped, slowed, stunned) se nikde neaplikuje ani nerenderuje. | Opsonizace/zánět/NETs jako edukační vrstva chybí ve hře. |
| 4 | **DamageType nevyužit** na živých zásazích; **EnemyType.tank a ne-boss shooter** se nespawnují; **xpDrop** nikdo nekonzumuje. | Diverzita patogenů zatím jen v datech. |
| 5 | **Boss bez patogenní identity** — orbitující barevný kruh; design chce *S. aureus* (koaguláza, biofilm, MRSA shift). `bossFeverTrigger 39.5` v kódu je, ale bez biologického rámce/vizuálu. | Boss neučí nic konkrétního. |
| 6 | **Fever vs. inflammation duplicita** — HUD mock ukazuje oba metry, kód má jen fever (viz `03-PLAN` reconciliace). | Nejasná risk architektura. |

---

## Odkazy

- Opravy A2 se promítají přímo do `IMMUNE_ROGUELIKE_SYSTEMS.md`, `IMMUNE_ROGUELIKE_PLAN.md`, `IMMUNE_ROGUELIKE_COMBAT.md`, `IMMUNE_ROGUELIKE_UX.md` (poznámky `> Revize:` s odkazem sem).
- Rozpory A3 a implementační úkoly → `Prompts/03-PLAN-phase-3-7.md`.
- Chybějící biologie a varianty → viz `03-PLAN-phase-3-7.md` §B3/C a roadmapa v `IMMUNE_ROGUELIKE_PLAN.md` §11.
