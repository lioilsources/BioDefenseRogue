// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreId = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonisasi (IgG)',
    'upgrade.histamin': 'Histamin',
    'upgrade.pyrogen': 'Pirogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitokondria',
    'upgrade.membrana': 'Fluiditas membran',
    'upgrade.cytotoxin': 'Granula sitotoksik',
    'enemy.swarmer': 'Kawanan (kokus)',
    'enemy.tank': 'Biofilm (gumpalan stafilokokus)',
    'enemy.boss': 'Stafilokokus emas (bos)',
    'enemy.boss.phase2': 'Stafilokokus emas — fase kedua',
    'status.opsonized': 'Ditandai (teropsonisasi)',
    'status.slowed': 'Melambat',
    'damage.kinetic': 'Kerusakan fisik',
    'damage.inflammatory': 'Kerusakan peradangan',
    'mechanic.fever': 'Demam',
    'fever.normo': 'Suhu normal',
    'fever.febrile': 'Demam ringan',
    'fever.hyper': 'Demam tinggi',
    'fever.critical': 'Demam kritis',
    'room.combat': 'Pertarungan',
    'room.elite': 'Elite',
    'room.treasure': 'Penyembuhan',
    'room.boss': 'Bos',
    'meta.memoryCells': 'Sel memori',
    'meta.vaccination': 'Vaksinasi',
    'ability.phagocytosis': 'Fagositosis (serangan dasar)',
    'ability.dash': 'Gerak ameboid (dash)',
    'ability.chargeDash': 'Kaki semu (dash bertenaga)',
    'ability.oxidativeBurst': 'Ledakan oksidatif (ROS)',
    'ability.lysozymeBurst': 'Salvo lisozim',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Warna palsu (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Serangan menandai target — ia menerima {{balance.opsonizedDamageTakenMulti|pctDelta}} kerusakan selama {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Serangan memperlambat target sebesar {{balance.slowedSpeedMulti|pctLess}} selama {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} kerusakan, tetapi setiap tembakan menaikkan demam.',
    'upgrade.treg':
        'Demam turun {{balance.tregDecayBonus|degC}}/dtk lebih cepat.',
    'upgrade.mitochondrie':
        'Serangan khusus memakai ATP {{balance.mitochondrieCostMulti|pctLess}} lebih sedikit.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} muatan dash maksimum.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} kerusakan dasar proyektil.',
  },
);
