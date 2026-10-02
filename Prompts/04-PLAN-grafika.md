# IMMUNORUN — Plán grafiky

> Navazuje na `01-PLAN-phase-0-2.md` §3 (vizuální pipeline). Stejný formát: milník / obsah / Definition of Done.
> Stav k 2. 10. 2026, po merge Etap A–D do `main`.

---

## 0. Východisko — co dnes existuje

V celém projektu jsou **dva obrázky**, oba šedé SEM výřezy s průhledným pozadím:

| Soubor | Rozměr | Použití | Zobrazená výška |
|--------|--------|---------|-----------------|
| `assets/images/cells/macrophage.png` | 1334×1067 | hráč | 96 px |
| `assets/images/pathogens/cocci.png` | 689×585 | swarmer | 52 px |

Všechno ostatní je kreslené kódem nebo Material ikonou:

| Co | Dnes | Kde |
|----|------|-----|
| Upgrade karty (7) | stejný tyrkysový rámeček + Material ikona + text | `ui/overlays/upgrade_choice_overlay.dart:55` |
| Karty místností (4) | barevný rámeček + Material ikona | `ui/overlays/room_choice_overlay.dart:61` |
| Tank | ametystový kruh | `game/components/enemies/tank.dart:30` |
| Mini-boss | kruh (`CircleComponent`) | `game/components/enemies/mini_boss.dart` |
| Projektily, ATP pickup | barevné kruhy | `projectile.dart`, `pickup.dart`, `mini_boss.dart:128` |
| Pozadí | procedurální shader bez textury (`fluid.frag` nemá sampler) | `game/world/background.dart` |
| Aréna, brány | obdélníky a kruhy | `game/world/arena.dart` |
| Menu, pauza, konec runu | jen text | `ui/overlays/` |
| Ikona appky | výchozí logo Flutteru | `android/…/mipmap-*`, `ios/…/AppIcon.appiconset` |

---

## 1. Art direction

**Styl:** falešně kolorovaná elektronová mikroskopie (SEM). Hrubý organický povrch, měkké boční světlo, bez obrysových linek, bez textu v obrázku.

**Barva nese význam** (čitelnost přítel × nepřítel na první pohled):

| Skupina | Tón | Poznámka |
|---------|-----|----------|
| Vlastní buňky (hráč, budoucí leukocyty) | studená azurová / tyrkysová | ladí s trailem `#4DE8E8` |
| Bakterie (cocci, boss S. aureus) | zlatá / okrová | „aureus" = zlatý |
| Houby / biofilm (tank) | ametystová | dnešní `tankColor #9B59B6` |
| ATP, odměny | teplá zlatavá | `#F5D76E` |
| Tkáň (pozadí) | tmavá zeleno-šedá, nízký kontrast | nesmí soupeřit s entitami; dnešní `#0D1F0D` |

**Rozhodnuto 2. 10. 2026:** hra jde do kolorované SEM podle tabulky výše. Dnešní dva šedé sprity se nepřebarvují, ale **nahradí vygenerovanými** (neznámý zdroj a licence, viz §6).

**Exportní rozměry** (zobrazená velikost × 3–4 kvůli DPR, ne víc):

| Typ | Export | Formát |
|-----|--------|--------|
| Sprite entity | delší strana 384–512 px | PNG s alfou |
| Ilustrace karty | 512×512 | PNG (WebP, pokud bude třeba šetřit) |
| Plát pozadí | 1024×1024, bezešvý | PNG/JPG bez alfy |
| Ikona appky | 1024×1024 | PNG bez alfy |

Dnešní `macrophage.png` (1334 px pro 96px sprite) je zbytečně velký — náhrada bude 512.

---

## 2. Inventář assetů

| # | Asset | Kusů | Cílová cesta | Priorita |
|---|-------|------|--------------|----------|
| A | Ilustrace upgradů: opsonin, histamin, pyrogen, treg, mitochondrie, membrana, cytotoxin | 7 | `assets/images/cards/upgrade_<id>.png` | 1 |
| B | Ilustrace místností: combat, elite, treasure, boss | 4 | `assets/images/cards/room_<type>.png` | 1 |
| C | Sprite tank (houba/biofilm) | 1 | `assets/images/pathogens/tank.png` | 2 |
| D | Sprite boss (shluk S. aureus) + varianta 2. fáze | 2 | `assets/images/pathogens/boss*.png` | 2 |
| E | Projektil hráče, projektil bosse, ATP pickup | 3 | `assets/images/fx/` | 3 |
| F | Pláty pozadí (tkáň), 2–3 paralaxní vrstvy | 2–3 | `assets/images/bg/` | 3 |
| G | Ikona appky | 1 | přes `flutter_launcher_icons` | 4 |
| H | Pozadí hlavního menu, obrazovky výhra / smrt | 2–3 | `assets/images/ui/` | 4 |
| I | Ikony mety: paměťová buňka, vakcinace | 2 | `assets/images/ui/` | 4 |
| J | Náhrada `macrophage.png`, `cocci.png` vygenerovanými | 2 | stávající cesty | 2 |

Námět každé karty (co má být na obrázku):

| Karta | Motiv |
|-------|-------|
| Opsonizace (IgG) | bakterie obalená protilátkami tvaru Y |
| Histamin | žírná buňka vypouštějící granule |
| Pyrogen (IL-6) | žhnoucí oranžové molekuly, horký tón |
| Treg (IL-10) | klidná modrá buňka, chladný tón |
| Mitochondrie | řez mitochondrií, zlatavé kristy |
| Membránová fluidita | zvlněná lipidová dvojvrstva |
| Cytotoxické granule | tmavé granule s perforinem prorážející membránu |
| Boj | roj koků |
| Elite | koky + houbový tank |
| Léčení | zdravá tkáň, zlatavé ATP |
| Boss | velký shluk S. aureus |

---

## 3. Generování na SPARKu

> Domluveno se session **Director** 2. 10. 2026. Zdroj pravdy: AiStack `origin/main`,
> `docs/IMAGE-GEN-GUIDE.md`. „Neověřeno" = Director to neměřil; ověřit ve zkoušce G0.

### 3.1 Co je k dispozici

| Backend | Okno | Rychlost | Licence pro komerční appku |
|---------|------|----------|----------------------------|
| **flux-schnell** (NIM přes gen-queue, `:8091`) | 07–13 a 19–01 | ~3–6 s / 1024² | Apache-2.0 — ano |
| **ComfyUI** (`:8188`): SDXL base + IP-Adapter Plus + ControlNet | jen 07–13 | 10–20 s (neověřeno) | SDXL base OpenRAIL++ — ano |
| ComfyUI: flux dev / Kontext / Fill | jen 07–13 | ~45 s | non-commercial — **nepoužívat** |
| ComfyUI: komunitní SDXL modely (Juggernaut, RealVis, …) | jen 07–13 | — | každý vlastní — **nepoužívat bez ověření** |

V oknech 13–19 a 01–07 neběží nic obrázkového. Chybí: Qwen-Image, LayerDiffuse (přímá alfa), node na bezešvé dlaždice.

Licence jsou podle Directora neověřené — před vydáním potvrdit u flux-schnell, SDXL base, IP-Adapteru i modelu na výřez.

### 3.2 Zvolená pipeline

Držíme se jen dvou licenčně bezpečných cest. Co jde udělat bez modelu, děláme bez modelu.

| Asset | Postup |
|-------|--------|
| Karty (A, B), menu (H), ikona (G) | flux-schnell txt2img 1024², 4 kroky, 3–4 varianty → výběr → zmenšit na 512 |
| Sprity (C, D, E, I, J) | flux-schnell na plochém jednobarevném pozadí → výřez přes ComfyUI-RMBG (BiRefNet) nebo klíčování barvy. Když sada nedrží jednotný styl: SDXL base + IP-Adapter Plus s prvním schváleným spritem jako referencí |
| Pozadí (F) | flux-schnell 1024² → bezešvost bez modelu: zrcadlové opakování v shaderu, případně posun o půl dlaždice a prolnutí švu v PIL. Inpaint přes flux Fill kvůli licenci ne |

**Držení stylu a palety:**
- Pevný stylový blok na začátku každého promptu + pevný seed na asset. Drží styl, ne tvar.
- Paletu model přesně nedodrží → sjednotit v postprocessu (gradient map / kvantizace na paletu z §1).
- Ke zkoušce v G0: generovat rovnou **šedou SEM** a barvu dodat jen gradient mapou. Paleta je pak zaručeně jednotná; cena je dvoubarevnost každého obrázku.

**Známé pasti flux-schnell:**
- Ignoruje „no text" a dokresluje falešné popisky. U mikrosnímků hrozí měřítko a popisky v rohu — nepsat „label", „scale bar", „poster", „diagram"; každý výstup projít očima.
- Občas tvarová vada (zdvojený objekt) → proto 3–4 varianty.
- Obdélníkové rozměry jen v násobcích 64 (neověřeno) → karty generovat čtvercové.

### 3.3 Zadávání úloh

Pouštíme sami přes HTTP; kontejnery nestartovat ani nezastavovat. Každou dávku předem ohlásit Directorovi (čas, počet).

```bash
curl -s -X POST http://192.168.88.66:8091/nim/flux-schnell/v1/infer \
  -H 'Content-Type: application/json' \
  -d '{"prompt":"…","width":1024,"height":1024,"seed":42,"steps":4}'      # → 202 {"id":"…"}
curl -s http://192.168.88.66:8091/nim/flux-schnell/jobs/<id>              # queued | running | done | error
curl -s -o out.jpg http://192.168.88.66:8091/nim/flux-schnell/jobs/<id>/result   # JPEG
```

- Fronta je sdílená: na `done` čekat minuty, neposílat duplikáty. Nejvýš 2 souběžné joby na projekt.
- Výsledek se drží 1 h. Seed < 2³².
- ComfyUI: `POST /prompt` s workflow v API JSON, `GET /history/{id}`, `GET /view?filename=…`.

**Reprodukovatelnost:** `art/manifest.json` (id assetu, prompt, seed, rozměr, postprocess) + skript, který manifest odešle, stáhne a zpracuje. Drafty do `art/drafts/` (v `.gitignore`), do `immunorun/assets/` jen vybrané. Manifest je zároveň podklad pro `CREDITS.md`.

### 3.4 Odhad objemu

| Dávka | Generací | Backend |
|-------|----------|---------|
| G0 zkouška stylu | ~16 | flux-schnell |
| G1 karty (11 × 4) | 44 | flux-schnell |
| G2–G4 (≈12 assetů × 4) | ~48 | flux-schnell |
| Záloha: sprity přes IP-Adapter (5 × 4) | ~20 | ComfyUI, jen 07–13 |

Celkem kolem 110 generací flux-schnell, tedy řádově 10 minut čistého výpočtu plus čekání ve frontě.

---

## 4. Milníky

| Milník | Obsah | Definition of Done |
|--------|-------|--------------------|
| G0 | **Zkouška stylu** — 1 karta (Opsonizace) + 1 sprite (makrofág), každý barevně z modelu i jako šedá SEM + gradient map; ověřit výřez pozadí. Založit manifest a skript (§3.3). | Vybraný způsob barvení; stylový blok a paleta zapsané v manifestu; výřez spritu bez halo. |
| G1 | **Karty** (A + B, 11 ks) + zapojení do overlayů. | Výběr upgradu i dveří ukazuje ilustraci; žádná Material ikona na kartě. |
| G2 | **Entity** (C, D, J) — tank a boss jako sprity, nový hráč a koky. | Ve hře není žádný nepřítel kreslený kruhem; přítel × nepřítel rozlišitelný barvou; v `assets/images/` není soubor bez záznamu v CREDITS. |
| G3 | **Pozadí a FX** (E, F) — texturovaná tkáň pod fluid shaderem, sprity projektilů a pickupu. | Pozadí má strukturu tkáně a vlní se; 60 fps na telefonu drží. |
| G4 | **UI a branding** (G, H, I) — ikona, menu, obrazovky konce runu. | Appka nemá výchozí Flutter ikonu; menu má vlastní pozadí. |

Pořadí odpovídá viditelnosti: karty hráč vidí po každé místnosti a dnes jsou nejslabším místem.

---

## 5. Zapojení do kódu

| Milník | Změna |
|--------|-------|
| G1 | `pubspec.yaml`: přidat `assets/images/cards/`. V obou overlayích nahradit `_icon()` mapou id → cesta a `Image.asset`. Cesty patří do UI vrstvy, `domain/upgrade.dart` zůstává čistý Dart. |
| G2 | `Tank` a `MiniBoss`: stejný vzor jako `Swarmer` (`Sprite.load` + `SwimSprite`), výšky spritů do `balance.dart`. Boss 2. fáze = výměna spritu. |
| G3 | `fluid.frag`: přidat `uniform sampler2D uTexture` (dnes chybí) a v `background.dart` `setImageSampler`. Projektily a pickup z `CircleComponent` na sprite. |
| G4 | `flutter_launcher_icons` do dev závislostí; `Image.asset` jako pozadí menu. |

Po každém milníku: `flutter analyze`, `flutter test`, spuštění na zařízení.

---

## 6. Licence a CREDITS

- `assets/CREDITS.md` dnes tvrdí „žádné externí snímky", ale `macrophage.png` a `cocci.png` v repu jsou (commit `2972ab9`, 3. 7. 2026) bez záznamu o zdroji. **Rozhodnuto: oba nahradit vygenerovanými v G2**; do té doby zůstávají jako placeholder.
- Každý vygenerovaný soubor dostane řádek: soubor | model + verze | licence modelu | prompt/seed (z manifestu).
- Před G1 ověřit licence: flux-schnell (Apache-2.0), SDXL base (OpenRAIL++-M), IP-Adapter, model na výřez. ComfyUI-RMBG nabízí víc modelů — použít BiRefNet, u ostatních licenci zkontrolovat.

---

## 7. Otevřené otázky

1. Způsob barvení — barva přímo z modelu, nebo šedá SEM + gradient map? Rozhodne G0 (schváleno ke spuštění v nejbližším okně 07–13).
2. Ověření licencí modelů před vydáním (§6).
