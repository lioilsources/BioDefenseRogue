// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreTr = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonizasyon (IgG)',
    'upgrade.histamin': 'Histamin',
    'upgrade.pyrogen': 'Pirojen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitokondri',
    'upgrade.membrana': 'Zar akışkanlığı',
    'upgrade.cytotoxin': 'Sitotoksik granüller',
    'enemy.swarmer': 'Sürü (koklar)',
    'enemy.tank': 'Biyofilm (stafilokok kümesi)',
    'enemy.boss': 'Altın stafilokok (boss)',
    'enemy.boss.phase2': 'Altın stafilokok — ikinci aşama',
    'status.opsonized': 'İşaretli (opsonize)',
    'status.slowed': 'Yavaşlamış',
    'damage.kinetic': 'Fiziksel hasar',
    'damage.inflammatory': 'İltihabi hasar',
    'mechanic.fever': 'Ateş',
    'fever.normo': 'Normal sıcaklık',
    'fever.febrile': 'Hafif ateş',
    'fever.hyper': 'Yüksek ateş',
    'fever.critical': 'Kritik ateş',
    'room.combat': 'Savaş',
    'room.elite': 'Elit',
    'room.treasure': 'İyileşme',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Bellek hücreleri',
    'meta.vaccination': 'Aşılama',
    'ability.phagocytosis': 'Fagositoz (temel saldırı)',
    'ability.dash': 'Amipsi hareket (atılma)',
    'ability.chargeDash': 'Yalancı ayaklar (yüklü atılma)',
    'ability.oxidativeBurst': 'Oksidatif patlama (ROS)',
    'ability.lysozymeBurst': 'Lizozim yaylımı',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Sahte renkler (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Vuruşlar hedefi işaretler — {{balance.opsonizedDuration|s}} boyunca {{balance.opsonizedDamageTakenMulti|pctDelta}} hasar alır.',
    'upgrade.histamin':
        'Vuruşlar hedefi {{balance.slowedDuration|s}} boyunca {{balance.slowedSpeedMulti|pctLess}} yavaşlatır.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} hasar, ama her atış ateşi yükseltir.',
    'upgrade.treg':
        'Ateş saniyede {{balance.tregDecayBonus|degC}} daha hızlı düşer.',
    'upgrade.mitochondrie':
        'Özel saldırı {{balance.mitochondrieCostMulti|pctLess}} daha az ATP harcar.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maksimum atılma hakkı.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} temel mermi hasarı.',
  },
);
