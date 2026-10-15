# ADR 0001: Jeden registr pojmů hry (`domain/lore.dart`) pro hru i knihu

- Status: accepted (2026-10-15)
- Context: 01-scope.md, sekce 2, 3 a 9 (rozhodnutí 1).

## Rozhodnutí

Každý herní koncept s biologickým předobrazem má právě jeden záznam `LoreEntry` v čistě dartovém
registru `domain/lore.dart`: id, druh, stav (`live|planned|retired`), český název, věta „ve hře",
volitelná věta „doopravdy", odkaz na kapitolu a kotvu v knize, odkaz na hodnotu enumu v kódu a zdroj.

Hra čte české názvy a popisy (karty upgradů, game-over, HUD zóny horečky) z registru. Kniha čte
odkazy a věty z registru a test ověřuje, že kapitoly a registr sedí oběma směry.

Zvažované alternativy:
- **Kniha si vede vlastní seznam** – dvě pravdy, rozejdou se při první změně hry.
- **Anotace přímo u enumů** (`UpgradeDef.chapter`) – roztroušené po pěti souborech, zóny horečky
  a meta nemají enum, a kniha by musela importovat půl domény.
- **Registr v JSON assetu** – mimo typový systém, test úplnosti nad enumy by byl křehký.

## Důsledky

- `UpgradeDef.nameCz/descCz` a `killedByLabelCz` se stanou pohledy do registru; žádná kopie.
- Přidání hodnoty do `UpgradeId`, `EnemyType`, `StatusEffect` (aktivní), `DamageType`, `RoomType`
  bez záznamu shodí `lore_registry_test`.
- Registr je zároveň mapa „co hra učí" pro garanta a pro `lore_report`.
