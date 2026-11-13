// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreDa = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonisering (IgG)',
    'upgrade.histamin': 'Histamin',
    'upgrade.pyrogen': 'Pyrogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitokondrier',
    'upgrade.membrana': 'Membranfluiditet',
    'upgrade.cytotoxin': 'Cytotoksiske granula',
    'enemy.swarmer': 'Sværm (kokker)',
    'enemy.tank': 'Biofilm (klynge af stafylokokker)',
    'enemy.boss': 'Gylden stafylokok (boss)',
    'enemy.boss.phase2': 'Gylden stafylokok — anden fase',
    'status.opsonized': 'Mærket (opsoniseret)',
    'status.slowed': 'Bremset',
    'damage.kinetic': 'Fysisk skade',
    'damage.inflammatory': 'Inflammatorisk skade',
    'mechanic.fever': 'Feber',
    'fever.normo': 'Normal temperatur',
    'fever.febrile': 'Let feber',
    'fever.hyper': 'Høj feber',
    'fever.critical': 'Kritisk feber',
    'room.combat': 'Kamp',
    'room.elite': 'Elite',
    'room.treasure': 'Heling',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Hukommelsesceller',
    'meta.vaccination': 'Vaccination',
    'ability.phagocytosis': 'Fagocytose (basisangreb)',
    'ability.dash': 'Amøboid bevægelse (dash)',
    'ability.chargeDash': 'Skinfødder (ladet dash)',
    'ability.oxidativeBurst': 'Oxidativt udbrud (ROS)',
    'ability.lysozymeBurst': 'Lysozymsalve',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Falske farver (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Træffere mærker målet — det tager {{balance.opsonizedDamageTakenMulti|pctDelta}} skade i {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Træffere bremser målet med {{balance.slowedSpeedMulti|pctLess}} i {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} skade, men hvert skud hæver feberen.',
    'upgrade.treg':
        'Feberen falder {{balance.tregDecayBonus|degC}}/s hurtigere.',
    'upgrade.mitochondrie':
        'Specialangrebet koster {{balance.mitochondrieCostMulti|pctLess}} mindre ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maksimal dash-ladning.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} grundskade fra projektiler.',
  },
);
