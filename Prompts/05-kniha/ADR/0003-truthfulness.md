# ADR 0003: Pravdivost – honesty box, zdroje, garant

- Status: accepted (2026-10-15)
- Context: 01-scope.md, sekce 2, 8 a 11 (rozhodnutí 3).

## Rozhodnutí

1. Každá kapitola má box **„Jak je to doopravdy"**, který pojmenuje, kde hra zjednodušuje nebo
   se od biologie odchyluje (např. horečka nezrychluje útok; makrofág nestřílí; ATP se nesbírá
   z mrtvých bakterií; očkování nedává procenta poškození).
2. Každé faktické tvrzení má zdroj v `Prompts/05-kniha/sources.md` (komentář `<!-- src: … -->`
   v Markdownu). Tvrzení bez zdroje se označí `<!-- TODO-FACT: … -->`. Release build (validační test
   s `--dart-define=BOOK_RELEASE=true`) nesmí obsahovat žádný `TODO-FACT`.
3. Texty schvaluje **odborný garant** (imunolog nebo učitel přírodopisu 2. stupně) mimo kód, před
   milníkem K7. Model (Opus) texty navrhuje; nikdy není posledním slovem o faktu.
4. Jedna základní čtenářská úroveň (≈ 12 let); hlubší vrstva jen v boxech „Pro zvědavé". Citlivá
   témata (očkování, nemoc, smrt pacienta) věcně, bez strašení, formulace podle SZÚ / MZ ČR / WHO.

## Proč

Dětská populárně naučná kniha, která tvrdí, že horečka zrychluje ruce, je horší než hra bez knihy.
Odborně správná a zároveň srozumitelná pro 12leté je právě ten náročný cíl zadání.

## Důsledky

- Validační test v K1 kontroluje přítomnost honesty boxu a nepřítomnost `TODO-FACT` v release.
- `sources.md` je součást repa a PR recenze; změna faktu bez změny zdroje je nález v review.
- Garant a dětští čtenáři jsou položky v plánu (02-plan.md §7), ne „později".
