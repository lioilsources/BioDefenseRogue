// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreNb = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonisering (IgG)',
    'upgrade.histamin': 'Histamin',
    'upgrade.pyrogen': 'Pyrogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitokondrier',
    'upgrade.membrana': 'Membranfluiditet',
    'upgrade.cytotoxin': 'Cytotoksiske granula',
    'enemy.swarmer': 'Sverm (kokker)',
    'enemy.tank': 'Biofilm (klynge av stafylokokker)',
    'enemy.boss': 'Gyllen stafylokokk (boss)',
    'enemy.boss.phase2': 'Gyllen stafylokokk — andre fase',
    'status.opsonized': 'Merket (opsonisert)',
    'status.slowed': 'Bremset',
    'damage.kinetic': 'Fysisk skade',
    'damage.inflammatory': 'Betennelsesskade',
    'mechanic.fever': 'Feber',
    'fever.normo': 'Normal temperatur',
    'fever.febrile': 'Lett feber',
    'fever.hyper': 'Høy feber',
    'fever.critical': 'Kritisk feber',
    'room.combat': 'Kamp',
    'room.elite': 'Elite',
    'room.treasure': 'Helbredelse',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Minneceller',
    'meta.vaccination': 'Vaksinasjon',
    'ability.phagocytosis': 'Fagocytose (grunnangrep)',
    'ability.dash': 'Amøboid bevegelse (dash)',
    'ability.chargeDash': 'Pseudopoder (ladet dash)',
    'ability.oxidativeBurst': 'Oksidativt utbrudd (ROS)',
    'ability.lysozymeBurst': 'Lysozymsalve',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Falske farger (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Treff merker målet — det tar {{balance.opsonizedDamageTakenMulti|pctDelta}} skade i {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Treff bremser målet med {{balance.slowedSpeedMulti|pctLess}} i {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} skade, men hvert skudd øker feberen.',
    'upgrade.treg':
        'Feberen synker {{balance.tregDecayBonus|degC}}/s raskere.',
    'upgrade.mitochondrie':
        'Spesialangrepet koster {{balance.mitochondrieCostMulti|pctLess}} mindre ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maksimal dash-lading.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} grunnskade fra prosjektiler.',
  },
);
