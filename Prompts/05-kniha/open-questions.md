# Otevřené otázky – Lexikon zdraví

Otázky, které scope a plán nerozhodují. Každá má navrženou odpověď; implementace se jí drží, dokud
vlastník nerozhodne jinak.

## Před K2

- **OQ-1 Název knihy – rozhodnuto vlastníkem 2026-10-16: *Lexikon zdraví*.** Pravopis
  potvrzen (velké jen první písmeno, s diakritikou). Dokumenty v `05-kniha/` a `06-sync/` jsou
  přejmenované. Otevřený zůstává jen popisek tlačítka v menu: návrh „LEXIKON“ (rozhodnout před K2).
- **OQ-6 Jedna, nebo dvě čtenářské úrovně?** Návrh: jedna (≈ 12 let) + boxy „Pro zvědavé" pro
  13–15. Dvě paralelní verze textu by zdvojnásobily práci garanta.

## Z K0 (2026-10-16)

- **OQ-11 Front matter jako YAML.** K1 předpokládá „YAML-like blok“. Návrh: skutečný YAML přes
  balíček `yaml` (čistý Dart, od týmu Dartu). Vlastní parser kvízu by byl další formát k údržbě.
  Standard §2 a vzorová kapitola už YAML používají.
- **OQ-12 Desetinná čárka. (S2: hotovo)** Karty upgradu dnes ukazují `0.15 °C/s` s tečkou (text z S1, beze
  změny). Návrh: render placeholderů v S2 píše česky (`0,15`) a karty tím přejdou na čárku
  samy. Tuhle viditelnou změnu textu udělá S2 záměrně.
- **OQ-13 `game_refs` → `lore`.** Plán K0 jmenuje pole `game_refs`, plán synchronizace
  (06-sync scope §4) `lore:` s id registru. Návrh: jen `lore`, protože registr už kryje enumy
  i pojmy bez enumu. Standard §2.
- **OQ-14 Názvy pojmů v kapitolách. (S2: hotovo, `{{lore.<id>}}`, 06-sync OQ-19)** Kapitola píše „karta Pyrogen (IL-6)“ natvrdo. Když se
  název v registru změní, kapitola zastará. Návrh pro S2: placeholder `{{lore.<id>}}` → `nameCz`
  a sync test, který natvrdo psaný název z registru v kapitole najde a ohlásí. Do té doby natvrdo.
- **OQ-15 Praktický box u horečky: kdy k lékaři.** Varianta A (použita, opatrnější): bez čísel,
  „Když se ti hůř dýchá nebo je ti čím dál hůř, dospělý zavolá lékaře.“ Varianta B: konkrétní
  hranice (teplota, počet dní, věk) podle doporučení ČPS. B je užitečnější pro rodiče, ale
  čísla v dětském textu svádějí k tomu, aby dítě rozhodovalo samo. Návrh: A v kapitole, B na
  straně pro rodiče. Rozhodne garant.
- **OQ-16 Název zóny „Zvýšená teplota“ v registru. (S2: přejmenováno na „Mírná horečka“)** Febrilní zóna hry začíná na
  `Balance.feverFebrilStart` (dnes 38 °C). V češtině ale lékaři „zvýšenou teplotou“ myslí
  37–38 °C a od 38 °C mluví o horečce. Kapitola 5 to tak píše. Návrh pro S2: přejmenovat
  `fever.febrile` na „Mírná horečka“ (HUD název zóny zatím nezobrazuje, 06-sync OQ-14, změna
  je levná).
- **OQ-17 Kapitola v assetech před K1.** `assets/book/cs/05-horecka.md` vzniká v K0, ale
  `pubspec.yaml` ji zaregistruje až K1/K2. Návrh: nechat, soubor je na finálním místě a parser
  v K1 ho rovnou použije jako testovací vstup. Do appky se zatím nebalí.
- **OQ-18 Číslo kapitoly v textu.** Vzorová kapitola odkazuje „O nich je kapitola 7.“ Když se
  pořadí změní, odkaz zastará. Návrh pro K1: odkaz `[[07-cytokiny]]` → čtečka vysází název
  a test ověří, že kapitola existuje. Do té doby natvrdo.

- **OQ-19 Existence obrázků před K4.** K1 má hlídat, že odkazovaný obrázek existuje, ale obrázky
  přijdou až v K4 (do té doby placeholder ve čtečce, K2). Návrh: validátor kontroluje existenci,
  jakmile existuje složka `assets/book/images/`, a v `BOOK_RELEASE` vždy. Jména souborů
  (`<id>-hero.webp`, `<id>-schema-<n>.webp`) a popisky hlídá vždy. Po K4 se podmínka
  „když složka existuje“ změní na „vždy“.
- **OQ-20 Lock soubor a lokální Flutter.** Lokální SDK (3.44.4) při `pub get` snižuje verze v
  `pubspec.lock` (meta 1.19 → 1.18 atd.). Návrh: lock udržovat podle CI (stable); nové balíčky
  (`markdown`, `yaml` v K1) přidány do locku ručně bez změny ostatních verzí, CI gen-check
  (`git diff --exit-code` po `pub get`) ověří, že je lock konzistentní.

## Před K4

- **OQ-2 Modely v ComfyUI vlastníka a jejich licence.** Plán grafiky §3.1 uvádí flux-schnell
  (Apache-2.0) a SDXL base (OpenRAIL++-M) jako bezpečné, flux dev / Kontext / Fill jako
  non-commercial. Návrh: vlastník vypíše do `art/book/manifest.json` sekci `models` s licencí;
  skript odmítne generovat modelem mimo seznam.
- **OQ-9 Styl schémat.** Ploché pastelové ilustrace mohou vyjít z modelu nekonzistentně. Návrh:
  zkouška v K4 na dvou schématech (fagocytóza, protilátka); pokud styl nedrží, schémata jako
  ručně kreslené SVG (Flutter `CustomPainter` nebo `flutter_svg`) v paletách CuteKidFonts.

## Před K6

- **OQ-3 Narace (fáze 2): lidský hlas, nebo český TTS?** Návrh: fáze 2, nejdřív test jedné
  kapitoly s kvalitním TTS; pokud dětští čtenáři nepoznají rozdíl od hlasu, TTS, jinak nahrávka.
- **OQ-4 Zdroj ambientu.** Návrh: vlastní generování (procedurální pad v `gen_sfx.dart` nebo
  AI hudební model s komerční licencí); fallback CC0 knihovna s řádkem v `CREDITS.md`. Stejná smyčka
  jde pak i do menu hry.

## Před K7

- **OQ-5 Kvíz a hra.** ADR 0002 říká: žádný vliv. Otázka zůstává, zda ukázat souhrn „kvízy 7/12"
  v menu. Návrh: ano, jen jako razítka na obálkách, bez čísla v hlavním menu.
- **OQ-7 Dyslexie.** Návrh: fáze 1 jen škálování písma a řádkování 1,5; přepínač na font pro
  dyslektiky (OpenDyslexic, OFL) zvážit v CuteKidFonts jako roli, ne v appce.
- **OQ-8 Store politika pro děti.** Pokud appka cílí na 10–15, Google Play Families a Apple Kids
  kategorie mají požadavky na celou appku (žádná reklama, žádné sledování). Návrh: rozhodnout před
  vydáním fáze 1; kniha sama nic neměří, takže ji to neblokuje.
- **OQ-10 Formulace o očkování.** Věcně podle SZÚ/MZ ČR/WHO; bez polemiky; strana pro rodiče odkazuje
  na SZÚ. Návrh: garant dostane kapitolu 12 jako první a s nejvyšší prioritou.

## Zapsané výsledky testů čtenářů

(doplní se po K3 – jméno-věk-datum nesmí být v repu; jen věk, výsledek kvízu a poznámky)
