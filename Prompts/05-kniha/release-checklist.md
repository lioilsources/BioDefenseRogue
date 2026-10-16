# Lexikon zdraví – release checklist (K7)

Fáze 1 je hotová, až je zaškrtnuto všechno. Stav k 2026-10-16.

## Obsah a pravdivost
- [ ] Garant (imunolog nebo učitel přírodopisu) prošel všech 13 kapitol, slovníček a stranu pro rodiče
  (`garant-todo-fact.md`, render: `flutter test tool/lore_report.dart --dart-define=LORE_RENDER=out/`).
- [ ] Žádný `TODO-FACT`: `flutter test --dart-define=BOOK_RELEASE=true` je zelený.
- [ ] Kapitola 12 (očkování) schválena jako první (OQ-10, OQ-21).
- [ ] Rozhodnuto o `lie: large` (`03-mechaniky-z-biologie.md` §3).

## Čtenáři
- [ ] Čtenářský test se 3 dětmi 10–15 let (souhlas rodičů); kvíz bez pomoci ≥ 2/3 správně.
  Výsledky (jen věk, výsledek, poznámky) zapsány v `open-questions.md`.

## Obrázky a zvuk
- [ ] K4: 13 hero + 6 schémat vygenerováno, vybráno, `gen.py install` (OQ-28: termín 18. 10.).
- [ ] Licence flux-schnell ověřena (`license_verified: true` v manifestu, OQ-2).
- [ ] Každý obrázek bez textu a anatomicky v pořádku (kontrola okem).
- [ ] `assets/book` ≤ 12 MB (test).
- [ ] Poslech ambientu na telefonu: smyčka bez cvaknutí (OQ-27).

## Na zařízení
- [ ] Kompletní průchod všech 13 kapitol s kvízy na telefonu (5") a tabletu.
- [ ] Deep-linky: smrt horečkou → „CO MĚ ZABILO?“ → kapitola 5 → zpět na game-over;
  ⓘ na kartě; dlouhý stisk teploměru; výhra → paměťové buňky.
- [ ] Razítka: první tank → toast po vyčištění → razítko u kapitoly 3; po restartu appky zůstává.
- [ ] Velikost písma A/A/A zůstane po restartu; kontrast a čitelnost při největším písmu.
- [ ] Zvuk: ZVUK: VYP = ticho i v knize.

## Technika
- [ ] `flutter analyze --fatal-infos` a `flutter test` zelené, `lore_report` 100 % pro live pojmy.
- [ ] Odkazy ze strany pro rodiče: otevření s potvrzením (OQ-29).
- [ ] Screenshoty pro store (fáze 2).
