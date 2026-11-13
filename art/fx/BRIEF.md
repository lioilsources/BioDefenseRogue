# Zadání pro L40S: FX, pozadí a menu (G3, G4)

Zadavatel: session **BioDefense** (Mac, repo `BioDefenseRogue`). Odpovědi a dotazy posílej zpět
jí. Zdroj pravdy je `art/fx/manifest.json` na větvi `art/fx-bg`. Navazuje na `art/icons/BRIEF.md`
(stejný postup, licence i výřez) a na schválený styl ikon.

## 1. Co a proč

Ikony buněk a patogenů už ve hře jsou. Zbývá 8 obrázků (`items[]` v manifestu):

- **3 FX sprity** (`fx-granula`, `fx-toxin`, `fx-atp`): střela hráče, střela bosse a ATP
  pickup. Ve hře mají průměr jen 12–20 px, takže rozhoduje **čitelný kulatý obrys a vnitřní
  záře**, ne detail. `fx-granula` je schválně světlá a neutrální, barvu (normální, kritický
  zásah, nova) jí dá tint ve hře.
- **1 ikona mety** (`meta-vakcinace`): stejný formát jako ikony buněk, výřez.
- **3 pozadí obrazovek** (`bg-menu`, `bg-vyhra`, `bg-prohra`): na šířku 1664×928, bez výřezu.
  Hra je pro děti 10–15 let: prohra smí být smutná, ne strašidelná, a nic krvavého.
  **Střední třetina snímku musí zůstat klidná**, bude přes ni text a tlačítka.
- **1 dlaždice arény** (`bg-arena`): 1024×1024, **musí jít bezešvě opakovat**. Použij circular
  padding (např. seamless/tiling node v ComfyUI) nebo offset + zacelení švu. Nízký kontrast,
  sprity přes ni musí být dobře vidět. Když bezešvost nepůjde, napiš, nehackuj to.

Barvy drží logiku ikon: vlastní buňky azurové, bakterie zlaté, biofilm ametystový.

## 2. Postup

**F0 – zkouška (nejdřív, pak stop).** `fx-granula`, `bg-menu` a `bg-arena`, 4 seedy na položku.
Pošli kontaktní archy a čekej na schválení. Stylové bloky (`styles`, `tones`) smíš upravit, když
nedrží; do `subject` nesahej bez domluvy.

**F1 – zbytek.** Zbylých 5 položek po 4 seedech.

**Seedy:** `5000 + 10 × (pořadí v items[], od 0) + k`, k = 0…3. Rozměr podle `size` u položky.

**Výřez** (jen `cutout: true`): stejně jako u ikon, BiRefNet, PNG RGBA, ořez na objekt s okrajem
6 %, čtverec 1024 px, bez halo.

## 3. Licence (blokující)

Stejná pravidla jako `art/icons/BRIEF.md` §3. Použij Qwen-Image jako u ikon a vyplň
`manifest.backend`. Komunitní LoRA ani checkpointy bez dohledané licence ne.

## 4. Co odevzdat

Na větev `art/fx-bg` (commit + push, žádný merge do `main`):

```
art/fx/sheets/<id>.jpg      # kontaktní arch: 4 varianty, seed pod každou; u FX i výřezy
                            # na šachovnici a zmenšenina na 24 px; u bg-arena 2×2 dlaždice
                            # vedle sebe (ať je vidět šev); JPEG ≤ 400 kB
art/fx/manifest.json        # backend; u položek "seeds": [...], případně "notes"
```

Surové výstupy nech u sebe (`art/fx/drafts/` je v `.gitignore`). Po výběru (seed zapíše
BioDefense do `selected`) commitni vybrané mastery do `art/fx/selected/<id>.png` (pozadí můžou
být `.jpg` v plném rozlišení). Zmenšení, zapojení do kódu a `CREDITS.md` udělá BioDefense.

## 5. Komunikace

- Před F0 krátce potvrď backend a odhad času.
- Po F0 a po F1: „hotovo, push <commit>“ a seznam položek s problémem.
- Když zadání nedává smysl, zeptej se. Neodhaduj.
