# Zadání pro L40S: fotorealistické ikony buněk a patogenů

Zadavatel: session **BioDefense** (Mac, repo `BioDefenseRogue`). Odpovědi a dotazy posílej zpět
jí. Zdroj pravdy je `art/icons/manifest.json` na větvi `art/icons`.

## 1. Co a proč

Hra IMMUNORUN a kniha Lexikon zdraví (pro děti 10–15 let) potřebují jednotnou sadu
**fotorealistických ikon**: 11 bílých krvinek, 7 patogenů a 3 další motivy (protilátka, červená
krvinka, mitochondrie). Celkem je to **21 ikon**, seznam je v manifestu (`icons[]`).

Stejná ikona poslouží jako sprite ve hře (makrofág = hráč, kok = swarmer, biofilm = tank,
stafylokok = boss), v knize (kapitoly 2 a 3, slovníček) a na kartách upgradů. Musí proto:
- ukazovat **jeden izolovaný objekt** celý, uprostřed, s okrajem kolem,
- mít **čisté černé pozadí**, aby šel objekt čistě vyříznout,
- **nemít žádný text**, popisek, měřítko ani vodoznak (nejčastější vada, každý výstup projít okem),
- mít **barvu podle skupiny** (`tones`): vlastní buňky studená azurová, bakterie zlatá, biofilm
  ametystový sliz, virus karmínový, plíseň olivová. Dítě musí přítele od nepřítele poznat podle barvy.

Prompt se skládá takto: `styles[style] + ", " + tones[tone] + ", " + subject`. Negativní prompt
je `negative` (pokud ho model podporuje).

## 2. Postup

**I0 – zkouška stylu (nejdřív, pak stop).** Vygeneruj `makrofag`, `kok`, `biofilm`,
`virus-chripka` a `protilatka`, 4 seedy na ikonu. Pošli kontaktní archy a čekej na schválení stylu.
Teprve potom jdi do I1. Pokud styl nedrží (kreslené, rozmazané, text, víc objektů), uprav stylový
blok v manifestu. Do subjectů nesahej bez domluvy, hlídají biologickou správnost.

**I1 – celá sada.** Zbylých 16 ikon po 4 seedech. Když model u některého motivu opakovaně
selhává (typicky dendritická buňka, Aspergillus, cytotoxická T buňka s cílovou buňkou), přidej
4 další seedy a napiš, co nefunguje.

**Seedy:** `3000 + 10 × (pořadí v icons[], od 0) + k`, kde k = 0…3 (další varianty k = 4…).
Rozměr 1024×1024.

**Výřez:** BiRefNet (MIT) nebo jiný model s ověřenou licencí. Výsledek PNG RGBA, ořez na objekt
s okrajem kolem 6 %, doplnit na čtverec, 1024 px. Bez halo na hranách (zkontrolovat na tmavém
i světlém podkladu).

## 3. Licence (blokující)

Appka je komerční a míří na děti. Použij **jen** model s licencí, která dovoluje komerční
použití výstupů, například Qwen-Image (Apache-2.0), HiDream-I1 (MIT), FLUX.1 schnell (Apache-2.0)
nebo SDXL base (OpenRAIL++-M). **Nepoužívej** FLUX.1 dev/Kontext/Fill (non-commercial) ani
komunitní checkpointy a LoRA bez dohledané licence. Do `manifest.backend` zapiš přesný checkpoint,
verzi a licenci. Bez toho se ikony do appky nedostanou.

## 4. Co odevzdat

Na větev `art/icons` (commit + push, žádný merge do `main`):

```
art/icons/sheets/<id>.jpg        # kontaktní arch: 4 varianty vedle sebe, pod nimi výřezy
                                 # na šachovnici, seed pod každou variantou; JPEG ≤ 400 kB
art/icons/manifest.json          # backend vyplněný; u každé ikony "seeds": [...], případně "notes"
```

Surové výstupy a všechny výřezy nech u sebe (`art/icons/drafts/` je v `.gitignore`), dokud se
nevybere. Po výběru (seed zapíše BioDefense do `selected`) commitni jen vybrané mastery:

```
art/icons/selected/<id>.png      # 1024 RGBA výřez vybrané varianty
```

Zmenšení do `immunorun/assets/`, zapojení do hry a knihy a `CREDITS.md` udělá BioDefense na Macu.

## 5. Komunikace

- Před I0 napiš BioDefense: jaký model a licenci použiješ, odhad času na obrázek.
- Po I0 a po I1: krátká zpráva „hotovo, push <commit>“ a seznam ikon s problémem.
- Když něco v zadání nedává smysl biologicky nebo technicky, zeptej se. Neodhaduj.
