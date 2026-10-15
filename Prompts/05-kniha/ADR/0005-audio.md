# ADR 0005: Zvuk – SFX a ambient ve fázi 1, narace ve fázi 2 za flagem

- Status: accepted (2026-10-15)
- Context: 01-scope.md, sekce 5, 6 (F8) a 11 (rozhodnutí 5).

## Rozhodnutí

Fáze 1: tři SFX (otevření knihy, otočení stránky, zavření) generované stejně jako dnešní placeholder
SFX (`tool/gen_sfx.dart`, CC0) a jedna bezešvá ambient smyčka (≤ 1 MB, `FlameAudio.bgm`, fade
in/out), vše pod stávajícím přepínačem `ZVUK`.

Narace kapitol se ve fázi 1 **neimplementuje**. Zůstane jen feature flag
`Balance.bookNarrationEnabled = false` a volitelné pole `audio:` ve front matter, aby šla doplnit
bez změny modelu.

## Proč

- Zvuk knihy je levný a zvedá pocit „otevřel jsem knihu"; narace je drahá (lidský hlas 12 kapitol)
  nebo riskantní na kvalitu (český TTS) a rozhodnutí patří vlastníkovi (OQ-3).
- Hra dnes nemá hudbu vůbec; ambient knihy je první zdroj a může se později sdílet s menu.

## Důsledky

- `Sfx` konstanty a `AudioController` se rozšíří, `audio_controller_test` také.
- Zdroj ambientu (vlastní generování vs. CC0 knihovna) rozhodne vlastník před K6 (OQ-4); soubor má
  řádek v `CREDITS.md`.
- Fáze 2 narace: zvýraznění čteného odstavce, autoplay přepínač, soubory per kapitola (OGG).
