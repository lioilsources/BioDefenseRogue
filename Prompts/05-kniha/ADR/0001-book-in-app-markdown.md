# ADR 0001: Kniha je overlay ve hře, obsah je Markdown v assetech

- Status: accepted (2026-10-15)
- Context: 01-scope.md, sekce 5 a 11 (rozhodnutí 1).

## Rozhodnutí

Kniha není samostatná appka ani PDF. Je to Flutter overlay `book` v `immunorun/`, vedle `mainMenu`
a `pause`, otevíraný z menu, z pauzy a deep-linky ze hry.

Obsah (kapitoly, slovníček, strana pro rodiče) žije v `assets/book/cs/*.md` jako Markdown s
front matter. Parser (balíček `markdown`) ho převede na čistě dartový blokový model
(`lib/book/model`), který renderují vlastní widgety. Podporovaná podmnožina Markdownu je malá a
popsaná v `assets/book/README.md`.

Zvažované alternativy:
- **Text jako Dart konstanty** – typově bezpečné, ale dlouhé české texty v Dartu se špatně píší a
  recenzují; garant bez Dartu by je neuměl číst.
- **HTML / WebView** – jiná typografie než zbytek appky, CuteKidFonts by nešly použít, offline a
  velikost horší.
- **Samostatná appka** – dvojí údržba, dítě by ji neotevřelo; deep-linky ze hry by nefungovaly.

## Důsledky

- Autor i garant pracují s `.md` soubory; recenze jde přes diff v PR.
- Testy validují obsah (hesla, obrázky, limity, kvíz) nad skutečnými assety, ne nad fixturami.
- Stejný Markdown je ve fázi 2 zdroj pro tiskové PDF a pro anglickou verzi (`assets/book/en/`).
- Model a parser jsou bez Flutter importů (stejný princip jako `domain/`).
