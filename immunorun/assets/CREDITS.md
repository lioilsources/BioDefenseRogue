# Asset Credits

Každý vizuální soubor v assets/images/ musí mít záznam níže.
Formát: název souboru | zdroj | licence | autor

## Aktuálně (F0 placeholder)
- Žádné externí snímky zatím — vše generováno procedurálně.

## Ikona aplikace
- ios/…/AppIcon.appiconset, android/…/mipmap-*/ic_launcher.png, macos/…/AppIcon.appiconset, web/icons, web/favicon.png
  | art/drafts/g0 sprite_macrophage_color_s2104 (makrofág ve stylu SEM), ořez na buňku | flux-schnell, Apache-2.0 | vygenerováno, vlastní výběr

## Audio
- assets/audio/*.wav | generováno procedurálně (tool/gen_sfx.dart) | CC0 | vlastní
  (placeholder SFX — lze nahradit 1:1 reálnými zvuky se stejnými názvy)
- assets/audio/book_open.wav, page_turn.wav, book_close.wav | generováno procedurálně
  (tool/gen_sfx.dart) | CC0 | vlastní — zvuky knihy Lexikon zdraví
- assets/audio/book_ambient.m4a | generováno procedurálně (tool/gen_sfx.dart, pad 32 s,
  AAC přes ffmpeg) | CC0 | vlastní — ambient knihy (05-kniha OQ-4)

## Plánované zdroje (viz plán §3.1)
- NIAID Flickr — CC BY 2.0 — credit "Courtesy: NIAID"
- CDC PHIL — public domain — credit "CDC PHIL #XXXXX"
- NIH BioArt Source — public domain — credit "NIH BioArt"

## Kniha (Lexikon zdraví)
Generováno z art/book/manifest.json (art/book/gen.py). Formát: soubor | model, seed, registr | licence | prompt
- assets/book/images/00-mikroskop-hero.webp | flux-schnell (NIM), seed 2000, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/01-telo-jako-hrad-hero.webp | flux-schnell (NIM), seed 2011, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/02-bile-krvinky-hero.webp | flux-schnell (NIM), seed 2022, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/03-nepratele-hero.webp | flux-schnell (NIM), seed 2030, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/04-fagocytoza-hero.webp | flux-schnell (NIM), seed 2042, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/04-fagocytoza-schema-1.webp | flux-schnell (NIM), seed 2051, schema | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/05-horecka-hero.webp | flux-schnell (NIM), seed 2060, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/05-horecka-schema-1.webp | flux-schnell (NIM), seed 2072, schema | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/06-zanet-a-histamin-hero.webp | flux-schnell (NIM), seed 2082, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/07-cytokiny-hero.webp | flux-schnell (NIM), seed 2093, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/07-cytokiny-schema-1.webp | flux-schnell (NIM), seed 2100, schema | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/08-protilatky-hero.webp | flux-schnell (NIM), seed 2110, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/08-protilatky-schema-1.webp | flux-schnell (NIM), seed 2121, schema | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/09-energie-bunky-hero.webp | flux-schnell (NIM), seed 2130, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/10-zabijacke-bunky-hero.webp | flux-schnell (NIM), seed 2141, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/11-lymfaticka-uzlina-hero.webp | flux-schnell (NIM), seed 2152, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/11-lymfaticka-uzlina-schema-1.webp | flux-schnell (NIM), seed 2160, schema | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/12-pamet-a-ockovani-hero.webp | flux-schnell (NIM), seed 2171, mikrofoto | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
- assets/book/images/12-pamet-a-ockovani-schema-1.webp | flux-schnell (NIM), seed 2183, schema | Apache-2.0 (licence neověřena, 05-kniha OQ-2) | prompt v art/book/manifest.json
