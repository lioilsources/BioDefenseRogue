# ADR 0003: Sync test je brána CI na každém pull requestu

- Status: accepted (2026-10-15)
- Context: 01-scope.md, sekce 3 a 9 (rozhodnutí 3); repo dnes má jen release workflow na tag.

## Rozhodnutí

Vznikne `.github/workflows/ci.yml` (pull request + push na `main`): `flutter analyze`,
`flutter test`, gen-check generovaných souborů, velikost assetů. `main` je chráněn vyžadováním
tohoto workflow.

Součástí `flutter test` jsou sync testy s negativními fixturami:
- úplnost registru nad enumy,
- záznam ↔ kapitola ↔ kotva oběma směry,
- honesty box tam, kde je `realityCz`,
- renderovatelnost všech placeholderů,
- žádný `planned` záznam s textem a žádný `TODO-FACT` v `BOOK_RELEASE`,
- přechod `planned → live`, když enum hodnota přibude v kódu.

## Proč

Synchronizace, kterou nehlídá stroj, vydrží do prvního spěchu. Test, který nemá negativní fixturu,
nic nehlídá.

## Důsledky

- První milník (S0) je CI; ostatní milníky na něm stojí.
- PR, který přidá pojem do hry, je červený, dokud nemá záznam a kapitolu (nebo `planned` pahýl).
- Doba CI < 6 min je požadavek, ne přání; jinak se brána začne obcházet.
