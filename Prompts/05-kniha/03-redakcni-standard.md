# Lexikon zdraví – redakční standard (v0.1, K0, 2026-10-16)

Závazná pravidla pro psaní kapitol a hesel. Pravidlo označené **[test]** vynutí validační test
z K1 (`test/book/`) nebo sync test z S2. Ostatní pravidla kontroluje redakce a garant při review.
Vzorem je kapitola `immunorun/assets/book/cs/05-horecka.md`.

Navazuje na: `01-scope.md` §2 (zásady psaní), ADR 0001 (Markdown), ADR 0003 (pravdivost),
`../06-sync/01-scope.md` (registr pojmů, kotvy, placeholdery), `sources.md` (zdroje).

---

## 1. Soubory

- Kapitola: `immunorun/assets/book/cs/<id>.md`. Id = `NN-slug`, kde slug je kebab-case bez
  diakritiky. Seznam id je pevný a je ve `BookChapter` v `lib/domain/lore.dart`. **[test]**
- Hesla: `immunorun/assets/book/cs/glossary.md`. Strana pro rodiče: `parents.md`.
- Obrázky: `immunorun/assets/book/images/<id>-hero.webp` a `<id>-schema-<n>.webp`. **[test]**
- Jeden soubor = jedna kapitola. Kapitola se nedělí do více souborů.

## 2. Front matter

Kapitola začíná blokem YAML mezi `---` a `---`. Parser v K1 ho čte balíčkem `yaml`
(čistý Dart, OQ-11).

| Pole | Povinné | Hodnota | Pravidlo |
|---|---|---|---|
| `id` | ano | `05-horecka` | shoduje se s názvem souboru a s `BookChapter` **[test]** |
| `title` | ano | `Horečka: kamarád, ne nepřítel` | ≤ 40 znaků **[test]** |
| `part` | ano | `1`–`4` | 1 Dívej se, 2 Kdo je kdo, 3 Jak to funguje, 4 Paměť **[test]** |
| `palette` | ano | `mint` / `sky` / `peach` / `lavender` | musí odpovídat části (1 mint, 2 sky, 3 peach, 4 lavender) **[test]** |
| `status` | ne | `live` (výchozí) / `planned` | `planned` kapitola je v release skrytá (06-sync S5) |
| `hero` | ano | `05-horecka-hero.webp` | soubor existuje v `images/` (od K4; do té doby placeholder) **[test]** |
| `lore` | ano | seznam id z registru | každé id existuje; každý `live` záznam s touto kapitolou je v seznamu; může být prázdný (kapitola 11) **[test, S2]** |
| `quiz` | ano | 3 otázky, viz §8 | **[test]** |
| `audio` | ne | název souboru | narace ve fázi 2 (ADR 0005); ve fázi 1 se ignoruje |

Pole `game_refs` z `02-plan.md` K0 nahrazuje `lore` z plánu synchronizace (06-sync scope §4).
Kapitola nevyjmenovává enumy kódu, ale záznamy registru.

## 3. Povolené bloky

Podmnožina Markdownu. Co tu není, parser v K1 odmítne. **[test]**

| Blok | Zápis | Poznámka |
|---|---|---|
| Stránka | `---` na samostatném řádku | Odděluje stránky. První stránka začíná hned za front matter. |
| Nadpis stránky | `## Text {#kotva}` | Každá stránka začíná právě jedním `##`. Kotva je kebab-case bez diakritiky a v kapitole je jedinečná **[test]**. Kotvy z registru (`anchor`) musí v kapitole existovat **[test, S2]**. |
| Mezititulek | `### Text` | Nejvýš jeden na stránku, bez kotvy. |
| Odstavec | prostý text | Bez seznamů s odrážkami v hlavním textu (patří jen do praktického boxu). |
| Heslo | `**text**` nebo `**text\|heslo**` | Viz §5. Tučné písmo se na nic jiného nepoužívá. |
| Kurzíva | `*Staphylococcus aureus*` | Jen pro latinské názvy a názvy knih. |
| Obrázek | `![Popisek pro čtečku](05-horecka-schema-1.webp)` | Jen schéma. Hero je ve front matter. Popisek je povinný (přístupnost). |
| Box | `> [!druh]` + odstavce s `>` | Viz §4. |
| Odrážky | `- text` | Jen uvnitř boxu `prakticky`. |
| Zdroj | `<!-- src: … -->`, `<!-- TODO-FACT: … -->` | Viz §6. Ve čtečce se nezobrazuje. |
| Placeholder | `{{balance.<konstanta>\|<formát>}}` | Viz §7. |

Zakázáno: tabulky, odkazy `[text](url)` (výjimka `parents.md`), HTML mimo komentáře, nadpis `#`,
kód, číslované seznamy. **[test]**

## 4. Boxy

| Druh | Tag | Kdy | Počet v kapitole |
|---|---|---|---|
| Jak je to doopravdy | `> [!doopravdy]` | Kde hra zjednodušuje nebo lže. Začíná „Ve hře…“, pokračuje „Doopravdy…“. | **≥ 1** (ADR 0003) **[test]** |
| Věděl/a jsi? | `> [!vedel]` | Jeden překvapivý, ověřený fakt. | **právě 1** **[test]** |
| Pro zvědavé | `> [!zvedave]` | Hlubší vrstva pro 13–15 let. Smí obsahovat pojmy, které hlavní text nepotřebuje. | 0–2 |
| Co s tím doma | `> [!prakticky]` | Praktická rada (horečka, očkování, hygiena). Odrážky povoleny. | 0–1 |

- Na stránce je nejvýš jeden box **[test]** (01-scope §2, zásada 1).
- Box `doopravdy` musí být v každé kapitole, která v `lore` uvádí záznam s `realityCz`
  **[test, S2]**. Tato podmínka platí navíc k povinnému minimu jednoho boxu.
- Box nemá vlastní nadpis. Titulek („Jak je to doopravdy“ atd.) doplní čtečka podle druhu.

## 5. Hesla (slovníček)

- Tučně se píše **pouze heslo**, a to jen při prvním výskytu v kapitole. **[test]**
- Když se text hesla shoduje s jeho id, stačí `**pyrogen**`. Když se tvar v textu liší (pád,
  množné číslo), zapíše se `**pyrogeny|pyrogen**`: před svislítkem je zobrazený text, za ním id
  hesla. Id je kebab-case bez diakritiky. **[test]**
- Každé id hesla existuje v `glossary.md` jako `## Název {#id}`. **[test]**
- Seznam hesel s přiřazením ke kapitolám je v `04-osnova.md`. Definice se píšou v K3
  (1–2 věty, úroveň 12 let).

## 6. Zdroje a fakta

- Každý odstavec, který tvrdí něco o skutečném těle, má za sebou komentář se zdrojem:
  `<!-- src: KLÍČ místo -->`, nebo `<!-- TODO-FACT: KLÍČ – co ověřit -->`. Klíč existuje
  v `sources.md` **[test]**.
- V režimu `BOOK_RELEASE` nesmí v souboru zůstat žádný `TODO-FACT` **[test]** (ADR 0003).
- Čísla se nevymýšlejí. Číslo o těle (37 °C, rok 1882) musí mít zdroj. Číslo o hře je vždy
  placeholder.
- Věty o hře (Ve hře…) zdroj nepotřebují. Musí ale odpovídat registru (`inGameCz`) a `balance.dart`.
- Hra ve hlavním textu nikdy nevystupuje jako pravda o těle. Kde hra lže, píše se to do boxu
  `doopravdy`.

## 7. Placeholdery

- Hodnota ze hry: `{{balance.feverFebrilStart|degC}}`. Konstanta musí existovat
  v `config/balance.dart` **[test, S2]**.
- Formáty (06-sync S2): `pct`, `pctDelta`, `s`, `degC`, `int`.
- Placeholder počítá limit slov jako jedno slovo.
- Desetinná čárka: render musí psát česky (`41,5 °C`). Karty upgradu dnes ukazují `0.15 °C/s`
  s tečkou (OQ-12).

## 8. Kvíz

```yaml
quiz:
  - question: Kdo v těle zapíná horečku?
    answers:
      - text: Bakterie samy.
      - text: Mozek, když dostane zprávu od obránců.
        correct: true
      - text: Svaly, když hodně běháš.
    why: Obránci pošlou zprávu (pyrogen) a mozek přestaví svůj termostat výš.
```

- Právě 3 otázky, každá má právě 3 odpovědi a právě jednu `correct: true`. **[test]**
- `why` je jedna věta (≤ 25 slov) a vysvětluje správnou odpověď. **[test]**
- Odpověď musí jít najít v hlavním textu kapitoly. Box `zvedave` se nepočítá.
- Žádná otázka na čísla ze hry. Kvíz se ptá na tělo, ne na balance.
- Správná odpověď nesmí být nejdelší ze tří. Napovídá to. Kontrolu dělá review, ne test.

## 9. Limity

Hodnoty dostanou v K1 konstanty v `balance.dart` (sekce `Book`). Test je čte odtud.
„Hlavní text“ = odstavce a mezititulky bez boxů, front matter, komentářů a kvízu.
Slovo = posloupnost znaků oddělená mezerou. Placeholder je jedno slovo.

| Limit | Hodnota | Konstanta (K1) | Test |
|---|---|---|---|
| Slov hlavního textu na stránku | ≤ 80 | `bookWordsPerPageMax` | chyba |
| Slov hlavního textu v kapitole | 250–450 | `bookChapterWordsMin/Max` | chyba |
| Slov v jednom boxu | ≤ 60 | `bookBoxWordsMax` | chyba |
| Stránek v kapitole | 4–7 | `bookPagesMin/Max` | chyba |
| Slov ve větě (hlavní text) | ≤ 20 | `bookSentenceWordsMax` | varování |
| Odstavců na stránku | 1–4 | `bookParagraphsPerPageMax` | chyba |
| Délka `title` | ≤ 40 znaků | `bookTitleCharsMax` | chyba |
| `why` v kvízu | ≤ 25 slov | `bookQuizWhyWordsMax` | chyba |

Doba čtení kapitoly 2–4 min (02-plan §1) odpovídá 250–450 slovům a boxům.

## 10. Jazyk

1. **Ty-forma.** „Když máš horečku…“. Žádné „vy“, žádné „děti“ ve třetí osobě.
2. **Nerodově, kde to jde.** Píše se přítomný čas („Když máš…“, ne „Když jsi měl…“). Kde rod
   nejde obejít, použije se lomítko: „Věděl/a jsi?“, „unavený/á“.
3. **Krátké věty.** Jedna věta = jedna myšlenka. Vedlejší věta nejvýš jedna.
4. **Latinský nebo anglický název jednou**, v závorce, při prvním výskytu:
   „zlatý stafylokok (*Staphylococcus aureus*)“. Dál česky. Zkratky (IL-6, ATP) se při prvním
   výskytu vysvětlí slovy.
5. **Pořadí „Ve hře → Doopravdy → Proč“** (scope §2, zásada 2). Stránka začíná tím, co dítě zná
   ze hry, pak řekne, jak to je, pak proč.
6. **Bez strašení** (scope §2, zásada 5). Žádné „můžeš umřít“. Nebezpečí se popíše věcně
   a hned s řešením: dospělý, lékař, očkování.
7. **Metafory jen ohlášené.** „Funguje to jako termostat.“ Metafora nesmí přebít fakt. Pokud ji
   dítě může pochopit doslova, vysvětlí se v boxu `doopravdy`.
8. **Jednotky** s mezerou: `38 °C`, `3 s`, `25 %`. Desetinná čárka.
9. **Nejistotu vědy přiznat.** „Vědci si myslí…“, „Zatím se neví…“. Nikdy nepsat jistotu,
   kterou zdroj nemá.
10. **Žádné rady o lécích a dávkách.** Jen „léky ti dá dospělý nebo lékař“.

## 11. Struktura kapitoly

1. **Úvodní stránka**: kotva hlavního pojmu, „Ve hře…“ a jedna věta, o čem kapitola je.
2. **2–4 stránky mechanismu**: každá jedna myšlenka a kotva, kterou může cílit registr.
3. **Stránka s boxem `doopravdy`**: shrne, kde hra lže.
4. **Volitelně stránka s praktickým boxem**.
5. **Kvíz** je ve front matter. Čtečka ho přidá jako poslední stránku.

Box `vedel` stojí tam, kde se tematicky hodí, ne nutně na konci.

## 12. Obrázky

- **Hero** (registr *mikrofoto*, 768 px): jeden na kapitolu, ve front matter. **[test]**
- **Schéma** (registr *schéma*, 512 px): v textu, povinné pro kapitoly 4, 5, 7, 8, 11, 12 (F7).
  **[test]**
- Zadání obrázku (jedna věta pro ComfyUI) je v `04-osnova.md`, v K4 se přenese do
  `art/book/manifest.json`.
- V obrázku nesmí být text, šipky s popisky ani měřítko (ADR 0004). Popisky sází Flutter.

## 13. Kontrolní seznam autora (před PR)

- [ ] front matter úplný, `lore` odpovídá registru
- [ ] každá stránka má `##` s kotvou a nejvýš jeden box
- [ ] `doopravdy` ≥ 1, `vedel` = 1
- [ ] každé tučné slovo má heslo v `glossary.md`
- [ ] každý odstavec o těle má `src` nebo `TODO-FACT` s klíčem ze `sources.md`
- [ ] žádné číslo o hře natvrdo
- [ ] limity slov (spustit `flutter test test/book/` od K1)
- [ ] kvíz: 3 × 3, jedna správná, odpověď je v textu
- [ ] přečteno nahlas: zní to jako věta pro dvanáctileté?
