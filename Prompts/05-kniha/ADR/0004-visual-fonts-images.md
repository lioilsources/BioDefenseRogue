# ADR 0004: Vizuál – CuteKidFonts role, dva obrazové registry, licence modelů

- Status: accepted (2026-10-15)
- Context: 01-scope.md, sekce 5, 8 a 11 (rozhodnutí 4); `Prompts/04-PLAN-grafika.md` §1, §3, §6.

## Rozhodnutí

**Typografie.** Veškerý text knihy jde přes `cute_kid_fonts` (git dependency na tag ≥ v0.2.1):
`title` pro názvy kapitol, `upper` pro části, `body` pro odstavce, `dialog` pro boxy, `number` pro
čísla stran a teploty. Paleta per část knihy (mint, sky, peach, lavender) z `KidPalette`; žádné
hex barvy ani fonty mimo balíček v `lib/ui/book/`. Chybějící role se doplní v CuteKidFonts, ne lokálně.

**Obrázky.** Dva registry, oba z ComfyUI vlastníka, reprodukovatelné z `art/book/manifest.json`:
- *mikrofoto* – falešně kolorovaná SEM, stejný stylový blok a paleta jako hra (plán grafiky §1),
  aby dítě poznalo „to je ten tank ze hry";
- *schéma* – ploché, pastelové, v paletách CuteKidFonts, pro mechanismy (fagocytóza, protilátka na
  antigenu, zánět). Bez textu, šipek s popisky a měřítek; popisky sází Flutter.

**Licence.** Jen modely s licencí vhodnou pro komerční appku (flux-schnell Apache-2.0, SDXL base
OpenRAIL++-M, nebo jiné po ověření vlastníkem). flux dev / Kontext / Fill a neověřené komunitní
checkpointy se nepoužívají. Každý soubor má řádek v `assets/CREDITS.md` s modelem, licencí a seedem.

## Proč

- Jedna typografie napříč dětskými appkami je důvod, proč CuteKidFonts existuje.
- Dva registry řeší napětí „věrné SEM" × „srozumitelné schéma": SEM ukazuje, jak to vypadá, schéma,
  jak to funguje.
- Text v generovaných obrázcích je nejčastější vada (plán grafiky §3.2) a v dětské knize nejhorší.

## Důsledky

- `pubspec.yaml` přidá git dependency; CI musí umět klonovat GitHub.
- Rozpočet velikosti assetů knihy 12 MB (WebP, hero 768 px, schéma 512 px), hlídaný testem.
- Grafický plán hry a kniha sdílejí stylový blok; změna palety hry se promítne do mikrofoto registru.
