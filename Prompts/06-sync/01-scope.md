# IMMUNORUN – Synchronizace hry a knihy: scope (v0.1, 2026-10-15)

> Navazuje na `../05-kniha/` (kniha) a na `../architecture/` (roadmapa hry). Řeší jedinou otázku:
> **jak zajistit, že hra a kniha říkají totéž, dnes i za rok, až ve hře přibudou mutace, šest
> leukocytů a tři biomy.**

---

## 1. Problém jedním odstavcem

Kniha (05-kniha) popisuje motivy hry. Hra se ale mění každý týden: přibude upgrade, změní se práh
horečky z 38,0 na 38,5 °C, tank dostane jiné jméno. Bez mechanismu kniha za půl roku lže: tvrdí
„označený nepřítel bere +25 %", zatímco `balance.dart` říká +30 %; má kapitolu o tanku-houbě,
zatímco ve hře je tank biofilm bakterií; nemá nic o neutrofilu, který mezitím přibyl. A naopak:
kniha vysvětlí histamin jako „zpomalení", a designér hry netuší, že změnou efektu rozbije kapitolu 6.
Synchronizace je **datový kontrakt + test + proces**, ne dobrá vůle.

---

## 2. Co dnes drží pojmy hry (a jak jsou roztroušené)

| Pojem | Kde žije | Český název | Číslo | Vysvětlení |
|---|---|---|---|---|
| Upgrady (7) | `domain/upgrade.dart` (`UpgradeId`, `nameCz`, `descCz`) | ano | **v textu `descCz` natvrdo** („+25 %", „4 s") | ne |
| Nepřátelé (3) | `domain/enemy_archetype.dart` (`EnemyType`) + `killedByLabelCz` v `meta_progress.dart` | jen v game-over | `balance.dart` | ne |
| Status efekty (5, 2 aktivní) | `domain/status_effects.dart` | ne | `balance.dart` | ne |
| Typy poškození (4) | `domain/damage.dart` | ne | `balance.dart` | ne |
| Místnosti (4) | `domain/room_type.dart` + ikony v overlayi | v overlayi | – | ne |
| Zóny horečky (4) | jen prahy v `balance.dart` (`feverFebrilStart`…) | v HUD | `balance.dart` | ne |
| Meta (paměťové buňky, vakcinace) | `domain/meta_progress.dart` | v overlayích | `balance.dart` | ne |
| ATP, dash, special | `balance.dart` | v HUD | `balance.dart` | ne |

Závěr: **není jedno místo, které by řeklo „tohle jsou pojmy hry"**. Kniha by si musela seznam
opsat ručně a ruční opis se rozejde.

---

## 3. Cíle

1. **Jeden registr pojmů** (čistý Dart, `domain/lore.dart`): každý herní koncept, který má
   biologický předobraz, má záznam s id, českým názvem, jednou větou „ve hře", jednou větou
   „doopravdy" (nebo `null`, když hra nelže) a odkazem na kapitolu + kotvu v knize. Hra i kniha
   čtou z něj (ADR 0001).
2. **Čísla se nepíší, dosazují se.** Text knihy i `descCz` upgradů obsahuje placeholdery
   `{{balance.opsonizedDamageTakenMulti|pct}}`, které se renderují z `balance.dart`. Změna balance
   změní knihu automaticky (ADR 0002).
3. **Test jako brána.** `flutter test` padne, když: (a) hodnota enumu nemá záznam v registru,
   (b) záznam odkazuje na neexistující kapitolu/kotvu, (c) kapitola odkazuje na neexistující
   záznam, (d) záznam s „doopravdy" nemá v kapitole honesty box, (e) placeholder odkazuje na
   neexistující konstantu. Běží v CI na každém PR (ADR 0003). Dnes repo CI na PR **nemá** – jen
   release workflow na tag; to je první věc k doplnění.
4. **Hra hlásí setkání.** Jediný výstup hry do knihy: `LoreEncounter(id)` při prvním setkání
   (první tank, první febrilní zóna, první upgrade…). Kniha si ho uloží jako razítko. Nic zpět do
   gameplay (ADR 0004).
5. **Roadmapa se promítá do knihy dopředu.** Plánované mechaniky z `architecture/` mají v registru
   stav `planned`; kapitoly fáze 2 existují jako pahýly se stavem `planned`, v release buildu
   skryté. Když mechanika přistane v kódu, test vynutí přepnutí na `live` a dopsání textu.
6. **Proces.** Definice hotového pro každé herní PR, které sahá na `domain/`: záznam v registru,
   kapitola nebo kotva, zelený sync test. Zapsáno v `CLAUDE.md` a v PR šabloně.
7. **Opačný směr: biologie jako zdroj designu.** Kde by honesty box musel popřít hlavní dojem
   z mechaniky, je levnější upravit mechaniku. Každý záznam nese `lie: none|small|large`; `large`
   má návrh úpravy v [03-mechaniky-z-biologie.md](03-mechaniky-z-biologie.md) a nové mechaniky
   začínají od `realityCz`, ne od gesta.

---

## 4. Co se synchronizuje a co ne

**Synchronizuje se (má záznam v registru):**
- upgrady, nepřátelé a bossové (včetně fází), status efekty, typy poškození, zóny horečky,
  místnosti/biomy, meta mechaniky (paměťové buňky, vakcinace), zdroje (ATP), schopnosti hráče
  s biologickým předobrazem (fagocytóza = primary, dash = membrána, nabitý dash = panožky,
  juke = oxidativní vzplanutí ROS, nova = lysozymová salva, special = sekreční granule;
  rozhodnuto 2026-10-15, mapování v `open-questions.md` OQ-2),
- budoucí: leukocyty jako postavy, mutace a rezistence, Th polarizace, lymfatická uzlina, cytokinová
  bouře, sepse.

**Nesynchronizuje se (bez záznamu, nebo `LoreKind.gameOnly`):**
- čistě herní pojmy bez biologie: hit-stop, knockback, kamera, gesta, pooly, obtížnost vln,
- tuning hodnoty bez narativu (rychlost px/s, poloměr hitboxu).

Pravidlo: **co má české jméno viditelné hráčem, je v registru.** Co hráč nikdy nepojmenované
nevidí, není.

---

## 5. Datový kontrakt (návrh, Opus dopracuje v S1)

```dart
// domain/lore.dart – čistý Dart
enum LoreKind { upgrade, enemy, status, damage, feverZone, room, meta, ability, resource, mechanic }
enum LoreStatus { live, planned, retired }

class LoreEntry {
  final String      id;          // 'upgrade.opsonin', 'enemy.tank', 'fever.febrile', 'meta.vaccination'
  final LoreKind    kind;
  final LoreStatus  status;
  final String      nameCz;      // „Opsonizace (IgG)" – jediný zdroj pro UI i knihu
  final String      inGameCz;    // „Zásahy značkují cíl – bere {{balance.opsonizedDamageTakenMulti|pctDelta}} poškození po {{balance.opsonizedDuration|s}}."
  final String?     realityCz;   // „Protilátka nepřítele nezesílí, jen ho zviditelní pro fagocyty." – null = hra nelže
  final String      chapter;     // '08-protilatky'
  final String?     anchor;      // 'opsonizace' – nadpis v kapitole
  final Object?     ref;         // UpgradeId.opsonin | EnemyType.tank | StatusEffect.opsonized … (pro test úplnosti)
  final String?     sourceRef;   // 'HB2015 s.112' – zdroj pro realityCz (05-kniha/sources.md)
  final LieSize     lie;         // none | small | large – viz 03-mechaniky-z-biologie.md
}
```

Kapitola (Markdown, front matter) má `lore: [upgrade.opsonin, status.opsonized]` a nadpisy
s kotvami `## Opsonizace {#opsonizace}`. Placeholdery `{{balance.<konstanta>|<formát>}}` fungují
v `inGameCz`, `descCz` i v textu kapitol; formáty: `pct` (×1.25 → „125 %"), `pctDelta` (×1.25 →
„+25 %"), `s` („4 s"), `degC` („38 °C"), `int`.

---

## 6. Tok dat

```
balance.dart ──┐
               ├─► domain/lore.dart (registr) ──► UI hry (karty, HUD tooltipy, game-over)
domain enumy ──┘          │
                          ├─► kniha: validace (test) + render placeholderů
                          │
hra: LoreEncounter(id) ───┴─► MetaProgress.seenLore ──► razítka v knize, „Nová stránka" toast
```

Nikdy opačně: kniha nic do hry neposílá, kvíz nic neodemyká (05-kniha ADR 0002).

---

## 7. Nefunkční požadavky

- Registr a validace jsou čistý Dart; test běží bez renderu pod 5 s.
- Render placeholderů deterministický, bez reflexe: generovaná mapa `balanceLookup` (`tool/gen_balance_map.dart`
  → `config/balance_map.g.dart`, test hlídá, že je aktuální – stejný vzor jako `coverage.g.dart`
  v CuteKidFonts).
- Žádný text knihy ani `nameCz` se neduplikuje na dvou místech; duplicita je nález v review.
- CI na PR: `flutter analyze`, `flutter test`, velikost `assets/book/`, kontrola generovaných
  souborů bez diffu. Doba běhu cíl < 6 min.

---

## 8. Rizika

| Riziko | Opatření |
|---|---|
| Registr se stane „další věcí, na kterou se zapomene" | test úplnosti nad enumy: zapomenutí = červené CI |
| Placeholdery udělají z textu kód a garant ho nepřečte | `tool/lore_report.dart` vyrenderuje knihu do čistého Markdownu pro recenzi |
| Změna balance tiše změní smysl věty (z „zpomalí" na „zrychlí") | hodnoty se dosazují, slovesa ne; test na znaménko (`pctDelta` u konstant < 1 vyžaduje jiný formát) |
| Plánované kapitoly prosáknou do release | `LoreStatus.planned` + `BOOK_RELEASE` define: test zakáže `planned` záznamy s textem v release |
| Dvě pravdy pro název (upgrade.dart vs. lore.dart) | `UpgradeDef.nameCz` se nahradí odkazem do registru (S1), ne kopií |
| Hra bez CI na PR | S0 je první milník a podmínka všech dalších |

---

## 9. Rozhodnutí (2026-10-15, k potvrzení vlastníkem)

1. Jeden registr pojmů v `domain/lore.dart`; UI hry i kniha čtou názvy a věty z něj (ADR 0001).
2. Čísla v textech jen přes placeholdery z `balance.dart` (ADR 0002).
3. Sync test je brána CI; CI na PR vznikne jako první milník (ADR 0003).
4. Hra posílá knize jen `LoreEncounter`; nic zpět (ADR 0004).
5. Plánované mechaniky mají záznam `planned` a pahýl kapitoly; release je skrývá.
6. Granularita razítek: per záznam (ne per kapitola); kapitola je „potkaná", když má aspoň jeden
   potkaný záznam.
7. Tank v biomu 1 je shluk *Staphylococcus aureus* v biofilmu (bakterie); houba přijde až s biomem 3
   (rozhodnuto vlastníkem 2026-10-15, OQ-1).
8. Comba mají biologický výklad a záznam v registru: nabitý dash = panožky (aktin), juke =
   oxidativní vzplanutí (ROS), nova = lysozymová salva (rozhodnuto vlastníkem 2026-10-15, OQ-2).
