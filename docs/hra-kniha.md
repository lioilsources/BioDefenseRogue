# Hra ↔ kniha (Lexikon zdraví)

Plán: `Prompts/05-kniha/` (kniha) a `Prompts/06-sync/` (synchronizace). Cesty `lib/`, `assets/` a `tool/`
jsou relativně k `immunorun/`. Pravidla:

- **Jeden zdroj.** Český název, věta „ve hře“ a „doopravdy“ každého herního pojmu žijí jen
  v `lib/domain/lore.dart`. UI je čte z registru (`lore.byRef(...)`), nikdy je nekopíruje.
- **Nový herní pojem začíná záznamem v `lore.dart`** (nejdřív `realityCz`, pak mechanika, pak kód,
  `Prompts/06-sync/03-mechaniky-z-biologie.md`). Nová hodnota enumu bez záznamu shodí `lore_registry_test`.
- **Žádná čísla v textech.** Registr, karty i kapitoly používají `{{balance.<konstanta>|<formát>}}`
  (pct, pctDelta, pctLess, s, degC, int) a `{{lore.<id>}}` pro názvy karet. Po změně názvů
  v `balance.dart`: `dart run tool/gen_balance_map.dart` (CI gen-check).
- **Kapitoly** jsou Markdown v `assets/book/cs/` podle `Prompts/05-kniha/03-redakcni-standard.md`.
  Každá uvádí své pojmy v `lore:` a má jejich kotvy. Kde hra lže, kapitola má box `[!doopravdy]`.
  Tvrzení o těle mají `<!-- src: KLÍČ … -->` nebo `<!-- TODO-FACT: KLÍČ – … -->` (klíče
  v `Prompts/05-kniha/sources.md`). Release (`--dart-define=BOOK_RELEASE=true`) nesmí mít TODO-FACT.
- **Hra → kniha jen přes `LoreEncounters`** (razítka). Kniha, kvíz ani razítka nemají vliv
  na gameplay, balance ani odemykání.
- Kontrola: `flutter test` (validace, BookSync, registr), report pokrytí
  `flutter test tool/lore_report.dart` (`--dart-define=LORE_RENDER=out/` vyrenderuje kapitoly
  pro garanta). Změna kapitoly → řádek v `assets/book/CHANGELOG.md`.
