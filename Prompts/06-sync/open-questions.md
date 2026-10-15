# Otevřené otázky – synchronizace hry a knihy

Každá má navrženou odpověď; implementace se jí drží, dokud vlastník nerozhodne jinak.

## Před S1

- **OQ-1 Biologie tanku.** Plán grafiky říká „houba / biofilm", `killedByLabelCz` říká jen
  „tankovi", archetypy bossů v `architecture/` dávají houbu až do biomu 3 (*Aspergillus*) a
  biofilm bakteriím *S. aureus* v biomu 1. Návrh: v biomu 1 je tank **shluk *S. aureus* s
  biofilmem** (bakterie, ne houba), kapitola 3; houba přijde s biomem 3 jako `planned`. Plán grafiky
  §1 a §2 (ametystová = houby) pak upravit, nebo tank přebarvit do okrové.
- **OQ-2 Comba bez biologie.** Charge dash, juke, radiální nova. Návrh: `LoreKind.ability` jen pro
  pohyb a special (membrána, degranulace); comba zůstávají mimo registr, dokud nedostanou výklad
  (nova = degranulace žírné buňky je nabízející se, ale až s eosinofilem/žírnou buňkou jako postavou).
- **OQ-3 Název zóny horečky v HUD.** Dnes HUD ukazuje jen číslo a barvu. Návrh: název zóny z
  registru jako tooltip při dlouhém stisku (stejná interakce jako deep-link do knihy), ne stálý text.

## Před S5

- **OQ-4 Lhůta na dopsání kapitoly po přepnutí `planned → live`.** Test vynutí přepnutí záznamu,
  ne text kapitoly. Návrh: text v témže PR, nebo navazující PR do týdne; do té doby kapitola nese
  box „Tahle stránka se právě píše" (v release skrytý záznam není, protože `live` záznam text
  vyžaduje – tedy fakticky: release build bez textu neprojde testem). Vlastník rozhodne, zda je to
  příliš tvrdé.
- **OQ-5 Rozpory názvů architektura vs. registr.** `EnemyType.shooter` je v kódu boss; v
  architektuře „The Coagulase Crown". Návrh: id `enemy.boss.staph`, `nameCz` „Zlatý stafylokok
  (boss)", `ref: EnemyType.shooter`; při rozdělení na víc bossů se `shooter` přejmenuje v kódu.

## Před S4

- **OQ-6 Angličtina.** Registr má `nameCz`, `inGameCz`, `realityCz`. Návrh: až s anglickou knihou
  (05-kniha fáze 2) přejít na `Map<Locale, LoreStrings>`; teď jen nepsat do kódu nic, co by to
  blokovalo (žádné `Cz` v id, jen v názvech polí).
- **OQ-7 Report v appce.** `lore_report` běží jen z terminálu. Návrh: nepřidávat debug obrazovku do
  appky; stačí nástroj a CI artefakt.
