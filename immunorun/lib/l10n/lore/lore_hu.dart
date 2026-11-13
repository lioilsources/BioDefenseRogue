// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreHu = LoreTable(
  names: {
    'upgrade.opsonin': 'Opszonizáció (IgG)',
    'upgrade.histamin': 'Hisztamin',
    'upgrade.pyrogen': 'Pirogén (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitokondriumok',
    'upgrade.membrana': 'Membránfluiditás',
    'upgrade.cytotoxin': 'Citotoxikus granulumok',
    'enemy.swarmer': 'Raj (coccusok)',
    'enemy.tank': 'Biofilm (staphylococcus-csomó)',
    'enemy.boss': 'Arany staphylococcus (főellenség)',
    'enemy.boss.phase2': 'Arany staphylococcus — második fázis',
    'status.opsonized': 'Megjelölt (opszonizált)',
    'status.slowed': 'Lelassított',
    'damage.kinetic': 'Fizikai sebzés',
    'damage.inflammatory': 'Gyulladásos sebzés',
    'mechanic.fever': 'Láz',
    'fever.normo': 'Normál testhő',
    'fever.febrile': 'Enyhe láz',
    'fever.hyper': 'Magas láz',
    'fever.critical': 'Kritikus láz',
    'room.combat': 'Harc',
    'room.elite': 'Elit',
    'room.treasure': 'Gyógyulás',
    'room.boss': 'Főellenség',
    'meta.memoryCells': 'Memóriasejtek',
    'meta.vaccination': 'Védőoltás',
    'ability.phagocytosis': 'Fagocitózis (alaptámadás)',
    'ability.dash': 'Amőboid mozgás (roham)',
    'ability.chargeDash': 'Álláb (töltött roham)',
    'ability.oxidativeBurst': 'Oxidatív robbanás (ROS)',
    'ability.lysozymeBurst': 'Lizozimsortűz',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Hamis színek (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'A találatok megjelölik a célt — {{balance.opsonizedDamageTakenMulti|pctDelta}} sebzést kap {{balance.opsonizedDuration|s}} időre.',
    'upgrade.histamin':
        'A találatok {{balance.slowedSpeedMulti|pctLess}}-kal lassítják a célt {{balance.slowedDuration|s}} időre.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} sebzés, de minden lövés emeli a lázat.',
    'upgrade.treg':
        'A láz {{balance.tregDecayBonus|degC}}/s-mal gyorsabban csökken.',
    'upgrade.mitochondrie':
        'A különleges támadás {{balance.mitochondrieCostMulti|pctLess}}-kal kevesebb ATP-be kerül.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maximális rohamtöltet.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} lövedék-alapsebzés.',
  },
);
