# ADR 0002: Nic se neodemyká hraním; hra jen razítkuje

- Status: accepted (2026-10-15)
- Context: 01-scope.md, sekce 5, 6 (F5, F6) a 11 (rozhodnutí 2 a 7).

## Rozhodnutí

Všechny kapitoly, slovníček i kvízy jsou dostupné od prvního spuštění. Hra si do `MetaProgress`
ukládá, které kapitoly dítě potkalo (otevřelo přes deep-link, nebo poprvé narazilo na motiv:
první tank, první horečka nad 38 °C, první upgrade) a čtečka to ukazuje razítkem na obálce.

Kvíz nemá žádný vliv na hru: žádné paměťové buňky, HP, ATP ani odemčení. Odměna je jen razítko
„Kvíz hotov".

## Proč

- Kniha je výuková; zamčená kapitola o očkování je horší než žádná.
- Codex odemykaný hraním (UX doc §2) dává smysl pro lore, ne pro učivo 8. třídy.
- Odměna za kvíz by vedla k proklikávání odpovědí místo čtení.

## Důsledky

- `MetaProgress` dostane `seenChapters` a `lastChapter`; migrace s defaulty, žádné nové závislosti.
- Žádná změna v `balance.dart` kvůli knize, kromě sekce `Book` s velikostmi a časy UI.
- Pokud se v budoucnu objeví lore Codex (mutace, bossové), bude to jiná sekce s jinými pravidly, ne
  tato kniha.
