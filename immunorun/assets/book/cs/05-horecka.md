---
id: 05-horecka
title: "Horečka: kamarád, ne nepřítel"
part: 3
palette: peach
hero: 05-horecka-hero.webp
lore:
  - mechanic.fever
  - fever.normo
  - fever.febrile
  - fever.hyper
  - fever.critical
  - upgrade.pyrogen
quiz:
  - question: Kdo v těle zapíná horečku?
    answers:
      - text: Bakterie, když se rychle množí.
      - text: Mozek, na zprávu od obránců.
        correct: true
      - text: Svaly, když hodně běháš.
    why: Obránci pošlou do krve pyrogen a hypotalamus v mozku přestaví termostat výš.
  - question: Jak horečka pomáhá proti infekci?
    answers:
      - text: Zrychlí ti ruce i nohy.
      - text: Bakterie se v teple množí pomaleji.
        correct: true
      - text: Teplem se všechny bakterie hned spálí.
    why: Mnoha bakteriím a virům se v teple daří hůř a obránci zároveň pracují lépe.
  - question: Co dělat, když máš horečku?
    answers:
      - text: Říct dospělému, pít a odpočívat.
        correct: true
      - text: Jít si pořádně zaběhat a vypotit ji.
      - text: Vzít si sám lék ze skříňky.
    why: Tělo potřebuje vodu a klid a dospělý pozná, jestli je potřeba lékař.
---

## Horečka {#horecka}

Ve hře hlídáš teploměr. S bojem teplota stoupá, v klidu klesá. Od {{balance.feverFebrilStart|degC}}
útočíš rychleji, od {{balance.feverHyperStart|degC}} ztrácíš zdraví a od
{{balance.feverCriticalStart|degC}} hra brzy končí.

Horečku znáš i z vlastního těla. Je ti zima, pak horko a nechce se ti z postele. Možná sis myslel/a,
že horečka je ta nemoc. Doopravdy je to nástroj, který si tělo zapíná samo. V téhle kapitole uvidíš
proč.

---

## Normální teplota {#normalni-teplota}

Zdravé tělo si drží teplotu kolem 37 °C. Ráno bývá o kousek nižší, večer vyšší. Záleží i na tom,
kde měříš: v podpaží vyjde trochu méně než v ústech.
<!-- TODO-FACT: PEDIATRIE – normální teplota, denní kolísání, rozdíl podpaží × ústa -->

Teplotu hlídá malá část mozku, **hypotalamus**. Funguje jako termostat v bytě. Když je ti zima,
roztřeseš se a svaly vyrobí teplo. Když je ti horko, potíš se a pot tě ochladí.
<!-- TODO-FACT: HOREJSI – hypotalamus jako centrum termoregulace, třes a pocení -->

O horečce mluví lékaři od 38 °C. Mezi 37 a 38 °C říkají „zvýšená teplota“.
<!-- TODO-FACT: PEDIATRIE – hranice zvýšené teploty a horečky v ČR -->

---

## Kdo horečku zapíná {#pyrogeny}

Ve hře horečku zvedá boj a karta {{lore.upgrade.pyrogen}}. Doopravdy ji zapínají sami obránci. Když makrofág
narazí na bakterie, pošle do krve zprávu. Té zprávě se říká **pyrogen**, česky „to, co přináší
oheň“. Jeden z pyrogenů se jmenuje interleukin 6, zkráceně IL-6.
<!-- TODO-FACT: JANEWAY – IL-6 (spolu s IL-1 a TNF) jako pyrogen, produkce makrofágy -->

Zpráva doputuje krví do mozku. Hypotalamus přestaví termostat výš. Tělu je najednou zima, i když
má 37 °C. Proto se třeseš a chceš se zachumlat. Tomu třesu se říká **zimnice**. Trvá, dokud tělo
nedosáhne nové teploty.
<!-- TODO-FACT: HOREJSI – posun nastavené teploty v hypotalamu, zimnice při vzestupu horečky -->

![Obranná buňka pošle zprávu krví do mozku a ten přestaví termostat výš.](05-horecka-schema-1.webp)

> [!zvedave]
> Pyrogenů je víc, kromě IL-6 třeba IL-1 a TNF. V mozku spustí výrobu látky prostaglandin E2 a ta
> teprve posune termostat. Léky na horečku brzdí výrobu prostaglandinů. Teplotu sníží, ale
> infekci samy neléčí.
<!-- TODO-FACT: JANEWAY – IL-1, TNF, PGE2 v hypotalamu; mechanismus antipyretik -->

---

## Proč horečka pomáhá {#proc-horecka-pomaha}

Ve hře ti horečka zrychlí útok. Doopravdy pomáhá jinak, a to dvakrát.

Zaprvé: mnoha bakteriím a virům se v teple daří hůř. Množí se pomaleji. Zadruhé: obránci pracují
lépe. **Bílé krvinky|bila-krvinka** se rychleji dostanou tam, kde je infekce, a víc se jich zapojí.
<!-- TODO-FACT: JANEWAY – horečka zpomaluje množení části patogenů, zlepšuje migraci a aktivaci leukocytů -->

Proč tedy horečku nemít pořád? Protože stojí hodně energie. Srdce bije rychleji a ty jsi
unavený/á. Tělo ji proto zapne jen na čas, než infekci zvládne. Vědci pořád zkoumají, u kterých
nemocí horečka pomáhá nejvíc.
<!-- TODO-FACT: HOREJSI – energetická cena horečky, zrychlený tep -->

> [!doopravdy]
> Ve hře ti horečka zrychlí a zesílí útok. Doopravdy makrofág v horečce rychleji nebije. Horečka
> brzdí nepřítele a pomáhá obráncům se svolat. Karta {{lore.upgrade.pyrogen}} ti ve hře přidá sílu.
> Doopravdy IL-6 obráncům sílu nepřidává, jen pomáhá zapnout horečku.
<!-- TODO-FACT: JANEWAY – horečka nezvyšuje „sílu“ jednotlivé buňky; IL-6 jako pyrogen -->

---

## Kdy je horečka nebezpečná {#kdy-je-horecka-nebezpecna}

Ve hře od {{balance.feverHyperStart|degC}} ztrácíš zdraví. Od {{balance.feverCriticalStart|degC}}
ti zbývá {{balance.feverCriticalKillDelay|s}} a run končí.

Doopravdy to tak rychle nejde. Vysoká horečka ale tělo vyčerpává a obranu už nevylepšuje. Tělo
ztrácí vodu potem a rychlým dýcháním, proto je důležité pít.
<!-- TODO-FACT: PEDIATRIE – vysoká horečka a dehydratace u dětí -->

Horečka nad 41 °C je vzácná a patří vždycky k lékaři. Tělo má i vlastní brzdu: obránci posílají
zprávy, které horečku zase tlumí. O nich je kapitola 7.
<!-- TODO-FACT: PEDIATRIE – hyperpyrexie nad 41 °C; HOREJSI – tělu vlastní tlumení horečky -->

> [!prakticky]
> - Řekni dospělému, že ti není dobře.
> - Pij vodu nebo čaj, i když nemáš žízeň.
> - Odpočívej. Tělo teď pracuje naplno.
> - Lék ti dá jen dospělý nebo lékař.
> - Když se ti hůř dýchá nebo je ti čím dál hůř, dospělý zavolá lékaře.
<!-- TODO-FACT: SZU, PEDIATRIE – doporučení pro dítě s horečkou, varovné příznaky -->

---

## Horečka u zvířat {#horecka-u-zvirat}

Horečku nemají jen lidé, ale i psi, kočky a ptáci. Zvířata, která si teplo vyrobit neumí, si ho
najdou. Nemocná ryba nebo ještěrka si vyhledá teplejší místo.
<!-- TODO-FACT: JANEWAY / KLUGER1975 – horečka u savců a ptáků, behaviorální horečka u ryb a plazů -->

Horečka je v přírodě stará a rozšířená. To je další stopa, že se tělu vyplácí.

> [!vedel]
> V roce 1975 vědci pozorovali nemocné ještěrky. Ty, které se mohly ohřát, přežívaly častěji než
> ty, které zůstaly v chladu.
<!-- TODO-FACT: KLUGER1975 – design pokusu a výsledek (přežití podle teploty) -->
