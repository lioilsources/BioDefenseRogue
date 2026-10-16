# Lexikon zdraví – osnova kapitol (v0.1, K0, 2026-10-16)

Osnova 13 souborů kapitol (00–12) pro K3. Pro každou kapitolu: o čem, záznamy registru
(`lore`) s kotvami, hesla, boxy, kvíz a obrázky. Formát a limity jsou v `03-redakcni-standard.md`.
Kapitola 5 je napsaná celá jako vzor (`immunorun/assets/book/cs/05-horecka.md`).

**Fakta v osnově jsou zatím neověřená.** Osnova určuje, o čem se píše, ne co je ověřené. Každé
tvrzení dostane v K3 zdroj, nebo zůstane `TODO-FACT` (ADR 0003). Čísla o těle, která tu jsou
(velikosti, roky), jsou kandidáti k ověření, ne hodnoty k opsání.

Značení kvízu: ✔ správná odpověď, ✘ špatná. Obrázky: **H** = hero (*mikrofoto*, 768 px),
**S** = schéma (*schéma*, 512 px, ploché pastelové, bez textu). Zadání je jedna věta pro ComfyUI.
Stylový blok a seed doplní K4 v `art/book/manifest.json`.

---

## Část I – Dívej se (`part: 1`, `palette: mint`)

### 00-mikroskop – Jak se dívat do těla

**O čem.** Hra vypadá jako pohled do elektronového mikroskopu. Kapitola vysvětlí, jak se do
tak malého světa díváme, proč jsou snímky z elektronového mikroskopu původně černobílé a odkud
mají barvy. Ukáže měřítko: buňka je zhruba desetkrát větší než bakterie a bakterie zhruba
desetkrát větší než virus (ověřit).

- **lore:** `mechanic.microscope` → `#falesne-barvy`
- **Kotvy:** `#mikroskop`, `#meritko`, `#falesne-barvy`
- **Hesla:** mikroskop, elektronový mikroskop, mikrometr, buňka, falešné barvy
- **Doopravdy:** barvy ve hře nejsou skutečné. Vědci je na snímek domalují, aby šly buňky
  rozlišit.
- **Věděl/a jsi?:** na snímek z elektronového mikroskopu se vzorek pokovuje tenkou vrstvou kovu
  (ověřit, SEM).
- **Kvíz:**
  1. Proč jsou snímky z elektronového mikroskopu barevné? ✔ Barvy domalují lidé. ✘ Buňky tak
     doopravdy svítí. ✘ Mikroskop fotí jako mobil.
  2. Co je největší? ✔ Bílá krvinka. ✘ Bakterie. ✘ Virus.
  3. Proč nestačí obyčejný mikroskop na viry? ✔ Viry jsou na něj moc malé. ✘ Viry jsou průhledné
     jako sklo. ✘ Viry se pořád hýbou.
- **H:** falešně kolorovaný SEM snímek makrofágu, který natahuje výběžky ke shluku kulatých
  bakterií, tmavé pozadí.
- **S:** —

### 01-telo-jako-hrad – Tělo jako hrad

**O čem.** Kůže a sliznice jsou hradby. Kapitola ukáže, kudy se nepřítel dostane dovnitř (rána,
nos, ústa), co je epitel a proč rána zčervená a oteče. Místnosti ve hře (boj, elitní boj, léčení,
boss) jsou úseky tkáně. Epitel je biom 1.

- **lore:** `room.combat`, `room.elite`, `room.treasure`, `room.boss` → `#mistnosti`
- **Kotvy:** `#hradby`, `#epitel`, `#rana`, `#mistnosti`
- **Hesla:** epitel, sliznice, tkáň, hlen
- **Doopravdy:** tkáň nemá dveře ani místnosti. Ve hře je to mapa, ve skutečnosti souvislá vrstva
  buněk.
- **Věděl/a jsi?:** povrchové buňky kůže se neustále obnovují, ty staré odpadávají (ověřit
  rychlost, HOREJSI/ALBERTS).
- **Kvíz:**
  1. Co je první hradba těla? ✔ Kůže a sliznice. ✘ Srdce a cévy. ✘ Kosti a svaly.
  2. Kudy se bakterie nejsnáz dostanou dovnitř? ✔ Ranou v kůži. ✘ Přes zdravou kůži. ✘ Přes vlasy.
  3. K čemu je hlen v nose? ✔ Zachytí prach a mikroby. ✘ Barví nos dočervena. ✘ Vyrábí
     protilátky.
- **H:** SEM snímek povrchu epitelu s dlaždicovými buňkami a několika kulatými bakteriemi na
  okraji.
- **S:** —

---

## Část II – Kdo je kdo (`part: 2`, `palette: sky`)

### 02-bile-krvinky – Bílé krvinky: tým obránců

**O čem.** Představení týmu: makrofág (ty), neutrofil, NK buňka, B buňka, T buňka, dendritická
buňka, žírná buňka. Každá má povolání a jednu větu. Mapa: vrozená imunita reaguje hned a na
všechno, získaná se učí a pamatuje si. Plánované postavy hry (neutrofil a další) dostanou zmínku,
nikoli slib.

- **lore:** `status.trapped` (planned) → `#neutrofil`
- **Kotvy:** `#tym`, `#makrofag`, `#neutrofil`, `#vrozena-a-ziskana`
- **Hesla:** bílá krvinka, makrofág, neutrofil, NK buňka, B buňka, T buňka, dendritická buňka,
  žírná buňka, vrozená imunita, získaná imunita
- **Doopravdy:** makrofág ve hře bojuje sám. Doopravdy nikdy nebojuje sám, tým pracuje najednou.
- **Pro zvědavé:** makrofág se rodí z monocytu v krvi.
- **Věděl/a jsi?:** neutrofil umí vyhodit síť z vlastní DNA a chytit do ní bakterie (NET).
- **Kvíz:**
  1. Která buňka je ve hře ty? ✔ Makrofág. ✘ Červená krvinka. ✘ Nervová buňka.
  2. Čím se liší získaná imunita od vrozené? ✔ Učí se a pamatuje si. ✘ Je vždycky rychlejší.
     ✘ Funguje jen v kůži.
  3. Co dělá neutrofil? ✔ Rychle přiběhne a pohlcuje bakterie. ✘ Vyrábí protilátky. ✘ Nosí
     kyslík.
- **H:** SEM skupinový snímek různých bílých krvinek vedle sebe, každá v jiné pastelové falešné
  barvě.
- **S:** —

### 03-nepratele – Nepřátelé: bakterie, viry, houby

**O čem.** Roj koků, biofilm a zlatý stafylokok ze hry. Proč „kok“ (kulatý), proč „stafylo“
(hrozen) a proč „zlatý“ (barva kolonií). Biofilm jako sliz, ve kterém se koky schovají před
obránci. To je tank ve hře. Proč boss v druhé fázi zesílí: bakterie si „spočítají“, kolik jich je,
a přepnou na toxiny (quorum sensing). Viry potřebují tvoje buňky, plíseň *Aspergillus* létá
vzduchem jako spory. Většina bakterií v těle je kamarád.

- **lore:** `enemy.swarmer` → `#koky`, `enemy.tank` → `#biofilm`, `enemy.boss`,
  `enemy.boss.phase2` → `#stafylokok`
- **Kotvy:** `#koky`, `#biofilm`, `#stafylokok`, `#viry`, `#houby`, `#mikrobiom`
- **Hesla:** bakterie, kok, stafylokok, biofilm, toxin, quorum sensing, virus, plíseň, spora,
  mikrobiom
- **Doopravdy:** koky samy nehoní obránce, nemají čím. Ve hře fáze 2 bosse přijde s horečkou,
  doopravdy horečka bakterie brzdí (rozpor s kapitolou 5, návrh úpravy hry v
  `06-sync/03-mechaniky-z-biologie.md` §1).
- **Věděl/a jsi?:** v tvém těle je bakterií zhruba stejně jako tvých buněk (ověřit, novější odhady
  se liší).
- **Kvíz:**
  1. Proč se tank ve hře tak špatně ničí? ✔ Koky se schovávají v slizu (biofilmu). ✘ Má krunýř
     z kosti. ✘ Je to obří jedna bakterie.
  2. Co virus potřebuje, aby se množil? ✔ Tvoje buňky. ✘ Sluneční světlo. ✘ Horečku.
  3. Jsou všechny bakterie v těle nepřátelé? ✔ Ne, většina pomáhá. ✘ Ano, všechny škodí. ✘ V těle
     žádné bakterie nejsou.
- **H:** SEM snímek shluku kulatých stafylokoků zabořených do slizovité vrstvy biofilmu.
- **S:** —

### 04-fagocytoza – Sežrat nepřítele: fagocytóza

**O čem.** Hlavní pohyb makrofága. Obejme bakterii panožkami, uzavře ji do váčku (fagozom),
přidá trávicí váček (lysozom) a rozloží ji. Kolem sebe umí vypustit kyslíkové radikály (ROS =
juke, oxidativní vzplanutí) a lysozym (nova). Proč hráč „střílí“, když doopravdy žere. Historický
box: Mečnikov a trn v larvě hvězdice.

- **lore:** `ability.phagocytosis` → `#fagocytoza`, `ability.oxidativeBurst` → `#ros`,
  `ability.lysozymeBurst` → `#lysozym`, `ability.special` (retired) → `#sekrece`
- **Kotvy:** `#fagocytoza`, `#uvnitr-makrofagu`, `#ros`, `#lysozym`, `#mecnikov`
- **Hesla:** fagocytóza, fagozom, lysozom, kyslíkové radikály (ROS), lysozym
- **Doopravdy:** makrofág nestřílí, pohlcuje. Při oxidativním vzplanutí se nestane neporazitelným.
- **Pro zvědavé:** ROS jsou nebezpečné i pro vlastní buňky, proto je makrofág drží hlavně uvnitř
  fagozomu.
- **Věděl/a jsi?:** lysozym máš i ve slzách a slinách.
- **Historický box (v textu, ne box):** Mečnikov (rok ověřit, scope uvádí 1882) a Bio-Defense (1984)
  jako předek hry, dvě věty.
- **Kvíz:**
  1. Co znamená fagocytóza? ✔ Buňka pohltí a rozloží nepřítele. ✘ Buňka vystřelí šíp.
     ✘ Buňka se rozdělí na dvě.
  2. Kde všude najdeš lysozym? ✔ Ve slzách a slinách. ✘ Jen v kostech. ✘ Jen v bakteriích.
  3. Proč makrofág drží ROS hlavně uvnitř váčku? ✔ Poškodily by i tělo. ✘ Rychle by se vypařily.
     ✘ Venku nefungují.
- **H:** SEM snímek makrofágu, který obtáčí výběžky kolem tyčinkovité bakterie.
- **S1:** tři kroky fagocytózy vedle sebe: buňka obtéká bakterii, bakterie uzavřená ve váčku,
  váček splývá s menším váčkem.

---

## Část III – Jak to funguje (`part: 3`, `palette: peach`)

### 05-horecka – Horečka: kamarád, ne nepřítel

**Napsáno celé jako vzor.** Viz `immunorun/assets/book/cs/05-horecka.md`.

- **lore:** `mechanic.fever` → `#horecka`, `fever.normo` → `#normalni-teplota`, `fever.febrile` →
  `#proc-horecka-pomaha`, `fever.hyper`, `fever.critical` → `#kdy-je-horecka-nebezpecna`,
  `upgrade.pyrogen` → `#pyrogeny`
- **Hesla:** hypotalamus, pyrogen, zimnice, bílá krvinka (z kap. 2)
- **H:** SEM snímek bílé krvinky obklopené bakteriemi, laděný do teplých oranžových falešných barev.
- **S1:** obranná buňka vysílá drobné částice krví k mozku, mozek má symbol termostatu posunutého
  výš.

### 06-zanet-a-histamin – Zánět a histamin

**O čem.** Žírné buňky vypustí histamin, cévy se roztáhnou a propustí tekutinu. Proto rána
zčervená, oteče a je teplá. Otok je dobré znamení: obránci se dostanou tam, kde jsou potřeba.
Alergie je falešný poplach. Proč ve hře histamin zpomaluje nepřítele.

- **lore:** `upgrade.histamin`, `status.slowed` → `#histamin`, `status.inflamed` (planned)
- **Kotvy:** `#zanet`, `#histamin`, `#otok`, `#alergie`
- **Hesla:** zánět, histamin, céva, otok, alergie
- **Doopravdy:** histamin na bakterie nepůsobí. Působí na cévy: ty propustí tekutinu, vznikne otok,
  a v něm se nepřítel opravdu pohybuje hůř.
- **Věděl/a jsi?:** Čtyři znaky zánětu znali lékaři už ve starověku: zarudnutí, otok, teplo a bolest
  (ověřit, Celsus).
- **Kvíz:**
  1. Co udělá histamin? ✔ Roztáhne cévy a ty propustí tekutinu. ✘ Rozpustí bakterii. ✘ Ochladí
     ránu.
  2. Proč je otok kolem rány užitečný? ✔ Obránci se dostanou k infekci. ✘ Ránu zakryje jako
     náplast. ✘ Bakterie se v něm utopí.
  3. Co je alergie? ✔ Poplach proti něčemu neškodnému. ✘ Nemoc z bakterií. ✘ Druh horečky.
- **H:** SEM snímek žírné buňky plné drobných granulí.
- **S:** —

### 07-cytokiny – Signály: cytokiny a chemotaxe

**O čem.** Buňky si posílají zprávy (cytokiny). Některé přidávají plyn (IL-6), jiné brzdí (IL-10).
Chemotaxe: obránci jdou po „pachu“ zprávy až k infekci. Treg je regulační T buňka, brzda celé
obrany. Proč je důležité umět i zastavit.

- **lore:** `upgrade.treg` → `#treg`
- **Kotvy:** `#cytokiny`, `#chemotaxe`, `#treg`, `#brzda`
- **Hesla:** cytokin, interleukin, chemotaxe, regulační T buňka (Treg)
- **Doopravdy:** Treg ve hře jen rychleji chladí horečku. Doopravdy tlumí celou imunitní odpověď,
  aby nepoškodila tělo.
- **Pro zvědavé:** cytokinová bouře, když brzda selže (věcně, bez strašení).
- **Věděl/a jsi?:** obránci najdou infekci podle koncentrace zprávy, jako ty voňavou kuchyni podle
  vůně.
- **Kvíz:**
  1. Co jsou cytokiny? ✔ Zprávy, které si buňky posílají. ✘ Druh bakterií. ✘ Části kostí.
  2. Jak obránce najde infekci? ✔ Jde tam, kde je zpráva nejsilnější. ✘ Náhodou. ✘ Podle světla.
  3. Proč obrana potřebuje brzdu? ✔ Aby nepoškodila vlastní tělo. ✘ Aby šetřila protilátky.
     ✘ Aby bakterie stihly utéct.
- **H:** SEM snímek několika buněk spojených tenkými výběžky.
- **S1:** buňka vysílá vlnu drobných teček a druhá buňka po nich putuje směrem k ní.

### 08-protilatky – Protilátky a značkování (opsonizace)

**O čem.** Protilátka má tvar Y. Sedí na nepříteli jako klíč v zámku a označí ho. Fagocyt pak
označeného nepřítele snáz pozná a pohltí. To je opsonizace. Vyrábí je B buňky. IgG, IgA, IgM, IgE
po jedné větě. Proč ve hře označený nepřítel bere víc poškození.

- **lore:** `upgrade.opsonin`, `status.opsonized` → `#opsonizace`
- **Kotvy:** `#protilatky`, `#klic-a-zamek`, `#opsonizace`, `#typy-protilatek`
- **Hesla:** protilátka, antigen, opsonizace, imunoglobulin
- **Doopravdy:** protilátka nepřítele nezraní. Jen ho označí, aby ho fagocyt snáz našel a pohltil.
- **Věděl/a jsi?:** miminko dostane první protilátky od mámy, přes placentu a mateřské mléko.
- **Kvíz:**
  1. Jaký tvar má protilátka? ✔ Písmeno Y. ✘ Kulička. ✘ Spirála.
  2. Co dělá opsonizace? ✔ Označí nepřítele, aby ho fagocyt snáz pohltil. ✘ Nepřítele rozřízne.
     ✘ Zvýší horečku.
  3. Která buňka vyrábí protilátky? ✔ B buňka. ✘ Červená krvinka. ✘ Žírná buňka.
- **H:** SEM snímek B buňky (lymfocytu) s hrbolatým povrchem.
- **S1:** bakterie pokrytá malými tvary Y a fagocyt, který se k ní natahuje.

### 09-energie-bunky – Energie buňky: ATP, mitochondrie, membrána

**O čem.** ATP je baterie buňky, mitochondrie elektrárna, membrána pružná stěna (dash). Panožky
a aktin jsou „nohy“ buňky (nabitý dash). Proč ve hře sbíráš ATP, když doopravdy si ho buňka
vyrábí sama.

- **lore:** `resource.atp` → `#atp`, `upgrade.mitochondrie` → `#mitochondrie`, `upgrade.membrana`,
  `ability.dash` → `#membrana`, `ability.chargeDash` → `#panozky`
- **Kotvy:** `#atp`, `#mitochondrie`, `#membrana`, `#panozky`
- **Hesla:** ATP, mitochondrie, membrána, aktin, panožka
- **Doopravdy:** ATP se nesbírá z mrtvých bakterií. Buňka si ho vyrábí sama v mitochondriích
  z cukru a kyslíku.
- **Věděl/a jsi?:** mitochondrie mají vlastní DNA, kdysi to byly samostatné bakterie (ověřit tón:
  „vědci si myslí“).
- **Kvíz:**
  1. Kde si buňka vyrábí ATP? ✔ V mitochondriích. ✘ V kostech. ✘ Sbírá ho po bakteriích.
  2. Čím se makrofág pohybuje? ✔ Vysune panožku a přitáhne se. ✘ Má nožičky. ✘ Plave bičíkem.
  3. K čemu je ATP? ✔ Dodává buňce energii na práci. ✘ Barví krev. ✘ Zabíjí viry.
- **H:** SEM snímek makrofágu s dlouhými výběžky (panožkami) na podložce.
- **S:** —

### 10-zabijacke-bunky – Zabijácké buňky: granule, perforin, cytotoxiny

**O čem.** NK buňky a cytotoxické T buňky (CD8) hledají vlastní buňky, které jsou nakažené virem.
Do nakažené buňky udělají otvor (perforin), pošlou dovnitř látky z granulí a buňka se tiše rozloží
(apoptóza). Proč je nutné obětovat vlastní buňku. Typy poškození ve hře (kinetic, inflammatory;
toxic a thermal plánované) proti skutečným mechanismům.

- **lore:** `upgrade.cytotoxin` → `#granule`, `damage.kinetic`, `damage.inflammatory`,
  `damage.toxic` (planned), `damage.thermal` (planned) → `#typy-poskozeni`
- **Kotvy:** `#zabijaci`, `#granule`, `#apoptoza`, `#typy-poskozeni`
- **Hesla:** cytotoxická T buňka, perforin, granule, apoptóza
- **Doopravdy:** makrofág ve hře nemá cytotoxické granule. To je výbava NK a T buněk.
- **Věděl/a jsi?:** buňka umí „uklidit sama sebe“ tak, aby nezpůsobila zánět (apoptóza).
- **Kvíz:**
  1. Proč zabijácké buňky zabíjejí vlastní buňky? ✔ Jsou nakažené virem. ✘ Jsou staré. ✘ Jsou moc
     velké.
  2. K čemu je perforin? ✔ Udělá do buňky otvor. ✘ Barví buňku. ✘ Zahřeje buňku.
  3. Co je apoptóza? ✔ Tichý úklid buňky. ✘ Výbuch buňky. ✘ Dělení buňky.
- **H:** SEM snímek malé zabijácké buňky přitisknuté k větší buňce.
- **S:** —

---

## Část IV – Paměť (`part: 4`, `palette: lavender`)

### 11-lymfaticka-uzlina – Lymfatická uzlina: velitelství

**O čem.** V uzlině dendritická buňka ukáže kousek nepřítele (antigen) T buňkám. Ta, která
nepřítele pozná, se namnoží (klonální selekce). Proto při angíně míváš zvětšené uzliny. Hub ve
hře (plán). Kapitola nemá `live` záznam v registru (`lore: []`), protože hub ještě není ve hře.

- **lore:** — (prázdný seznam; záznamy `mechanic.antigenPresentation`,
  `mechanic.clonalSelection` přidá S5 jako `planned`)
- **Kotvy:** `#uzlina`, `#prezentace-antigenu`, `#klonalni-selekce`, `#angina`
- **Hesla:** lymfatická uzlina, lymfa, prezentace antigenu, klonální selekce
- **Doopravdy:** ve hře zatím uzlina není. Kapitola ukazuje, kam hra poroste.
- **Věděl/a jsi?:** uzlin máš v těle stovky (ověřit počet).
- **Kvíz:**
  1. Proč míváš při angíně zvětšené uzliny? ✔ Obránci se v nich množí. ✘ Jsou plné hlenu. ✘ Ucpaly
     se jídlem.
  2. Co dělá dendritická buňka? ✔ Ukazuje kousek nepřítele T buňkám. ✘ Vyrábí hlen. ✘ Nosí kyslík.
  3. Co je klonální selekce? ✔ Namnoží se ta buňka, která nepřítele pozná. ✘ Buňky si losují.
     ✘ Všechny buňky se zdvojí.
- **H:** SEM snímek dendritické buňky s mnoha tenkými výběžky.
- **S1:** uzlina jako ovál s cestičkami, uvnitř velká buňka s výběžky podává malý tvar menší
  kulaté buňce.

### 12-pamet-a-ockovani – Paměť a očkování

**O čem.** Po infekci zůstanou paměťové buňky. Druhá infekce stejným nepřítelem je proto slabší
nebo vůbec nepřijde. Vakcína ukáže tělu „fotku zločince“ bez nemoci. Bezpečnost očkování věcně a
podle SZÚ a WHO (OQ-10). Proč hra po smrti dává paměťové buňky. Výhled „Co bude dál“ (mutace,
rezistence), kapitoly fáze 2.

- **lore:** `meta.memoryCells` → `#pametove-bunky`, `meta.vaccination` → `#ockovani`
- **Kotvy:** `#pametove-bunky`, `#druha-infekce`, `#ockovani`, `#co-bude-dal`
- **Hesla:** paměťová buňka, očkování, vakcína, kolektivní imunita
- **Doopravdy:** očkování nedává procenta poškození. Dává rychlejší a silnější odpověď, když nepřítel
  přijde. Paměťové buňky ve hře získáš smrtí, doopravdy vznikají po infekci nebo po očkování.
- **Co s tím doma:** očkovací průkaz a kalendář, zeptej se dospělého (formulace podle SZÚ/MZ ČR).
- **Věděl/a jsi?:** první očkování bylo proti neštovicím, Edward Jenner, konec 18. století (ověřit).
- **Kvíz:**
  1. Proč je druhá infekce stejným nepřítelem slabší? ✔ Tělo si ho pamatuje. ✘ Nepřítel zestárne.
     ✘ Tělo vyrobí víc krve.
  2. Co tělu ukáže vakcína? ✔ Jak nepřítel vypadá, bez nemoci. ✘ Jak se vyrábí lék. ✘ Kde je
     nemocnice.
  3. Co ti dá očkování? ✔ Rychlejší obranu, když nepřítel přijde. ✘ Víc síly ve svalech. ✘ Vyšší
     horečku.
- **H:** SEM snímek klidného lymfocytu (paměťové buňky) v laděných fialových falešných barvách.
- **S1:** dvě časové osy vedle sebe: malá pomalá vlna obránců při první infekci, rychlá vysoká vlna
  při druhé.

---

## Glosář – seznam hesel (67)

Jen názvy a id. Definice (1–2 věty, úroveň 12 let) se píšou v K3 do `assets/book/cs/glossary.md`.
Číslo v závorce je kapitola prvního výskytu.

| Heslo | id | | Heslo | id |
|---|---|---|---|---|
| mikroskop (0) | `mikroskop` | | lysozom (4) | `lysozom` |
| elektronový mikroskop (0) | `elektronovy-mikroskop` | | kyslíkové radikály (ROS) (4) | `ros` |
| mikrometr (0) | `mikrometr` | | lysozym (4) | `lysozym` |
| buňka (0) | `bunka` | | hypotalamus (5) | `hypotalamus` |
| falešné barvy (0) | `falesne-barvy` | | pyrogen (5) | `pyrogen` |
| epitel (1) | `epitel` | | zimnice (5) | `zimnice` |
| sliznice (1) | `sliznice` | | zánět (6) | `zanet` |
| tkáň (1) | `tkan` | | histamin (6) | `histamin` |
| hlen (1) | `hlen` | | céva (6) | `ceva` |
| bílá krvinka (2) | `bila-krvinka` | | otok (6) | `otok` |
| makrofág (2) | `makrofag` | | alergie (6) | `alergie` |
| neutrofil (2) | `neutrofil` | | cytokin (7) | `cytokin` |
| NK buňka (2) | `nk-bunka` | | interleukin (7) | `interleukin` |
| B buňka (2) | `b-bunka` | | chemotaxe (7) | `chemotaxe` |
| T buňka (2) | `t-bunka` | | regulační T buňka (7) | `treg` |
| dendritická buňka (2) | `dendriticka-bunka` | | protilátka (8) | `protilatka` |
| žírná buňka (2) | `zirna-bunka` | | antigen (8) | `antigen` |
| vrozená imunita (2) | `vrozena-imunita` | | opsonizace (8) | `opsonizace` |
| získaná imunita (2) | `ziskana-imunita` | | imunoglobulin (8) | `imunoglobulin` |
| bakterie (3) | `bakterie` | | ATP (9) | `atp` |
| kok (3) | `kok` | | mitochondrie (9) | `mitochondrie` |
| stafylokok (3) | `stafylokok` | | membrána (9) | `membrana` |
| biofilm (3) | `biofilm` | | aktin (9) | `aktin` |
| toxin (3) | `toxin` | | panožka (9) | `panozka` |
| quorum sensing (3) | `quorum-sensing` | | cytotoxická T buňka (10) | `cytotoxicka-t-bunka` |
| virus (3) | `virus` | | perforin (10) | `perforin` |
| plíseň (3) | `plisen` | | granule (10) | `granule` |
| spora (3) | `spora` | | apoptóza (10) | `apoptoza` |
| mikrobiom (3) | `mikrobiom` | | lymfatická uzlina (11) | `lymfaticka-uzlina` |
| fagocytóza (4) | `fagocytoza` | | lymfa (11) | `lymfa` |
| fagozom (4) | `fagozom` | | prezentace antigenu (11) | `prezentace-antigenu` |
| | | | klonální selekce (11) | `klonalni-selekce` |
| | | | paměťová buňka (12) | `pametova-bunka` |
| | | | očkování (12) | `ockovani` |
| | | | vakcína (12) | `vakcina` |
| | | | kolektivní imunita (12) | `kolektivni-imunita` |

Hesla `nakažená buňka` (10) a `antigenní drift` (fáze 2) do seznamu nepatří: první je běžné
spojení, druhé přijde až s kapitolou 13.
