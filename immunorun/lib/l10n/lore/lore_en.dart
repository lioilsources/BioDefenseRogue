// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreEn = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonization (IgG)',
    'upgrade.histamin': 'Histamine',
    'upgrade.pyrogen': 'Pyrogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitochondria',
    'upgrade.membrana': 'Membrane fluidity',
    'upgrade.cytotoxin': 'Cytotoxic granules',
    'enemy.swarmer': 'Swarm (cocci)',
    'enemy.tank': 'Biofilm (staphylococcus cluster)',
    'enemy.boss': 'Golden staph (boss)',
    'enemy.boss.phase2': 'Golden staph — second phase',
    'status.opsonized': 'Tagged (opsonized)',
    'status.slowed': 'Slowed',
    'damage.kinetic': 'Physical damage',
    'damage.inflammatory': 'Inflammatory damage',
    'mechanic.fever': 'Fever',
    'fever.normo': 'Normal temperature',
    'fever.febrile': 'Mild fever',
    'fever.hyper': 'High fever',
    'fever.critical': 'Critical fever',
    'room.combat': 'Combat',
    'room.elite': 'Elite',
    'room.treasure': 'Healing',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Memory cells',
    'meta.vaccination': 'Vaccination',
    'ability.phagocytosis': 'Phagocytosis (basic attack)',
    'ability.dash': 'Amoeboid movement (dash)',
    'ability.chargeDash': 'Pseudopods (charged dash)',
    'ability.oxidativeBurst': 'Oxidative burst (ROS)',
    'ability.lysozymeBurst': 'Lysozyme salvo',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'False colors (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Hits tag the target — it takes {{balance.opsonizedDamageTakenMulti|pctDelta}} damage for {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Hits slow the target by {{balance.slowedSpeedMulti|pctLess}} for {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} damage, but every shot raises your fever.',
    'upgrade.treg':
        'Fever drops {{balance.tregDecayBonus|degC}}/s faster.',
    'upgrade.mitochondrie':
        'The special attack costs {{balance.mitochondrieCostMulti|pctLess}} less ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maximum dash charge.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} base projectile damage.',
  },
);
