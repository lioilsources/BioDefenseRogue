# IMMUNORUN – Lexikon zdraví: implementační plán pro Opus (v0.1, 2026-10-15)

Vstup: [01-scope.md](01-scope.md) (rozhodnutí v sekci 11), [ADR/](ADR/). Tento dokument je zadání
pro implementaci. Platí pořadí milníků; každý má acceptance kritéria a končí commitem se zeleným
`flutter analyze` a `flutter test`.

---

## 0. Pevná rozhodnutí (neměnit bez dohody)

- **Kniha je overlay ve hře** (`immunorun/`), ne samostatná appka ani PDF. Obsah = Markdown v
  `assets/book/cs/`, parsovaný do čistě dartového modelu (ADR 0001).
- **Nic se neodemyká hraním.** Všech 12 kapitol je čitelných od první minuty. Hra jen razítkuje
  „potkáno" (ADR 0002).
- **Pravdivost před hravostí.** Každá kapitola má box „Jak je to doopravdy"; každé tvrzení je
  dohledatelné v `sources.md`; nejisté tvrzení se označí `<!-- TODO-FACT -->` a nejde do release
  bez garanta (ADR 0003).
- **Typografie jen přes `cute_kid_fonts`** (git, tag ≥ v0.2.1); žádné hex barvy ani fonty mimo
  balíček v UI knihy. Obrázky bez textu; jen licenčně čisté modely, každý soubor v manifestu a
  `CREDITS.md` (ADR 0004).
- **Zvuk fáze 1 = 3 SFX + 1 ambient smyčka.** Narace je fáze 2 za feature flagem (ADR 0005).
- **Architektura hry platí:** čistý Dart v `domain/` a `book/model`, čísla v `balance.dart`
  (velikosti, časy animací), komentáře a UI copy česky, kód anglicky, Riverpod v3 `Notifier`.
- **Kvíz nemá vliv na gameplay.** Žádné paměťové buňky, HP ani ATP za odpovědi.

---

## 1. Cíl fáze 1 a metriky

Do ~6 týdnů: hráč otevře z menu, z pauzy a z obrazovky smrti knihu s 12 kapitolami, přečte si,
co je horečka nebo opsonizace, vidí k tomu obrázek, slyší otočení stránky, zkusí kvíz a vrátí se
do hry tam, kde byl.

Co musí být měřitelné (lokálně, bez odesílání – jen pro vývoj a testy čtenářů):
- čas čtení kapitoly (cíl 2–4 min), délka kapitoly (cíl 250–450 slov bez boxů),
- počet slov na stránku (cíl ≤ 80), velikost assetů knihy (≤ 12 MB),
- výsledek čtenářského testu: 3 děti 10–15 odpoví na kvíz bez pomoci ≥ 2/3 správně po přečtení.

---

## 2. Struktura repozitáře (delta)

```
BioDefenseRogue/
├── Prompts/05-kniha/              # tento plán, scope, ADR, open-questions, sources
│   └── sources.md                 # K0: zdroje s kapitolou/stranou pro každé tvrzení
├── art/book/                      # K4: manifest ComfyUI + skript; drafty v .gitignore
│   ├── manifest.json              # id, kapitola, registr (sem|schema), prompt, seed, model, licence, postprocess
│   └── drafts/                    # (gitignore)
└── immunorun/
    ├── assets/book/
    │   ├── cs/
    │   │   ├── 00-mikroskop.md … 12-pamet-a-ockovani.md
    │   │   ├── glossary.md        # hesla slovníčku
    │   │   └── parents.md         # strana pro rodiče a učitele
    │   ├── images/                # <chapter>-hero.webp, <chapter>-schema-<n>.webp
    │   └── audio/                 # book_open.wav, page_turn.wav, book_close.wav, book_ambient.ogg
    ├── lib/book/
    │   ├── model/                 # čistý Dart: Chapter, Page, Block (paragraph|heading|image|box|quiz|term), Glossary
    │   ├── parser/                # markdown (balíček `markdown`) → Block model; front matter
    │   ├── book_repository.dart   # načtení assetů, cache, validace
    │   └── book_progress.dart     # razítka „potkáno", poslední stránka (čistý Dart, do MetaProgress)
    ├── lib/ui/book/
    │   ├── book_overlay.dart      # overlay 'book': seznam kapitol ↔ čtečka
    │   ├── chapter_list.dart
    │   ├── chapter_reader.dart    # PageView, lišta, tečky, škálování písma
    │   ├── blocks/                # widget per Block typ (BoxBlock s variantami doopravdy|vedel|zvedave|prakticky)
    │   ├── glossary_popup.dart
    │   ├── quiz_widget.dart
    │   └── book_theme.dart        # mapování KidRole/KidPalette per část knihy
    └── test/book/                 # parser, validace obsahu, progress, widget testy čtečky
```

Kde se co dotkne stávajícího kódu:
- `immuno_game.dart`: registrace overlaye `book`, `openBook(chapterId, {returnTo})`, pauza hry
  při otevření z HUD (stejný vzor jako modální volba, commit `f217798`).
- `main_menu_overlay.dart`, `pause_overlay.dart`, `run_end_overlays.dart`: tlačítko „KNIHA" /
  „Co mě zabilo?" (mapování `lastKilledByType` → kapitola: swarmer→3, tank→3, boss→3, fever→5).
- `upgrade_choice_overlay.dart`, `room_choice_overlay.dart`: ikona ⓘ → kapitola (mapa
  `UpgradeId`→kapitola v UI vrstvě, `domain/upgrade.dart` zůstává čistý).
- `hud/thermometer.dart`: dlouhý stisk → kapitola 5.
- `domain/meta_progress.dart` + `data/meta_repository.dart`: `seenChapters` (set id), `lastChapter`.
- `config/balance.dart`: sekce `Book` (velikosti písma, délky animací, rozpočet obrázků).
- `pubspec.yaml`: `cute_kid_fonts` (git, tag), `markdown`, assety `assets/book/**`.
- `assets/CREDITS.md`: záznam pro každý obrázek a zvuk knihy.

---

## 3. Milníky

### K0 – Redakční standard a vzorová kapitola (týden 1)
Úkoly:
- `Prompts/05-kniha/sources.md`: seznam zdrojů ze scope §10, formát záznamu (zdroj, kapitola/strana,
  k čemu se cituje).
- Redakční šablona kapitoly: front matter (`id`, `title`, `part`, `palette`, `hero`, `game_refs`,
  `quiz`), povolené bloky, povolené boxy (`doopravdy`, `vedel`, `zvedave`, `prakticky`), limity
  (slova/strana, slova/kapitola), pravidla jazyka (ty-forma, krátké věty, latinský název jednou).
- Osnova všech 12 kapitol: 1 odstavec „o čem", seznam tučných hesel, 3 kvízové otázky, seznam obrázků
  (hero + schémata) s jednovětým zadáním pro ComfyUI.
- **Vzorová kapitola 5 „Horečka"** napsaná celá podle šablony, včetně honesty boxu, praktického boxu
  a kvízu; každé tvrzení s odkazem do `sources.md`.
- Glosář: seznam ≈ 60 hesel (jen názvy, definice přijdou v K3).
Acceptance: vlastník schválí osnovu a vzorovou kapitolu (tón, délka, úroveň); šablona a limity jsou
zapsané tak, aby je test v K1 uměl vynutit.

### K1 – Model, parser, validace (týden 1–2)
Úkoly:
- `lib/book/model`: `Chapter`, `Page`, `Block` (sealed), `BoxKind`, `QuizQuestion`, `GlossaryTerm`.
  Čistý Dart, bez Flutter importů.
- `lib/book/parser`: Markdown → bloky přes balíček `markdown` (jen podmnožina: nadpisy, odstavce,
  tučné = heslo, obrázek, blockquote s tagem boxu `> [!doopravdy]`, oddělovač stránky `---`,
  kvíz jako YAML-like blok ve front matter). Vlastní rozšíření držet minimální a zdokumentované
  v `assets/book/README.md`.
- `BookRepository`: načte všechny kapitoly z `AssetManifest`, cache, pořadí podle `id`.
- Testy (`test/book/`): parser na vzorové kapitole; **validace obsahu** nad všemi soubory v
  `assets/book/cs/`: každá kapitola má hero a existuje jako soubor, každý `**tučný**` termín má heslo
  v `glossary.md`, každý odkazovaný obrázek existuje, honesty box přítomen, kvíz má 3 otázky s právě
  jednou správnou, limity slov dodrženy, žádný `TODO-FACT` v release režimu (test čte `BOOK_RELEASE`
  z `--dart-define`).
Acceptance: `flutter test` zelený na vzorové kapitole; validační test padá na záměrně rozbité fixtuře
(chybějící heslo, chybějící obrázek, 4 otázky).

### K2 – Čtečka (týden 2–3)
Úkoly:
- `pubspec.yaml`: `cute_kid_fonts` git dependency na tag; `KidTheme` kolem overlaye knihy, role podle
  scope §5; `book_theme.dart` = jediné místo s mapováním část → paleta.
- Overlay `book`: seznam kapitol (obálka = hero + název + razítko), čtečka (PageView, lišta, tečky,
  tlačítko zpět, přepínač velikosti písma A/A/A uložený v meta), bloky jako widgety, obrázky lazy
  (`Image.asset` s `cacheWidth`), placeholder obrázky (plochá barva + název) dokud není K4.
- Vstupy: tlačítko „KNIHA" v hlavním menu a v pauze; `game.openBook(chapterId)` pauzne hru a po
  zavření vrátí předchozí overlay (hud/pause/gameOver).
- Telefon na výšku, tablet, web; min. 16 sp body; žádný text v canvasu (vše Flutter widgety).
- Widget testy: otevření z menu, listování, návrat; golden test jedné stránky (světlé písmo na
  tmavé) s `cute_kid_fonts_testing` helperem.
Acceptance: na zařízení lze z menu otevřít knihu, přečíst kapitolu 5 se správnými fonty, změnit
velikost písma, zavřít a spustit run; z pauzy totéž a hra pokračuje tam, kde byla; `flutter analyze`
bez varování.

### K3 – Texty všech kapitol, slovníček, strana pro rodiče (týden 3–4)
Úkoly:
- Kapitoly 0–4, 6–12 podle osnovy z K0; každá s honesty boxem, „Věděl/a jsi", kvízem a hesly.
- `glossary.md`: definice všech hesel (1–2 věty, 12 let).
- `parents.md`: co kniha učí, kde zjednodušuje, kam dál; jediné místo s odkazy ven (otevření až po
  potvrzení „Otevřít v prohlížeči?").
- `sources.md` doplněn tak, že každý odstavec s faktem má zdroj (komentář `<!-- src: HB2015 s.41 -->`).
- Citlivá místa (očkování, sepse, autoimunita) podle scope §2 bod 5 a §8; formulace podle SZÚ/WHO.
- Seznam `TODO-FACT` pro garanta jako issue v repu.
Acceptance: validační test z K1 zelený na všech 13 souborech; počet slov v limitech; vlastník
odešle texty garantovi (mimo kód); čtenářský test se 3 dětmi může začít na placeholder obrázcích.

### K4 – Ilustrace z ComfyUI (týden 4–5, překrývá se s K3)
Úkoly:
- `art/book/manifest.json` + skript (`art/book/gen.py` nebo `.dart`): odešle workflow do ComfyUI
  (`POST /prompt`, `GET /history`, `GET /view`), stáhne, ořízne, převede na WebP (hero 768 px,
  schéma 512 px), zapíše řádek do `CREDITS.md`. Stylový blok a seed per obrázek v manifestu.
- Dva registry: *mikrofoto* (stejný stylový blok jako hra, plán grafiky §3.2, gradient map na paletu
  hry) a *schéma* (ploché, pastelové, v paletách CuteKidFonts, bez textu, bez šipek s popisky –
  popisky sází Flutter přes `Stack` s `BubbleText`).
- Pro každou kapitolu hero; schémata pro kapitoly 4, 5, 7, 8, 11, 12 (min. 6 ks). 3–4 varianty na
  obrázek, výběr vlastníkem.
- Kontrola každého výstupu okem: žádný text, měřítko ani popisek v obrázku; žádný anatomicky
  zavádějící tvar (protilátka má tvar Y, bakterie koky jsou kulaté, virus má obal).
- Licence: v manifestu u každého obrázku model + licence; povolené jen modely se seznamu v plánu
  grafiky §3.1 (flux-schnell, SDXL base) nebo jiné, jejichž licenci vlastník ověřil (OQ-2).
Acceptance: žádná kapitola bez hero; každý soubor v `assets/book/images/` má řádek v `CREDITS.md`
s modelem, licencí a seedem; test velikosti: součet `assets/book/` ≤ 12 MB; vizuální kontrola na
telefonu (čitelnost na 5" displeji).

### K5 – Propojení se hrou a razítka (týden 5)
Úkoly:
- `MetaProgress.seenChapters`, `lastChapter`, `bookFontScale`; migrace `fromMap` s defaulty; test.
- Deep-linky: ⓘ na kartách upgradu a místností, dlouhý stisk teploměru, „Co mě zabilo?" na
  game-over, „Co je paměťová buňka?" na obrazovce výhry. Mapování id → kapitola v `lib/ui/book/
  game_links.dart` (UI vrstva).
- Razítko „potkáno" se nastaví při otevření kapitoly přes deep-link **i** při prvním setkání ve hře
  (první tank, první horečka > 38 °C, první upgrade) – hra ukáže malou nenásilnou notu „Nová stránka
  v knize" (toast, 2 s, nelze kliknout během boje – jen informace).
- Žádné zamykání, žádný vliv na balance.
Acceptance: E2E ručně: smrt horečkou → „Co mě zabilo?" → kapitola 5 → zpět na game-over; po restartu
appky je razítko stále vidět; unit testy meta migrace.

### K6 – Zvuk (týden 5–6)
Úkoly:
- `tool/gen_sfx.dart`: rozšířit o `book_open`, `page_turn`, `book_close` (procedurální, CC0, stejný
  vzor jako dnes); `Sfx` konstanty, `AudioController.play`.
- Ambient smyčka `book_ambient.ogg` (≤ 1 MB, 30–60 s, bezešvá): zdroj podle OQ-4 (vlastní generování
  vs. CC0 knihovna); přehrávání přes `FlameAudio.bgm`, fade-in/out při otevření/zavření, respektuje
  `ZVUK: VYP`, pauza ambientu hry (pokud v budoucnu bude).
- Narace: pouze feature flag `Balance.bookNarrationEnabled = false` a prázdné místo v modelu (`audio:` pole
  ve front matter), nic víc (ADR 0005).
Acceptance: otevření knihy = SFX + fade-in ambientu; listování = SFX s throttlem; zavření = fade-out;
při vypnutém zvuku ticho; `audio_controller_test` rozšířen.

### K7 – Kvízy, polish, release checklist (týden 6)
Úkoly:
- `quiz_widget.dart`: 3 otázky, výběr, okamžitá odpověď s jednou větou vysvětlení, po dokončení
  razítko „Kvíz hotov" (cosmetic). Bez skóre napříč kapitolami (OQ-5).
- Slovníček: tap na tučné heslo → bublina (`glossary_popup.dart`), zavření tapem mimo.
- Polish: přechody stránek, hero paralax lehký (žádný shader), dark-only (kniha vždy nad tmavým).
- Release checklist: garant podepsal (žádný `TODO-FACT`), čtenářský test proběhl a zapsán do
  `open-questions.md`, velikost assetů, `flutter analyze/test`, screenshoty pro store (fáze 2).
Acceptance: kompletní průchod všech 12 kapitol s kvízy na telefonu a tabletu; všechny testy; vlastník
odsouhlasí build jako „fáze 1 hotová".

---

## 4. Fáze 2 (po fázi 1, jen osnova)

- Kapitoly 13 „Evoluce nepřátel: mutace a rezistence" a 14 „Když obrana selže: alergie, autoimunita,
  cytokinová bouře, sepse" – až budou mutace, Th polarizace a biomy 2–3 ve hře.
- Namluvení kapitol (lidský hlas nebo kvalitní český TTS, OQ-3) + zvýrazňování čteného odstavce.
- Anglická verze (`assets/book/en/`), výběr jazyka podle systému.
- Tisková verze: stejný Markdown → PDF (pandoc + šablona s fonty z CuteKidFonts) pro učitele.
- Pracovní list pro třídu (1 strana A4 na kapitolu) a mapování na konkrétní výstupy RVP.
- Hudba do menu hry ze stejného zdroje jako ambient knihy.

---

## 5. Průřezové požadavky (platí v každém milníku)

- **Testy**: čistý Dart (model, parser, progress) unit; validace obsahu nad reálnými assety; widget
  testy čtečky; golden test typografie přes `cute_kid_fonts_testing`. Milník není hotový bez testu
  acceptance scénáře.
- **Obsah mimo kód**: žádný text knihy v Dart souborech; vše v `assets/book/cs/`. UI copy čtečky
  (tlačítka) česky v kódu podle konvence hry.
- **Čistý Dart v `lib/book/model` a `parser`** – bez Flutter a Flame importů, jako `domain/`.
- **Žádné magic numbers**: velikosti, časy, limity v `balance.dart` (sekce `Book`) nebo ve front
  matter kapitoly.
- **Licence a kredity**: každý obrázek a zvuk má řádek v `assets/CREDITS.md` ještě ve stejném commitu,
  kde přibyl.
- **Velikost**: test v CI sečte `assets/book/` a padne nad 12 MB.
- **Soukromí**: žádná síť, žádná analytika, žádné externí odkazy mimo `parents.md`.
- **Přístupnost**: škálování písma, kontrast AA, cíle tapu ≥ 44 px.
- **Dokumentace**: ADR pro každé netriviální rozhodnutí; `assets/book/README.md` popisuje formát
  kapitoly pro autora bez znalosti Dartu.

---

## 6. Jak pracovat (instrukce pro Opus)

1. Postupuj po milnících v pořadí K0 → K7. Uvnitř milníku nejdřív čistý Dart (model, parser, testy),
   pak UI, pak propojení se hrou. K3 a K4 se překrývají; K4 nečekej na schválení textů.
2. Každý milník = větev `k<N>-<slug>` nad `main`, malé commity, na konci shrnutí s checklistem
   acceptance a výstupem `flutter analyze` + `flutter test`.
3. **Fakta neimprovizuj.** Co nemáš ve `sources.md`, označ `<!-- TODO-FACT: … -->` a pokračuj.
   Nikdy nevymýšlej čísla (teploty, procenta, počty buněk) – buď zdroj, nebo TODO-FACT. Kde hra
   lže, napiš to do honesty boxu, ne do hlavního textu jako pravdu.
4. **Citlivá témata** (očkování, nemoci, smrt pacienta): věcně, bez strašení, formulace podle SZÚ/WHO;
   když si nejsi jistý tónem, vypiš dvě varianty do `open-questions.md` a použij tu opatrnější.
5. Nikdy nezamykej obsah hraním, nepřidávej odměny za kvíz ani vliv knihy na balance. Pokud úkol
   vypadá, že to vyžaduje, zastav se a zeptej.
6. Fonty jen přes `cute_kid_fonts`; pokud role chybí, navrhni změnu v CuteKidFonts (samostatné repo),
   neobcházej balíček lokálním stylem.
7. Obrázky generuj jen z manifestu, s modelem a licencí u každého; výstup s textem nebo popiskem
   zahoď. Nikdy nevkládej obrázek bez řádku v `CREDITS.md`.
8. Hra zůstává hratelná v každém commitu; overlay knihy nesmí rozbít pauzu, modální volby ani restart
   (vzor commit `f217798`).
9. Otázky, které nejde rozhodnout ze scope a tohoto plánu, zapiš do `open-questions.md` s navrženou
   odpovědí a pokračuj podle návrhu, pokud to není nevratné.
10. Před označením milníku za hotový spusť `flutter analyze`, `flutter test` a na zařízení ověř
    scénář z acceptance; přilož výstup.

---

## 7. Co je třeba zařídit mimo kód (vlastník)

| Co | K čemu | Kdy |
|---|---|---|
| Odborný garant (imunolog / učitel přírodopisu 2. stupně) | schválení textů, uzavření `TODO-FACT` | po K3, před K7 |
| 2–3 dětští čtenáři 10–15 let (+ souhlas rodičů) | čtenářský test, kvíz bez pomoci | po K3 (placeholder obrázky stačí) |
| ComfyUI: seznam modelů a jejich licence (OQ-2) | K4 nesmí použít non-commercial model | před K4 |
| Zdroj ambientu (vlastní / CC0) a rozhodnutí o hudbě v menu (OQ-4) | K6 | před K6 |
| Rozhodnutí o názvu knihy (OQ-1) | obálka, tlačítko v menu | před K2 |
| Store politika pro děti (Families / Kids, OQ-8) | ovlivňuje celou appku, ne jen knihu | před vydáním |
| Český překlad *Immune* (Dettmer) k ruce | kontrola tónu a vzor pro K3 | K0 |
