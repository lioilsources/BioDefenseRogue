# Mechaniky z biologie – opačný směr synchronizace (v0.1, 2026-10-15)

> Scope §3 a ADR 0001 řeší směr **hra → kniha**: co je ve hře, musí kniha umět vysvětlit a říct,
> kde hra lže. Tento dokument řeší směr **biologie → hra**: kde je honesty box dlouhý, je levnější
> upravit mechaniku než psát omluvu. Podnět vlastníka 2026-10-15: „připravit comba, která mají odraz
> v realitě, a stávající tak změnit/upravit."

Pravidlo: **rozpočet lži.** Každý záznam v registru s `realityCz` dostane v S1 jednu ze značek
`lie: none | small | large`. `large` = honesty box musí popřít hlavní dojem z mechaniky (ne detail).
Pro každé `large` vznikne návrh úpravy mechaniky níže; vlastník rozhodne, co se přijme. Nic z toho
není součást milníků S0–S5, ale přijaté návrhy se stanou úkoly v plánu hry a zmenší knihu.

---

## 1. Stávající mechaniky: kde hra lže a co s tím

| Mechanika | Dnešní lež (`lie`) | Úprava, aby lhala méně | Cena | Doporučení |
|---|---|---|---|---|
| **Primary: makrofág střílí projektily** | `large` – makrofág nestřílí, pohlcuje (architektura §3.2 to sama chce: „Primary: pohlcení") | Primary na krátký dosah „pohlcení": nepřítel pod prahem HP je sežrán vcelku (+malý heal, +ATP), nad prahem dostane kontaktní dmg. Střely nechat B buňce (protilátky), až přijde. | velká: mění combat feel jádra (01-PLAN §5 „tady strav nejvíc času") | **Rozhodnutí vlastníka.** Pokud ne, honesty box zůstává a hra je „metafora od začátku". |
| **Nabitý dash: průjezdový damage** | `small` – makrofág nenaráží, obaluje | Průjezd **pohltí** swarmery pod prahem HP (zmizí, +ATP, +heal), tanky jen poškodí. Stejná čísla v `balance.dart`, jiný výsledek u slabých cílů. | malá: 1 větev v `_applyDashHits` | **Přijmout.** Dělá z nabitého dashe fagocytózu, kterou kniha v kapitole 4 vysvětluje. |
| **Juke: neporazitelnost 0,45 s** | `large` – nic takového v biologii není; ROS pulz je naopak pravdivý | Zkrátit i-frames na nutné minimum pro dodge a **pulz ROS zvedne horečku** (`feverRisePerInflammatoryHit`): ROS je zánětlivý. Juke = risk/reward svázaný s centrálním systémem hry, ne volná obrana. | malá: 2 konstanty + 1 volání `FeverController` | **Přijmout.** Honesty box se zmenší na „buňka se nestane neporazitelnou, jen krátce couvne". |
| **Nova: 12 střel po kruhu** | `small` – lysozym není střela, ale AoE je pravdivé | Vizuál z 12 projektilů na **rozpínající se prstenec** (`CircleComponent` + alfa), mechanicky stejný AoE. A: **lysozym funguje jen na bakterie** – až přijdou viry (biom 2) a houby (biom 3), nova je proti nim slabá. To je učebnicový fakt zdarma jako mechanika. | malá (vizuál), střední (per-type modifikátor v `CombatResolver`, až budou typy) | **Přijmout vizuál teď, per-type modifikátor s biomem 2.** |
| **Special: vějíř 3 střel** | `small` – sekrece látek směrem k cíli je zhruba pravdivá | Nechat. Pojmenovat v registru „Sekreční granule (NO, cytotoxiny)". | žádná | Nechat. |
| **Vakcinace: +15 % dmg proti tomu, co tě zabilo** | `large` – očkování dává rychlejší a silnější **odpověď**, ne procenta | Místo plošného +dmg: první zásah daného typu nepřítele v runu ho rovnou **opsonizuje** (paměť = protilátky připravené) a paměťové buňky zrychlí `feverDecay` o malý bonus (rychlejší vyřešení infekce). Pocitově podobně silné, biologicky čitelné. | střední: `_applyMeta` + `CombatResolver` | **Zvážit v plánu hry (meta fáze).** |
| **Histamin: zpomalení nepřítele** | `large` – histamin nepůsobí na bakterie, působí na cévy (propustnost, otok) a přivolává obránce | Histamin jako **zóna**: zásah vytvoří na 2 s „otok" – kruh, ve kterém jsou nepřátelé zpomalení (viskózní tekutina z propustných cév) a hráč v něm regeneruje dash náboje rychleji (přivolané posily). Zpomalení zůstává, jen má důvod. | střední: nová zónová komponenta | **Zvážit.** Levnější varianta: nechat mechaniku, přejmenovat na „Edém (otok)" a histamin nechat v knize jako příčinu. |
| **Horečka: +rychlost útoku** | `large` – horečka zrychluje obránce nepřímo a zpomaluje množení patogenů | Část bonusu přesunout z hráče na nepřátele: ve febrilní zóně **patogeny pomaleji spawnují / mají nižší rychlost** (`feverEnemySpeedMulti`), hráč má menší bonus útoku. Architektura §4.2 to už navrhuje („patogeny zpomalené"). | malá: 1 konstanta + `WaveController`/`Enemy.speed` | **Přijmout.** Zmenší největší honesty box knihy (kapitola 5). |
| **ATP z mrtvých bakterií** | `large` – buňka si ATP vyrábí sama v mitochondriích | ATP dropy přejmenovat/převést na **„živiny" (glukóza)**, které mitochondrie mění na ATP (regen `atpRegen` roste s posbíranými živinami, místo okamžitého ATP). Nebo: dropy = antigeny (měna pro adaptivní strom, architektura §3.2 „APC ekonomika"), ATP jen regen. | střední: HUD + pickup + balance | **Zvážit s meta fází**; teď honesty box. |

---

## 2. Nová comba, která vycházejí z biologie (kandidáti)

Vše z `architecture/SYSTEMS.md` §3.2 (makrofág) – nic nového se nevymýšlí, jen se bere z plánu
hry to, co má reálný předobraz a dá se udělat jako combo bez nové postavy:

| Combo (gesto) | Biologie | Mechanika | Záznam | Kapitola |
|---|---|---|---|---|
| **Prezentace antigenu** (tap na nepřítele) | makrofág ukáže kus nepřítele T buňkám (MHC II) | označí cíl: při smrti dropne navíc „antigen" (meta měna) a cíl je `opsonized`-like viditelný všem střelám | `ability.antigenPresentation` | 11 |
| **Zánětlivý signál** (dlouhý stisk) | cytokiny IL-1/TNF: přivolání posil, zánět | krátký AoE buff (rychlost útoku) + nárůst horečky; nepřátelé v okruhu `inflamed` | `ability.cytokineCall` | 7 |
| **NET / past** (jen pro neutrofila, až bude) | neutrofilní extracelulární past z DNA | zóna `trapped` | `ability.net` | 2, 10 |
| **Přepnutí M1/M2** (double tap) | polarizace makrofágu: M1 útočí, M2 hojí | přepínač: M1 +dmg, +horečka; M2 heal/s, −dmg | `ability.polarization` | 7 |

Každé z nich má `lie: none|small` už od návrhu – to je ten opačný směr: **začít od `realityCz` a
navrhnout mechaniku tak, aby honesty box měl jednu větu.**

---

## 3. Jak s tím naložit

1. S1 označí každý záznam `lie: none|small|large` (přidá se pole do `LoreEntry`); `lore_report`
   vypíše `large` jako seznam k rozhodnutí.
2. Vlastník projde tabulku §1 a označí přijato / odloženo / zamítnuto; přijaté položky jdou do
   plánu hry jako milníky (ne do S-plánu).
3. Nové mechaniky hry od teď vznikají podle §2: nejdřív `realityCz`, pak mechanika, pak kód.
   Zapsat do `CLAUDE.md` v S4 jako jednu větu: „Nový herní pojem začíná záznamem v `lore.dart`."
4. Kniha se píše proti stavu hry v době K3; přijaté úpravy z §1 zmenší nebo zruší příslušné honesty
   boxy – sync test to vynutí (box je povinný jen při `realityCz != null`).
