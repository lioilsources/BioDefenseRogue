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

## Ikony buněk a patogenů
Generováno podle art/icons/manifest.json (L40S, ComfyUI). Formát: soubor | model, seed | licence | prompt
- assets/images/icons/makrofag.webp | Qwen-Image fp8, seed 3000; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/neutrofil.webp | Qwen-Image fp8, seed 3012; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/nk-bunka.webp | Qwen-Image fp8, seed 3030; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/dendriticka-bunka.webp | Qwen-Image fp8, seed 3030; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/zirna-bunka.webp | Qwen-Image fp8, seed 3042; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/b-bunka.webp | Qwen-Image fp8, seed 3060; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/t-bunka.webp | Qwen-Image fp8, seed 3068; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/cytotoxicka-t-bunka.webp | Qwen-Image fp8, seed 3078; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/treg.webp | Qwen-Image fp8, seed 3088; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/pametova-bunka.webp | Qwen-Image fp8, seed 3099; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/eozinofil.webp | Qwen-Image fp8, seed 3103; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/kok.webp | Qwen-Image fp8, seed 3115; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/stafylokok.webp | Qwen-Image fp8, seed 3120; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/stafylokok-faze2.webp | Qwen-Image fp8, seed 3133; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/biofilm.webp | Qwen-Image fp8, seed 3143; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/tycinka-mikrobiom.webp | Qwen-Image fp8, seed 3150; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/virus-chripka.webp | Qwen-Image fp8, seed 3162; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/aspergillus.webp | Qwen-Image fp8, seed 3175; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/opsonizace.webp | Qwen-Image fp8, seed 3190; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/cervena-krvinka.webp | Qwen-Image fp8, seed 3191; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
- assets/images/icons/mitochondrie.webp | Qwen-Image fp8, seed 3202; výřez BiRefNet | Apache-2.0 (Qwen/Qwen-Image, Qwen2.5-VL); výřez BiRefNet ZhengPeng7/BiRefNet MIT, revize e2bf8e4460fc8fa32bba5ea4d94b3233d367b0e4 | prompt v art/icons/manifest.json
