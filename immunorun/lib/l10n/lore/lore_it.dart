// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreIt = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonizzazione (IgG)',
    'upgrade.histamin': 'Istamina',
    'upgrade.pyrogen': 'Pirogeno (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitocondri',
    'upgrade.membrana': 'Fluidità di membrana',
    'upgrade.cytotoxin': 'Granuli citotossici',
    'enemy.swarmer': 'Sciame (cocchi)',
    'enemy.tank': 'Biofilm (ammasso di stafilococchi)',
    'enemy.boss': 'Stafilococco aureo (boss)',
    'enemy.boss.phase2': 'Stafilococco aureo — seconda fase',
    'status.opsonized': 'Marcato (opsonizzato)',
    'status.slowed': 'Rallentato',
    'damage.kinetic': 'Danno fisico',
    'damage.inflammatory': 'Danno infiammatorio',
    'mechanic.fever': 'Febbre',
    'fever.normo': 'Temperatura normale',
    'fever.febrile': 'Febbre lieve',
    'fever.hyper': 'Febbre alta',
    'fever.critical': 'Febbre critica',
    'room.combat': 'Combattimento',
    'room.elite': 'Élite',
    'room.treasure': 'Cura',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Cellule della memoria',
    'meta.vaccination': 'Vaccinazione',
    'ability.phagocytosis': 'Fagocitosi (attacco base)',
    'ability.dash': 'Movimento ameboide (scatto)',
    'ability.chargeDash': 'Pseudopodi (scatto caricato)',
    'ability.oxidativeBurst': 'Burst ossidativo (ROS)',
    'ability.lysozymeBurst': 'Raffica di lisozima',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Falsi colori (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'I colpi marcano il bersaglio — subisce {{balance.opsonizedDamageTakenMulti|pctDelta}} di danni per {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'I colpi rallentano il bersaglio del {{balance.slowedSpeedMulti|pctLess}} per {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} di danni, ma ogni colpo alza la febbre.',
    'upgrade.treg':
        'La febbre scende di {{balance.tregDecayBonus|degC}}/s più in fretta.',
    'upgrade.mitochondrie':
        'L\'attacco speciale costa il {{balance.mitochondrieCostMulti|pctLess}} di ATP in meno.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} carica di scatto massima.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} di danno base dei proiettili.',
  },
);
