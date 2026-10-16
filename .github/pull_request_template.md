## Co a proč

<!-- 1–3 věty -->

## Hra ↔ kniha (06-sync)

Mění PR něco v `immunorun/lib/domain/` nebo v `config/balance.dart`?

- [ ] ne, nic z toho
- [ ] ano a:
  - [ ] nový herní pojem má záznam v `lib/domain/lore.dart` (název, věta „ve hře“, `realityCz` tam, kde hra lže, kapitola a kotva)
  - [ ] kapitola knihy ho uvádí v `lore:` a má kotvu (nebo je záznam `planned`)
  - [ ] čísla v textech jsou placeholdery `{{balance.…|…}}`, ne natvrdo
  - [ ] po změně názvů v `balance.dart`: `dart run tool/gen_balance_map.dart`
  - [ ] přibyl pojem → přiložen výstup `flutter test tool/lore_report.dart`

## Kniha (05-kniha)

- [ ] změna kapitoly → řádek v `immunorun/assets/book/CHANGELOG.md`
- [ ] nové tvrzení o těle má `src` nebo `TODO-FACT` s klíčem ze `Prompts/05-kniha/sources.md`
- [ ] nový obrázek nebo zvuk má řádek v `immunorun/assets/CREDITS.md`

## Ověření

```
flutter analyze --fatal-infos
flutter test
```
