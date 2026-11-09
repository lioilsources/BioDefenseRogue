// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreCa = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonització (IgG)',
    'upgrade.histamin': 'Histamina',
    'upgrade.pyrogen': 'Pirogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitocondris',
    'upgrade.membrana': 'Fluïdesa de membrana',
    'upgrade.cytotoxin': 'Grànuls citotòxics',
    'enemy.swarmer': 'Eixam (cocs)',
    'enemy.tank': 'Biofilm (grup d\'estafilococs)',
    'enemy.boss': 'Estafilococ daurat (cap)',
    'enemy.boss.phase2': 'Estafilococ daurat — segona fase',
    'status.opsonized': 'Marcat (opsonitzat)',
    'status.slowed': 'Alentit',
    'damage.kinetic': 'Dany físic',
    'damage.inflammatory': 'Dany inflamatori',
    'mechanic.fever': 'Febre',
    'fever.normo': 'Temperatura normal',
    'fever.febrile': 'Febre lleu',
    'fever.hyper': 'Febre alta',
    'fever.critical': 'Febre crítica',
    'room.combat': 'Combat',
    'room.elite': 'Elit',
    'room.treasure': 'Curació',
    'room.boss': 'Cap',
    'meta.memoryCells': 'Cèl·lules de memòria',
    'meta.vaccination': 'Vacunació',
    'ability.phagocytosis': 'Fagocitosi (atac bàsic)',
    'ability.dash': 'Moviment ameboide (envestida)',
    'ability.chargeDash': 'Pseudòpodes (envestida carregada)',
    'ability.oxidativeBurst': 'Esclat oxidatiu (ROS)',
    'ability.lysozymeBurst': 'Salva de lisozim',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Colors falsos (MEB)',
  },
  inGame: {
    'upgrade.opsonin':
        'Els impactes marquen l\'objectiu — rep {{balance.opsonizedDamageTakenMulti|pctDelta}} de dany durant {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Els impactes alenteixen l\'objectiu un {{balance.slowedSpeedMulti|pctLess}} durant {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} de dany, però cada tret puja la febre.',
    'upgrade.treg':
        'La febre baixa {{balance.tregDecayBonus|degC}}/s més de pressa.',
    'upgrade.mitochondrie':
        'L\'atac especial costa un {{balance.mitochondrieCostMulti|pctLess}} menys d\'ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} càrrega màxima d\'envestida.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} de dany base dels projectils.',
  },
);
