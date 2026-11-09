// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreSl = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonizacija (IgG)',
    'upgrade.histamin': 'Histamin',
    'upgrade.pyrogen': 'Pirogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitohondriji',
    'upgrade.membrana': 'Fluidnost membrane',
    'upgrade.cytotoxin': 'Citotoksična zrnca',
    'enemy.swarmer': 'Roj (koki)',
    'enemy.tank': 'Biofilm (skupek stafilokokov)',
    'enemy.boss': 'Zlati stafilokok (šef)',
    'enemy.boss.phase2': 'Zlati stafilokok — druga faza',
    'status.opsonized': 'Označen (opsoniziran)',
    'status.slowed': 'Upočasnjen',
    'damage.kinetic': 'Fizična škoda',
    'damage.inflammatory': 'Vnetna škoda',
    'mechanic.fever': 'Vročina',
    'fever.normo': 'Normalna temperatura',
    'fever.febrile': 'Blaga vročina',
    'fever.hyper': 'Visoka vročina',
    'fever.critical': 'Kritična vročina',
    'room.combat': 'Boj',
    'room.elite': 'Elita',
    'room.treasure': 'Zdravljenje',
    'room.boss': 'Šef',
    'meta.memoryCells': 'Spominske celice',
    'meta.vaccination': 'Cepljenje',
    'ability.phagocytosis': 'Fagocitoza (osnovni napad)',
    'ability.dash': 'Ameboidno gibanje (sunek)',
    'ability.chargeDash': 'Panožice (nabit sunek)',
    'ability.oxidativeBurst': 'Oksidativni izbruh (ROS)',
    'ability.lysozymeBurst': 'Lizocimska salva',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Lažne barve (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Zadetki označijo tarčo — prejme {{balance.opsonizedDamageTakenMulti|pctDelta}} škode za {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Zadetki upočasnijo tarčo za {{balance.slowedSpeedMulti|pctLess}} za {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} škode, a vsak strel dvigne vročino.',
    'upgrade.treg':
        'Vročina pada {{balance.tregDecayBonus|degC}}/s hitreje.',
    'upgrade.mitochondrie':
        'Posebni napad stane {{balance.mitochondrieCostMulti|pctLess}} manj ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} največji naboj sunka.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} osnovne škode izstrelkov.',
  },
);
