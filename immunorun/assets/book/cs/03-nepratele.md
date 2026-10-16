---
id: 03-nepratele
title: "Nepřátelé: bakterie, viry, houby"
part: 2
palette: sky
hero: 03-nepratele-hero.webp
lore:
  - enemy.swarmer
  - enemy.tank
  - enemy.boss
  - enemy.boss.phase2
quiz:
  - question: Proč se tank ve hře tak špatně ničí?
    answers:
      - text: Koky se schovávají ve slizu.
        correct: true
      - text: Má krunýř z pevné kosti.
      - text: Je to jedna obří bakterie, větší než ty.
    why: Tank je biofilm, bakterie zabalené ve slizu, ke kterým se obránci hůř dostanou.
  - question: Co virus potřebuje, aby se množil?
    answers:
      - text: Tvoje buňky.
        correct: true
      - text: Hodně slunečního světla.
      - text: Vysokou horečku.
    why: Virus nemá vlastní továrnu, a tak přinutí tvoje buňky, aby vyráběly nové viry.
  - question: Jsou všechny bakterie v těle nepřátelé?
    answers:
      - text: Ne, většina pomáhá.
        correct: true
      - text: Ano, všechny škodí.
      - text: V těle žádné bakterie nejsou.
    why: Bakterie mikrobiomu pomáhají trávit a nenechají nebezpečné bakterie uchytit.
---

## Koky {#koky}

Ve hře na tebe najíždí roj malých kulatých nepřátel. Jsou to **bakterie**. Bakterie je živý tvor
z jediné buňky, mnohem menší než tvoje buňky.
<!-- TODO-FACT: MIKRO – bakterie jako jednobuněčné organismy, velikost oproti lidským buňkám -->

Kulaté bakterie se jmenují **koky|kok**. Slovo pochází z řečtiny a znamená „zrnko“. Ve hře je to
**stafylokok**. „Stafylo“ znamená řecky „hrozen“. Stafylokoky drží u sebe ve shlucích, které
vypadají jako hrozen vína.
<!-- TODO-FACT: MIKRO – tvar koků, etymologie kokkos a staphylé, uspořádání stafylokoků do shluků -->

> [!doopravdy]
> Ve hře tě koky honí. Doopravdy to neumí. Stafylokok nemá bičík, kterým by plaval, a za obráncem
> nejde. Nese ho tekutina. Přibývá tím, že se dělí: z jedné bakterie jsou dvě, ze dvou čtyři.
<!-- TODO-FACT: MIKRO – nepohyblivost stafylokoků (bez bičíku), množení dělením -->

---

## Biofilm {#biofilm}

Ve hře je tank pomalý a odolný. Těžko ho odstrčíš a dlouho vydrží. Je to **biofilm**: shluk
stafylokoků zabalených do slizu.

Bakterie si ten sliz vyrábějí samy. Přilepí se jím k povrchu a drží pohromadě. Uvnitř jsou
chráněné. Obránci se k nim dostanou hůř. Hůř účinkují i antibiotika, tedy léky na bakterie.
Biofilm znáš i ze zubů, je to zubní plak.
<!-- TODO-FACT: MIKRO – biofilm S. aureus, ochrana před fagocyty a antibiotiky, zubní plak jako biofilm -->

> [!doopravdy]
> Ve hře se tank sune za tebou. Doopravdy biofilm po tkáni neleze. Drží se jednoho povrchu, třeba
> kosti nebo hadičky, kterou lékař zavede do těla.
<!-- TODO-FACT: MIKRO – biofilm jako přisedlé společenství, biofilm na kostech a katétrech -->

---

## Zlatý stafylokok {#stafylokok}

Ve hře na konci čeká boss, velký stafylokok. Krouží arénou a střílí po tobě. Celým jménem je to
zlatý stafylokok (*Staphylococcus aureus*). Na misce vyroste v hromádky bakterií, kterým se říká
kolonie. Ty bývají zlatožluté, odtud jméno.
<!-- TODO-FACT: MIKRO – barva kolonií S. aureus, význam slova aureus -->

Hodně lidí ho nosí v nose a nic jim nedělá. Když se dostane do rány, umí způsobit zánět. Vylučuje
**toxiny|toxin**, tedy jedy. Některé umějí poškodit i bílé krvinky.
<!-- TODO-FACT: MIKRO – nosičství S. aureus v nose, kožní infekce, toxiny včetně leukocidinů -->

---

## Bakterie umí počítat {#quorum-sensing}

Ve hře boss uprostřed souboje zesílí. Zrychlí a začne střílet dávky. Doopravdy má stafylokok jiný
trik. Každá bakterie vypouští do okolí malé signální látky. Čím víc bakterií, tím víc signálu.
<!-- TODO-FACT: MIKRO – signální molekuly stafylokoků (agr systém), koncentrace roste s počtem bakterií -->

Když je signálu dost, bakterie přepnou a začnou vyrábět toxiny. Tomu se říká **quorum sensing|quorum-sensing**, česky zhruba „vnímání počtu“. Vědci si myslí, že útok se bakteriím
vyplatí, až když jich je hodně.
<!-- TODO-FACT: MIKRO – quorum sensing u S. aureus, přepnutí na toxiny při vysoké hustotě -->

> [!doopravdy]
> Ve hře spustí druhou fázi bosse úbytek zdraví pod {{balance.bossPhase2HpFraction|pct}}, nebo
> horečka nad {{balance.bossFeverTrigger|degC}}. Doopravdy horečka bakterie neposiluje. Naopak je
> brzdí, jak víš z kapitoly 5. Tady hra říká opak pravdy. Skutečný spínač je quorum sensing.
<!-- TODO-FACT: MIKRO, JANEWAY – horečka zpomaluje množení bakterií; spínač toxinů je quorum sensing -->

---

## Viry {#viry}

Ve hře zatím viry nepotkáš. **Virus** je mnohem menší než bakterie. Sám se množit neumí, nemá
vlastní továrnu. Dostane se do tvé buňky a přinutí ji vyrábět nové viry.
<!-- TODO-FACT: MIKRO – virus jako vnitrobuněčný parazit, velikost oproti bakterii -->

Takhle vzniká třeba rýma nebo chřipka. Antibiotika na viry nepůsobí. Proti některým virům pomáhá
očkování, o něm je kapitola 12.
<!-- TODO-FACT: MIKRO, SZU – rýma a chřipka jako virová onemocnění, antibiotika na viry neúčinkují -->

---

## Houby {#houby}

Nepřítelem může být i **plíseň|plisen**, drobná houba. Plíseň *Aspergillus* roste třeba ve vlhkém
sklepě. Množí se **sporami|spora**. Spora je drobounká částečka, ze které vyroste nová plíseň.
Funguje podobně jako semínko, jen létá vzduchem.
<!-- TODO-FACT: MIKRO – Aspergillus, výskyt v prostředí, spory ve vzduchu -->

Spory plísní dýcháš skoro pořád. Zdravé tělo si s nimi poradí. Makrofágy v plicích je zachytí
a sní.
<!-- TODO-FACT: JANEWAY – vdechování spor, likvidace spor plicními makrofágy -->

---

## Mikrobiom {#mikrobiom}

Většina bakterií v těle ale nepřítel není. Ve střevech, na kůži i v ústech jich žije obrovské
množství. Dohromady se jim říká **mikrobiom**. Pomáhají ti trávit jídlo a zabírají místo, takže se
nebezpečné bakterie nemají kde uchytit.
<!-- TODO-FACT: MIKRO – mikrobiom, pomoc při trávení, ochrana obsazením místa -->

Ve hře bojuješ jen s bakteriemi, které se dostaly, kam nepatří.

> [!vedel]
> V tvém těle je bakterií zhruba stejně jako tvých vlastních buněk. Dřív se psalo, že bakterií je
> desetkrát víc. Novější výpočty to opravily.
<!-- TODO-FACT: MIKRO – odhad poměru bakterií a lidských buněk (zhruba 1 : 1), starší odhad 10 : 1 -->
