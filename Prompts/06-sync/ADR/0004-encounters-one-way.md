# ADR 0004: Hra posílá knize jen události setkání; nic zpět

- Status: accepted (2026-10-15)
- Context: 01-scope.md, sekce 3, 6 a 9 (rozhodnutí 4 a 6); 05-kniha ADR 0002.

## Rozhodnutí

Jediný tok ze hry do knihy je `LoreEncounters.report(id)`: idempotentní zápis „hráč poprvé potkal
pojem" do `MetaProgress.seenLore`. Kniha z něj kreslí razítka (per záznam; kapitola je potkaná,
když má aspoň jeden potkaný záznam) a hra ukáže neklikatelný toast mimo boj.

Z knihy do hry neteče nic: žádné odemykání, žádná odměna za kvíz, žádný vliv na balance.

## Proč

- Razítko odpovídá na „kde si o tom přečtu?" přesně v momentě, kdy otázka vznikla.
- Obousměrná vazba by z knihy udělala herní systém, který by se musel balancovat a testovat jako
  gameplay; výuková hodnota by se ztratila v optimalizaci odměn.

## Důsledky

- `LoreEncounters` je čistý Dart s O(1) voláním, bezpečný v game loopu.
- `MetaProgress` roste o `seenLore`, `lastChapter`, `bookFontScale`; migrace s defaulty.
- Nahrazuje K5 z plánu knihy (deep-linky zůstávají, razítka jsou per záznam).
