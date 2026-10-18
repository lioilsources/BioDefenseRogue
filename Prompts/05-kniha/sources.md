# Zdroje – Lexikon zdraví

Seznam zdrojů, na které odkazují kapitoly (`assets/book/cs/*.md`) a registr pojmů
(`immunorun/lib/domain/lore.dart`, pole `sourceRef`). Pravidla vycházejí z ADR 0003 a
`03-redakcni-standard.md` §6.

## Jak se odkazuje

- **Klíč zdroje** je slovo VERZÁLKAMI z tabulky níže (`JANEWAY`, `SZU` …). Jiné klíče se v textu
  nesmí objevit. Test v K1 (a v S4 pro registr) to vynutí.
- **Ověřené tvrzení**: komentář za odstavcem
  `<!-- src: JANEWAY kap. 3, s. 85 -->`. Místo (kapitola, strana, URL s datem) je povinné.
- **Neověřené tvrzení**: `<!-- TODO-FACT: JANEWAY – co přesně ověřit -->`. Klíč říká, kde hledat,
  text za pomlčkou říká, co má garant potvrdit. Release build nesmí obsahovat žádný `TODO-FACT`.
- Jeden komentář může krýt celý odstavec. Pokud odstavec obsahuje dvě tvrzení z různých zdrojů,
  patří za něj dva komentáře.
- **Čísla ze hry** se neodkazují, píšou se jako placeholder `{{balance.<konstanta>|<formát>}}`
  (06-sync ADR 0002). Zdroj potřebují jen čísla o skutečném těle (37 °C, 1882).

## Stav

Ve stavu K0 nemá žádný zdroj ověřené čísla stran. Vydání ani dostupnost jsem nezkontroloval
proti fyzickým knihám. Proto všechny odkazy v kapitolách zatím mají tvar `TODO-FACT: <KLÍČ> – …`.
Doplnění stran je úkol pro K3 (autor) a pro garanta (02-plan §7).

## Seznam

| Klíč | Zdroj | K čemu se cituje | Ověřit |
|---|---|---|---|
| `HOREJSI` | Hořejší, Bartůňková, Brdička, Špíšek: *Základy imunologie*. Triton. | Hlavní opora pro češtinu a názvosloví: buňky, zánět, horečka, protilátky, paměť. | vydání a rok (použít poslední), čísla stran |
| `JANEWAY` | Murphy, Weaver: *Janeway's Immunobiology*. Garland / W. W. Norton. | Referenční kontrola mechanismů: fagocytóza, ROS, lysozym, cytokiny, opsonizace, cytotoxické buňky, paměť. | vydání, kapitola a strana u každého tvrzení |
| `ABBAS` | Abbas, Lichtman, Pillai: *Basic Immunology*. Elsevier. | Stručnější kontrola, když se Janeway a Hořejší liší v míře zjednodušení. | vydání |
| `ALBERTS` | Alberts a kol.: *Molecular Biology of the Cell* (nebo český překlad *Základy buněčné biologie*). | Mitochondrie, ATP, membrána, aktin, pohyb buňky (kapitola 9). | který titul a vydání |
| `MIKRO` | Učebnice lékařské mikrobiologie (návrh: Bednář a kol., *Lékařská mikrobiologie*). | *S. aureus*, biofilm, koky, viry, *Aspergillus* (kapitola 3). | vybrat konkrétní titul, vydání |
| `DETTMER` | Dettmer: *Immune* (Kurzgesagt), Random House. | Jen vzor tónu, ne zdroj faktů. | zda existuje český překlad |
| `SZU` | Státní zdravotní ústav, szu.cz. | Očkování, horečka u dětí, hygiena. | konkrétní stránky s datem přístupu |
| `MZCR` | Ministerstvo zdravotnictví ČR, mzcr.cz. | Očkovací kalendář, oficiální formulace. | konkrétní stránky s datem přístupu |
| `WHO` | World Health Organization, who.int (fact sheets). | Očkování, horečka, infekce, srovnání s českými formulacemi. | konkrétní fact sheety s datem přístupu |
| `PEDIATRIE` | Česká pediatrická doporučení k horečce u dětí (návrh: doporučený postup ČPS). | Hranice horečky, kdy k lékaři, co doma (kapitola 5, praktický box). | konkrétní dokument, rok |
| `KLUGER1975` | Kluger, Ringler, Anver (1975): Fever and survival. *Science* 188. | „Věděl/a jsi?" v kapitole 5: ještěrky si při infekci vyhledají teplo. | ročník, strany, zda zjištění platí i podle novějších prací |
| `METCHNIKOFF` | Historické práce I. I. Mečnikova o fagocytóze (přehled: Nobelova cena 1908, nobelprize.org). | Historický box v kapitole 4. | rok objevu (scope uvádí 1882) |
| `NIAID` | NIAID / CDC PHIL / NIH BioArt. | Jen reference vzhledu buněk a patogenů pro zadání obrázků (K4), ne pro text. | licence se netýká, obrázky se nepřebírají |
| `SEM` | Učebnice nebo přehled elektronové mikroskopie (návrh: materiály ÚMG AV ČR / univerzitní skripta). | Kapitola 0: jak vzniká SEM snímek, proč je černobílý, falešné barvy. | vybrat konkrétní zdroj |
| `RVP` | Rámcový vzdělávací program pro základní vzdělávání, oblast Člověk a příroda, Přírodopis. | Návaznost kapitol na učivo 8. a 9. ročníku (strana pro rodiče). | aktuální znění (revize RVP) |

Nový zdroj se do tabulky přidává ve stejném PR jako první odkaz na něj.
