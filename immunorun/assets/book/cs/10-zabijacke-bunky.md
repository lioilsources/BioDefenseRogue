---
id: 10-zabijacke-bunky
title: Zabijácké buňky
part: 3
palette: peach
hero: 10-zabijacke-bunky-hero.webp
lore:
  - upgrade.cytotoxin
  - damage.kinetic
  - damage.inflammatory
quiz:
  - question: Proč zabijácké buňky ničí vlastní buňky těla?
    answers:
      - text: Protože jsou už moc staré a velké.
      - text: Protože jsou nakažené virem.
        correct: true
      - text: Protože jim berou kyslík.
    why: Virus se množí uvnitř buňky, a když zanikne buňka, zanikne i jeho továrna.
  - question: K čemu je perforin?
    answers:
      - text: Udělá do buňky otvor.
        correct: true
      - text: Obarví nakaženou buňku nazeleno.
      - text: Zahřeje buňku, až praskne.
    why: Otvorem od perforinu projdou do nakažené buňky látky, které spustí její úklid.
  - question: Co je apoptóza?
    answers:
      - text: Hlasitý výbuch, po kterém zůstane zánět.
      - text: Rozdělení buňky na dvě nové.
      - text: Tichý úklid buňky.
        correct: true
    why: Buňka se rozloží na malé balíčky, které sežerou makrofágy, a okolí se nezanítí.
---

## Zabijáci {#zabijaci}

Ve hře ti karta {{lore.upgrade.cytotoxin}} dá {{balance.cytotoxinDamageMulti|pctDelta}}
k poškození střel. Zní to jako zbraň makrofága. Doopravdy takové granule nosí jiné buňky.

Jsou to NK buňky a **cytotoxické T buňky|cytotoxicka-t-bunka**. Říká se jim zabijácké buňky.
Nehoní bakterie. Hledají vlastní buňky těla, které nakazil virus.
<!-- TODO-FACT: JANEWAY – NK buňky a CD8 T buňky, cíl: buňky infikované virem -->

Zní to krutě, ale je to ochrana. V téhle kapitole uvidíš, proč tělo vlastní buňku obětuje
a jak to zabijáci dělají.

---

## Proč obětovat vlastní buňku {#nakazena-bunka}

Virus se nemůže množit sám. Vleze do tvé buňky a přinutí ji vyrábět nové viry. Nakažená buňka
funguje jako továrna, kterou ovládl nepřítel.
<!-- TODO-FACT: JANEWAY – množení viru uvnitř hostitelské buňky -->

Uvnitř buňky je virus schovaný. Protilátky a makrofágy na něj zvenku nedosáhnou. Zabiják proto
zničí celou továrnu. Jedna buňka zanikne, ale sousední zůstanou zdravé. Tělo si ztracené buňky
časem doplní.
<!-- TODO-FACT: JANEWAY – proč je nutné zabít infikovanou buňku; HOREJSI – obnova tkáně -->

> [!zvedave]
> Jak zabiják pozná nakaženou buňku? Každá buňka ukazuje na povrchu kousky bílkovin ze svého
> nitra. T buňka v nich hledá kousek viru. NK buňka si zase všimne, když buňce chybí obvyklý
> „průkaz“ na povrchu. Odborně se mu říká MHC.
<!-- TODO-FACT: JANEWAY – MHC I, rozpoznání CD8 T buňkou, „missing self“ u NK buněk -->

---

## Granule: zásoba zbraní {#granule}

Zabijácká buňka nosí uvnitř drobné váčky, **granule|granule**. Jsou v nich připravené látky.
Když zabiják najde nakaženou buňku, přitiskne se k ní a obsah granulí vypustí.
<!-- TODO-FACT: JANEWAY – cytotoxické granule, vylití obsahu v místě kontaktu -->

Jedna z látek se jmenuje **perforin**. Udělá do membrány nakažené buňky malý otvor. Otvorem
projdou další látky, granzymy. Ty uvnitř buňky spustí její úklid.
<!-- TODO-FACT: JANEWAY – perforin tvoří póry, granzymy spouštějí apoptózu -->

Zabiják při tom sám nezanikne. Odpojí se a vyrazí hledat další nakaženou buňku. Granule si
pak znovu doplní.
<!-- TODO-FACT: JANEWAY – sériové zabíjení cytotoxickými buňkami, obnova granulí -->

> [!doopravdy]
> Ve hře máš jako makrofág cytotoxické granule a střílíš silněji. Doopravdy makrofág perforin
> nepoužívá. Tyhle granule mají hlavně NK buňky a cytotoxické T buňky. Makrofág nepřítele
> pohltí a stráví.
<!-- TODO-FACT: JANEWAY – perforin a granzymy u NK a CD8 T buněk, ne u makrofágů -->

---

## Apoptóza: tichý úklid {#apoptoza}

Když granzymy proniknou do buňky, spustí **apoptózu|apoptoza**. Tak se říká tichému úklidu buňky. Buňka
se scvrkne a rozpadne na malé balíčky obalené membránou. Makrofágy je sežerou.
<!-- TODO-FACT: ALBERTS – průběh apoptózy, apoptotická tělíska, odklizení fagocyty -->

Proč tak opatrně? Kdyby buňka praskla, její obsah by se vylil do okolí. To by spustilo zánět.
Při apoptóze se okolí nezanítí a viry uvnitř zaniknou spolu s buňkou.
<!-- TODO-FACT: ALBERTS / JANEWAY – apoptóza bez zánětu × nekróza se zánětem; osud viru -->

> [!vedel]
> Apoptózu tělo nepoužívá jen v boji. Dávno před narozením jsi měl/a ruce podobné malým
> ploutvičkám. Buňky mezi prsty pak samy zanikly apoptózou. Proto máš prsty oddělené.
<!-- TODO-FACT: ALBERTS – apoptóza při vývoji prstů u embrya -->

---

## Typy poškození ve hře {#typy-poskozeni}

Ve hře dáváš dva druhy zásahů. {{lore.damage.kinetic}} pochází ze střel a z průjezdu nabitým
dashem. {{lore.damage.inflammatory}} dává kruhová vlna a každý zásah ti zvedne horečku. Další
typy hra teprve chystá.

Doopravdy obránci do nepřátel nenarážejí. Ničí je chemicky. Používají enzymy, které nepřítele
rozloží, nebo velmi reaktivní formy kyslíku. Zabijáci k tomu mají perforin a granzymy.
<!-- TODO-FACT: JANEWAY – mechanismy zabíjení: enzymy, ROS, perforin/granzymy -->

Typy poškození jsou tedy herní zkratka. Pomáhají ti poznat, který útok co dělá. V těle žádné
ukazatele zásahů nejsou.

> [!doopravdy]
> Ve hře je fyzické poškození jako náraz. Doopravdy bílé krvinky nepřítele nerozbíjejí silou.
> Rozkládají ho chemicky. Zánětlivé poškození ve hře přitopí horečce. Doopravdy zánět není
> zbraň, ale reakce tkáně. Horečku zapínají zprávy obránců, o kterých je kapitola 5.
<!-- TODO-FACT: JANEWAY – chemické zabíjení fagocyty; HOREJSI – zánět jako reakce tkáně, pyrogeny -->
