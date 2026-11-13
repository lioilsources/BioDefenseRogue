// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreSv = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonisering (IgG)',
    'upgrade.histamin': 'Histamin',
    'upgrade.pyrogen': 'Pyrogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitokondrier',
    'upgrade.membrana': 'Membranfluiditet',
    'upgrade.cytotoxin': 'Cytotoxiska granula',
    'enemy.swarmer': 'Svärm (kocker)',
    'enemy.tank': 'Biofilm (kluster av stafylokocker)',
    'enemy.boss': 'Gyllene stafylokock (boss)',
    'enemy.boss.phase2': 'Gyllene stafylokock — andra fasen',
    'status.opsonized': 'Märkt (opsoniserad)',
    'status.slowed': 'Saktad',
    'damage.kinetic': 'Fysisk skada',
    'damage.inflammatory': 'Inflammatorisk skada',
    'mechanic.fever': 'Feber',
    'fever.normo': 'Normal temperatur',
    'fever.febrile': 'Lätt feber',
    'fever.hyper': 'Hög feber',
    'fever.critical': 'Kritisk feber',
    'room.combat': 'Strid',
    'room.elite': 'Elit',
    'room.treasure': 'Läkning',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Minnesceller',
    'meta.vaccination': 'Vaccination',
    'ability.phagocytosis': 'Fagocytos (grundattack)',
    'ability.dash': 'Amöboid rörelse (dash)',
    'ability.chargeDash': 'Pseudopodier (laddad dash)',
    'ability.oxidativeBurst': 'Oxidativ burst (ROS)',
    'ability.lysozymeBurst': 'Lysozymsalva',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Falska färger (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Träffar märker målet — det tar {{balance.opsonizedDamageTakenMulti|pctDelta}} skada i {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Träffar saktar ner målet med {{balance.slowedSpeedMulti|pctLess}} i {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} skada, men varje skott höjer febern.',
    'upgrade.treg':
        'Febern sjunker {{balance.tregDecayBonus|degC}}/s snabbare.',
    'upgrade.mitochondrie':
        'Specialattacken kostar {{balance.mitochondrieCostMulti|pctLess}} mindre ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maximal dashladdning.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} grundskada för projektiler.',
  },
);
