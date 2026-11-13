// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreHr = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonizacija (IgG)',
    'upgrade.histamin': 'Histamin',
    'upgrade.pyrogen': 'Pirogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitohondriji',
    'upgrade.membrana': 'Fluidnost membrane',
    'upgrade.cytotoxin': 'Citotoksične granule',
    'enemy.swarmer': 'Roj (koki)',
    'enemy.tank': 'Biofilm (nakupina stafilokoka)',
    'enemy.boss': 'Zlatni stafilokok (šef)',
    'enemy.boss.phase2': 'Zlatni stafilokok — druga faza',
    'status.opsonized': 'Označen (opsoniziran)',
    'status.slowed': 'Usporen',
    'damage.kinetic': 'Fizička šteta',
    'damage.inflammatory': 'Upalna šteta',
    'mechanic.fever': 'Vrućica',
    'fever.normo': 'Normalna temperatura',
    'fever.febrile': 'Blaga vrućica',
    'fever.hyper': 'Visoka vrućica',
    'fever.critical': 'Kritična vrućica',
    'room.combat': 'Borba',
    'room.elite': 'Elita',
    'room.treasure': 'Liječenje',
    'room.boss': 'Šef',
    'meta.memoryCells': 'Memorijske stanice',
    'meta.vaccination': 'Cijepljenje',
    'ability.phagocytosis': 'Fagocitoza (osnovni napad)',
    'ability.dash': 'Ameboidno kretanje (trzaj)',
    'ability.chargeDash': 'Pseudopodiji (nabijeni trzaj)',
    'ability.oxidativeBurst': 'Oksidativni prasak (ROS)',
    'ability.lysozymeBurst': 'Lizozimski plotun',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Lažne boje (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Pogoci označavaju metu — prima {{balance.opsonizedDamageTakenMulti|pctDelta}} štete tijekom {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Pogoci usporavaju metu za {{balance.slowedSpeedMulti|pctLess}} na {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} štete, ali svaki hitac podiže vrućicu.',
    'upgrade.treg':
        'Vrućica pada {{balance.tregDecayBonus|degC}}/s brže.',
    'upgrade.mitochondrie':
        'Posebni napad troši {{balance.mitochondrieCostMulti|pctLess}} manje ATP-a.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maksimalni naboj trzaja.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} osnovne štete projektila.',
  },
);
