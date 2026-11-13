// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreMs = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonisasi (IgG)',
    'upgrade.histamin': 'Histamin',
    'upgrade.pyrogen': 'Pirogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitokondria',
    'upgrade.membrana': 'Kebendaliran membran',
    'upgrade.cytotoxin': 'Granul sitotoksik',
    'enemy.swarmer': 'Kawanan (kokus)',
    'enemy.tank': 'Biofilem (gugusan stafilokokus)',
    'enemy.boss': 'Stafilokokus emas (bos)',
    'enemy.boss.phase2': 'Stafilokokus emas — fasa kedua',
    'status.opsonized': 'Ditanda (diopsonisasi)',
    'status.slowed': 'Diperlahankan',
    'damage.kinetic': 'Kerosakan fizikal',
    'damage.inflammatory': 'Kerosakan radang',
    'mechanic.fever': 'Demam',
    'fever.normo': 'Suhu normal',
    'fever.febrile': 'Demam ringan',
    'fever.hyper': 'Demam tinggi',
    'fever.critical': 'Demam kritikal',
    'room.combat': 'Pertempuran',
    'room.elite': 'Elit',
    'room.treasure': 'Penyembuhan',
    'room.boss': 'Bos',
    'meta.memoryCells': 'Sel memori',
    'meta.vaccination': 'Vaksinasi',
    'ability.phagocytosis': 'Fagositosis (serangan asas)',
    'ability.dash': 'Gerakan ameboid (luru)',
    'ability.chargeDash': 'Kaki palsu (luru bercas)',
    'ability.oxidativeBurst': 'Letusan oksidatif (ROS)',
    'ability.lysozymeBurst': 'Tembakan lisozim',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Warna palsu (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Serangan menanda sasaran — ia menerima {{balance.opsonizedDamageTakenMulti|pctDelta}} kerosakan selama {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Serangan memperlahankan sasaran sebanyak {{balance.slowedSpeedMulti|pctLess}} selama {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} kerosakan, tetapi setiap tembakan menaikkan demam.',
    'upgrade.treg':
        'Demam turun {{balance.tregDecayBonus|degC}}/saat lebih cepat.',
    'upgrade.mitochondrie':
        'Serangan khas menggunakan {{balance.mitochondrieCostMulti|pctLess}} kurang ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} cas luru maksimum.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} kerosakan asas peluru.',
  },
);
