# Otevřené otázky – Kniha imunity

Otázky, které scope a plán nerozhodují. Každá má navrženou odpověď; implementace se jí drží, dokud
vlastník nerozhodne jinak.

## Před K2

- **OQ-1 Název knihy – pracovní název určen vlastníkem 2026-10-15: *Lexikon zdraví*.** Dřívější
  návrh „Kniha imunity" a alternativy („Atlas obránce", „Příručka makrofága", „Co se děje uvnitř")
  padají. Otevřené zůstává: popisek tlačítka v menu (návrh „LEXIKON") a pravopis – vlastník
  napsal „Lexikon Zdravi"; navrhuji „Lexikon zdraví" (velké jen první písmeno, s diakritikou).
  Název je jen text v `assets/book/cs/`, změna je levná; dokumenty v `05-kniha/` a `06-sync/`
  zatím říkají „Kniha imunity" – přejmenují se, až bude název finální.
- **OQ-6 Jedna, nebo dvě čtenářské úrovně?** Návrh: jedna (≈ 12 let) + boxy „Pro zvědavé" pro
  13–15. Dvě paralelní verze textu by zdvojnásobily práci garanta.

## Před K4

- **OQ-2 Modely v ComfyUI vlastníka a jejich licence.** Plán grafiky §3.1 uvádí flux-schnell
  (Apache-2.0) a SDXL base (OpenRAIL++-M) jako bezpečné, flux dev / Kontext / Fill jako
  non-commercial. Návrh: vlastník vypíše do `art/book/manifest.json` sekci `models` s licencí;
  skript odmítne generovat modelem mimo seznam.
- **OQ-9 Styl schémat.** Ploché pastelové ilustrace mohou vyjít z modelu nekonzistentně. Návrh:
  zkouška v K4 na dvou schématech (fagocytóza, protilátka); pokud styl nedrží, schémata jako
  ručně kreslené SVG (Flutter `CustomPainter` nebo `flutter_svg`) v paletách CuteKidFonts.

## Před K6

- **OQ-3 Narace (fáze 2): lidský hlas, nebo český TTS?** Návrh: fáze 2, nejdřív test jedné
  kapitoly s kvalitním TTS; pokud dětští čtenáři nepoznají rozdíl od hlasu, TTS, jinak nahrávka.
- **OQ-4 Zdroj ambientu.** Návrh: vlastní generování (procedurální pad v `gen_sfx.dart` nebo
  AI hudební model s komerční licencí); fallback CC0 knihovna s řádkem v `CREDITS.md`. Stejná smyčka
  jde pak i do menu hry.

## Před K7

- **OQ-5 Kvíz a hra.** ADR 0002 říká: žádný vliv. Otázka zůstává, zda ukázat souhrn „kvízy 7/12"
  v menu. Návrh: ano, jen jako razítka na obálkách, bez čísla v hlavním menu.
- **OQ-7 Dyslexie.** Návrh: fáze 1 jen škálování písma a řádkování 1,5; přepínač na font pro
  dyslektiky (OpenDyslexic, OFL) zvážit v CuteKidFonts jako roli, ne v appce.
- **OQ-8 Store politika pro děti.** Pokud appka cílí na 10–15, Google Play Families a Apple Kids
  kategorie mají požadavky na celou appku (žádná reklama, žádné sledování). Návrh: rozhodnout před
  vydáním fáze 1; kniha sama nic neměří, takže ji to neblokuje.
- **OQ-10 Formulace o očkování.** Věcně podle SZÚ/MZ ČR/WHO; bez polemiky; strana pro rodiče odkazuje
  na SZÚ. Návrh: garant dostane kapitolu 12 jako první a s nejvyšší prioritou.

## Zapsané výsledky testů čtenářů

(doplní se po K3 – jméno-věk-datum nesmí být v repu; jen věk, výsledek kvízu a poznámky)
