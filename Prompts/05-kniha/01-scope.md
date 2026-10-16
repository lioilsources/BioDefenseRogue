# IMMUNORUN – Lexikon zdraví: scope a analýza (v0.1, 2026-10-15)

> Výuková „kniha" o imunologii vestavěná do hry. Populárně naučná, ale odborně správná.
> Publikum: 10–15 let (5.–9. třída ZŠ). Companion k `02-plan.md` (zadání pro Opus) a `ADR/`.

---

## 1. Vize jedním odstavcem

Hráč IMMUNORUN hraje makrofága, honí koky, jezdí na horečce, sbírá „Opsonizaci (IgG)" a „Treg (IL-10)".
Každý z těch pojmů je skutečná imunologie, ale hra ho ukáže jen jako ikonu a číslo. Kniha je místo,
kam si dítě zajde, když ho napadne „co to vlastně je?" – a dostane odpověď, která je pravdivá,
krátká, hezky vysazená (CuteKidFonts) a ilustrovaná (ComfyUI). Kniha nic neodemyká a nic nevyžaduje;
hra na ni jen ukazuje („Co mě zabilo?", ⓘ u karty upgradu). Název: **Lexikon zdraví**
(alternativy v `open-questions.md`, OQ-1).

---

## 2. Publikum a pedagogika

- **Věk 10–15** je rozpětí dvou čtenářských úrovní. Volíme **jednu základní úroveň (≈ 12 let)**
  a boxy *„Pro zvědavé"* s hlubší vrstvou pro 13–15 (ADR 0003 říká, jak se to píše).
- **Návaznost na školu:** RVP ZV, přírodopis, 8. ročník (biologie člověka: krev, oběhová soustava,
  obranyschopnost, nemoci) a 9. ročník (genetika, evoluce). Kniha nenahrazuje učebnici, doplňuje ji
  o to, co učebnice nestihne: buňky mají jména, povahu a práci.
- **Zásady psaní** (závazné pro každou kapitolu):
  1. Jedna dvojstrana = jedna myšlenka. Nadpis, 2–4 krátké odstavce, obrázek, jeden box.
  2. Nejdřív to, co dítě zná ze hry, pak biologie, pak proč je to tak („Ve hře… Doopravdy… Proč?").
  3. Box **„Jak je to doopravdy"** všude, kde hra zjednodušuje nebo lže (horečka nezrychluje útok,
     očkování nedává +15 % dmg, makrofág nestřílí). Hra je metafora, kniha říká, kde metafora končí.
  4. Box **„Věděl/a jsi?"** – jeden překvapivý, ověřený fakt na kapitolu.
  5. Žádné strašení. Nemoc, sepse, autoimunita se popisují věcně, s důrazem na to, že tělo má řešení
     a že existuje pomoc (lékař, očkování, hygiena).
  6. Slovníček: každé tučné slovo má heslo. Latinské/anglické názvy v závorce, jednou.
  7. Kvíz na konci kapitoly: 3 otázky, výběr ze 3, okamžitá odpověď s vysvětlením. Bez známek.

---

## 3. Co je ve hře dnes a co je v plánech (zdroj témat)

Témata knihy vycházejí **výhradně** z motivů hry (dnešních nebo plánovaných v `Prompts/architecture/`).
Nic navíc – kniha má 12 kapitol, ne 40.

| Motiv ve hře | Kde ve hře | Stav | Kapitola |
|---|---|---|---|
| Hráč = makrofág (SEM sprite) | `components/player` | dnes | 2, 4 |
| Roj koků (swarmer), tank (shluk *S. aureus* v biofilmu), mini-boss *S. aureus* | `enemies/` | dnes | 3 |
| Horečka 36,5–42 °C, zóny 38 / 40 / 41,5, smrt horečkou | `fever_controller.dart`, teploměr v HUD | dnes | 5 |
| Upgrady: Opsonizace (IgG), Histamin, Pyrogen (IL-6), Treg (IL-10), Mitochondrie, Membránová fluidita, Cytotoxické granule | `domain/upgrade.dart` | dnes | 6, 7, 8, 9, 10 |
| Status efekty: opsonized, slowed (inflamed, trapped, stunned připravené) | `domain/status_effects.dart` | dnes | 6, 8 |
| ATP jako měna | `pickup.dart` | dnes | 9 |
| Comba: nabitý dash (panožky), juke (oxidativní vzplanutí, ROS), nova (lysozymová salva) | `player.dart`, `gesture_pad.dart` | dnes | 4, 9 |
| Typy poškození: kinetic, inflammatory, toxic, thermal | `domain/damage.dart` | dnes | 10 |
| Místnosti tkáně: combat / elite / treasure / boss; epitel jako biom 1 | `room_type.dart`, `room_graph.dart` | dnes | 1 |
| Paměťové buňky, vakcinace proti tomu, co tě zabilo | `domain/meta_progress.dart` | dnes | 12 |
| Mikroskop, falešně barvená SEM | `microscope.frag`, plán grafiky §1 | dnes | 0 |
| Lymfatická uzlina (hub), prezentace antigenu, Th polarizace | PLAN §2, UX §8 | plán | 11 |
| Neutrofil, NK, B buňka, CD8 T, eosinofil/žírná buňka jako „zbraně" | SYSTEMS §3 | plán | 2 |
| Chřipka (antigenní drift), *Aspergillus* (spory, imunosuprese), sepse (Apex Strain) | SYSTEMS §2 | plán | 3, 13* |
| Mutace, rezistence, SOS response, „Selection Denier" | SYSTEMS §5–6 | plán | 13* |
| Cytokinová bouře, autoimunita | PLAN §7 | plán | 14* |

\* Kapitoly 13–14 jsou **fáze 2** (až ty mechaniky budou ve hře). Ve fázi 1 se na ně jen ukazuje
v kapitole 12 („Co bude dál").

---

## 4. Osnova knihy (fáze 1 = 12 kapitol + slovníček)

**Část I – Dívej se**
- **0. Jak se dívat do těla** – mikroskop, elektronový mikroskop, proč jsou fotky ve hře šedé a
  barvy „falešné". Měřítko: buňka vs. bakterie vs. virus. *Honesty box: barvy ve hře nejsou skutečné.*
- **1. Tělo jako hrad** – kůže a sliznice jako hradby (epitel = biom 1), kudy nepřítel leze dovnitř,
  proč rána „zčervená a oteče". Místnosti tkáně ve hře vs. skutečná tkáň.

**Část II – Kdo je kdo**
- **2. Bílé krvinky: tým obránců** – makrofág (ty), neutrofil, NK buňka, B buňka, T buňka,
  dendritická buňka, žírná buňka. Každá má „povolání" a jednu větu. Mapa vrozené vs. získané imunity.
- **3. Nepřátelé: bakterie, viry, houby** – koky a *Staphylococcus aureus* („zlatý" – proč zlatý,
  biofilm), chřipkový virus (potřebuje tvoje buňky), *Aspergillus* (spory ve vzduchu). Biofilm:
  sliz, ve kterém se koky schovají před obránci (tank). Proč jsou ve hře tank a boss tak, jak jsou. *Věděl/a jsi: většina bakterií v těle je kamarád (mikrobiom).*
- **4. Sežrat nepřítele: fagocytóza** – jak makrofág pohltí bakterii, co se děje uvnitř
  (fagozom, lysozom), ROS. Co makrofág pouští i kolem sebe: ROS (oxidativní vzplanutí = juke) a
  lysozym (nova). Proč hráč „střílí", když doopravdy žere. *Honesty box.* *Věděl/a jsi: lysozym máš
  i v slzách a slinách.*

**Část III – Jak to funguje**
- **5. Horečka: kamarád, ne nepřítel** – kdo ji zapíná (pyrogeny, IL-6, hypotalamus), proč 38 °C
  pomáhá, kdy je 40 °C nebezpečná a proč nad 41,5 °C hra končí. Teploměr ve hře vs. doopravdy.
  *Honesty box: horečka ti doopravdy nezrychlí útok, ale zpomalí bakterie a probudí obránce.*
  Praktický box: co dělat, když mám horečku (pít, odpočívat, říct dospělému).
- **6. Zánět a histamin** – žírné buňky, histamin, proč otok a rudnutí jsou dobré znamení,
  alergie jako „falešný poplach". Proč ve hře histamin zpomaluje nepřítele.
- **7. Signály: cytokiny a chemotaxe** – buňky si „píšou zprávy" (IL-6 = plyn, IL-10 = brzda).
  Treg jako brzda. Proč je důležité umět i zastavit. *Pro zvědavé: cytokinová bouře.*
- **8. Protilátky a značkování (opsonizace)** – tvar Y, jak sedí na nepřítele jako klíč do zámku,
  IgG, IgA, IgM, IgE jednou větou. Proč ve hře označený nepřítel bere víc poškození.
- **9. Energie buňky: ATP, mitochondrie, membrána** – ATP jako baterie, mitochondrie jako
  elektrárna, membrána jako pružná stěna (dash), panožky a aktin jako „nohy" buňky (nabitý dash). *Honesty box: ATP se nesbírá z mrtvých bakterií.*
- **10. Zabijácké buňky: granule, perforin, cytotoxiny** – NK a CD8 T buňky, jak se zabije
  infikovaná vlastní buňka a proč je to nutné. Typy poškození ve hře vs. skutečné mechanismy.

**Část IV – Paměť**
- **11. Lymfatická uzlina: velitelství** – kde se obránci učí (prezentace antigenu, klonální
  selekce). Proč mívám „uzliny" při angíně. Hub ve hře.
- **12. Paměť a očkování** – paměťové buňky, proč druhá infekce je slabší, jak funguje vakcína
  (ukázat tělu „fotku zločince"), bezpečnost očkování věcně a podle SZÚ/WHO. Proč hra po smrti
  dává paměťové buňky. Výhled: *„Co bude dál"* (mutace, rezistence – kapitoly fáze 2).
  *Honesty box: očkování nedává +15 % poškození; dává rychlejší a silnější odpověď.*

**Dodatky**
- **Slovníček** (≈ 60 hesel), **Kvízy**, **Zdroje a kredity** (včetně inspirace: Bio-Defense 1984),
  **Pro rodiče a učitele** (jedna strana: co kniha učí, co ne, kam dál).

---

## 5. Forma

- **Součást appky**, ne samostatná appka ani PDF (ADR 0001). Flutter overlay `book` vedle
  `mainMenu` / `pause`; přístup z hlavního menu („KNIHA"), z pauzy a z game-over
  („Co mě zabilo? → kapitola").
- **Čtečka**: seznam kapitol (obálky) → stránky (swipe), horní lišta s názvem a návratem, spodní
  tečky. Telefon na výšku i tablet. Škálování písma (3 stupně), tmavé pozadí (kniha „svítí" nad hrou).
- **Typografie**: `cute_kid_fonts` (git dependency, tag). Role: `title` pro nadpisy kapitol
  (DynaPuff, bubble), `upper` pro názvy částí, `body` (Baloo 2) pro text, `dialog` pro boxy,
  `number` pro čísla stran a teploty. Paleta per část knihy (mint = Dívej se, sky = Kdo je kdo,
  peach = Jak to funguje, lavender = Paměť).
- **Obrázky**: generované v ComfyUI uživatele, dva registry (ADR 0004): *mikrofoto* (kolorovaná SEM,
  stejný stylový blok jako hra) a *schéma* (ploché, přátelské, bez textu v obrázku – popisky sází
  Flutter). Reprodukovatelnost přes manifest (prompt, seed, model, licence), jako v plánu grafiky §3.3.
- **Zvuk**: otočení stránky, otevření knihy, jemný ambient (plán grafiky nemá hudbu – kniha je
  první místo, kde se objeví). Namluvení kapitol je fáze 2 (ADR 0005).
- **Propojení se hrou**: ⓘ na kartě upgradu, dlouhý stisk teploměru, game-over hint, ikona u karty
  místnosti → otevře konkrétní kapitolu. Hra si pamatuje „potkané" kapitoly a ukazuje razítko,
  ale nic nezamyká (ADR 0002).

---

## 6. Funkční požadavky (číslování pro plán)

- **F1** Obsah: 12 kapitol + slovníček + kvízy + strana pro rodiče, v češtině, podle §2 a §4.
- **F2** Formát obsahu: Markdown s hlavičkou (id, název, část, paleta, obrázky, kvíz) v
  `assets/book/`, parsovaný do čistě dartového modelu, validovaný testy (ADR 0001).
- **F3** Čtečka: overlay, seznam kapitol, stránkování, škálování písma, návrat tam, odkud jsem přišel.
- **F4** Deep-link: `game.openBook(chapterId, {anchor})` ze všech míst v §5.
- **F5** Razítka „potkáno": z `MetaProgress` (persistence přes `meta_repository.dart`).
- **F6** Kvíz: 3 otázky/kapitola, okamžitá zpětná vazba, bez vlivu na hru (OQ-5).
- **F7** Obrázky: ≥ 1 hero obrázek na kapitolu + ≥ 1 schéma tam, kde kapitola vysvětluje mechanismus
  (4, 5, 7, 8, 11, 12). Každý soubor v `CREDITS.md`.
- **F8** Zvuk: 3 SFX (otevřít, listovat, zavřít) + 1 ambient smyčka, respektuje přepínač `ZVUK`.
- **F9** Slovníček: tučné slovo v textu → tap → bublina s heslem.
- **F10** Strana „Pro rodiče a učitele" + „Zdroje".

## 7. Nefunkční požadavky

- **Offline**, žádná síť, žádné externí odkazy v dětské části (odkazy jen na straně pro rodiče, otevírají
  systémový prohlížeč po potvrzení).
- **Velikost**: rozpočet **≤ 12 MB** navíc v APK/IPA za obsah knihy (WebP, 768 px hero, 512 px schéma).
- **Výkon**: otevření knihy < 300 ms, obrázky lazy, žádný dropnutý frame při listování na telefonu.
- **Přístupnost**: minimální velikost body 16 sp, kontrast AA, škálování písma, bez informace nesené
  jen barvou; OQ-7 (dyslexie).
- **Soukromí dětí**: kniha nic neměří a nikam neposílá (žádná analytika). Platí pro celou appku, pokud
  cílí na děti (Google Play Families / Apple Kids – OQ-8).
- **Pravdivost**: každé faktické tvrzení dohledatelné ve `sources.md`; odborný garant schvaluje
  (ADR 0003).
- **Lokalizace**: fáze 1 jen cs; struktura obsahu (`assets/book/cs/`) připravená na en.

---

## 8. Rizika

| Riziko | Dopad | Opatření |
|---|---|---|
| Nepřesná imunologie pro děti (zjednodušení se stane lží) | důvěra, škola | ADR 0003: honesty boxy, zdroje, garant |
| Očkování jako citlivé téma | stížnosti rodičů | věcně, podle SZÚ/WHO/MZ ČR, bez polemiky; strana pro rodiče |
| Licence modelů v ComfyUI (flux dev = non-commercial) | nelze vydat | manifest s licencí modelu; jen Apache/OpenRAIL modely (plán grafiky §3.1, §6) |
| Text v obrázcích (model dokresluje popisky) | nečitelné, chybné | obrázky bez textu, popisky ve Flutteru; kontrola okem |
| Velikost appky | instalace na slabších telefonech | rozpočet 12 MB, WebP, měřit v CI |
| Dítě knihu nikdy neotevře | nulová hodnota | deep-linky z míst, kde vzniká otázka (smrt, karta, teploměr) |
| CuteKidFonts přes git dependency rozbije build | CI | pin na tag, `dependency_overrides` jen lokálně |

---

## 9. Co navrhuji doplnit nad rámec zadání (k rozhodnutí)

1. **Box „Jak je to doopravdy"** v každé kapitole – hra je metafora a dítě to má vědět. Nejlevnější a
   nejhodnotnější věc v celé knize.
2. **Deep-linky ze hry** (smrt, karta upgradu, teploměr) – bez nich kniha zůstane neotevřená.
3. **Strana pro rodiče a učitele** – co kniha učí, co zjednodušuje, kam dál (SZÚ, učebnice). Zároveň
   jediné místo s odkazy ven.
4. **Odborný garant** (imunolog nebo učitel přírodopisu) a **2–3 dětští čtenáři 10–15** před vydáním.
   Není to kód, ale bez toho je „odborně" jen slovo.
5. **Kvízy bez odměny ve hře** – jinak děti proklikají odpovědi kvůli paměťovým buňkám. Jen razítko.
6. **Slovníček jako bublina na tap**, ne samostatná stránka vzadu.
7. **Hudba**: kniha je první místo s ambientem; stojí za to rozhodnout, zda stejná smyčka půjde i do
   menu hry (plán grafiky hudbu neřeší).
8. **Namluvení (fáze 2)** – pro 10leté čtenáře je čtení nahlas velká pomoc; český TTS vs. lidský hlas
   je otázka kvality a ceny (OQ-3).
9. **Tisková verze** (fáze 2) – stejný Markdown → PDF pro třídu; učitelé tisknou.
10. **Mikrobiom a hygiena** jako „Věděl/a jsi" boxy, ne kapitoly – drží to knihu u témat hry.
11. **Historický box**: Bio-Defense (1984) a Metchnikoff (objev fagocytózy, 1882) – dvě věty, jedna
    ilustrace. Děti baví, že hra má 40 let starého předka.
12. **Rozpočet velikosti appky v CI** – jinak se 12 kapitol obrázků nenápadně rozroste na 60 MB.

---

## 10. Zdroje (výchozí seznam pro `sources.md`, Opus doplní čísla stran)

- Hořejší, Bartůňková, Brdička, Špíšek: *Základy imunologie* (Triton) – odborná opora pro češtinu
  a názvosloví.
- Murphy, Weaver: *Janeway's Immunobiology* – referenční kontrola mechanismů.
- Abbas, Lichtman, Pillai: *Basic Immunology* – stručnější kontrola.
- Dettmer: *Immune* (Kurzgesagt) – vzor populárního tónu pro mladší čtenáře (ověřit český překlad).
- SZÚ (szu.cz), MZ ČR, WHO – očkování, horečka, hygiena.
- NIAID, CDC PHIL, NIH BioArt – reference pro vzhled buněk a patogenů (ne pro použití obrázků).
- RVP ZV (přírodopis, 2. stupeň) – ověření návaznosti.

---

## 11. Rozhodnutí (2026-10-15, k potvrzení vlastníkem)

1. Kniha je součást appky jako overlay; obsah v Markdownu v assetech (ADR 0001).
2. Nic se neodemyká hraním; hra jen razítkuje potkané kapitoly (ADR 0002).
3. Každá kapitola má honesty box a dohledatelné zdroje; garant schvaluje (ADR 0003).
4. Vizuál: CuteKidFonts role + dva obrazové registry, jen licenčně čisté modely (ADR 0004).
5. Zvuk fáze 1 = SFX + ambient; narace fáze 2 za flagem (ADR 0005).
6. Fáze 1 = 12 kapitol z motivů, které jsou ve hře dnes; mutace, Th polarizace, biomy 2–3 až fáze 2.
7. Kvíz nemá vliv na hru.
