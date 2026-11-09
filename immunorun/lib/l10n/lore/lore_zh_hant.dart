// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreZhHant = LoreTable(
  names: {
    'upgrade.opsonin': '調理作用（IgG）',
    'upgrade.histamin': '組織胺',
    'upgrade.pyrogen': '致熱原（IL-6）',
    'upgrade.treg': 'Treg（IL-10）',
    'upgrade.mitochondrie': '粒線體',
    'upgrade.membrana': '膜流動性',
    'upgrade.cytotoxin': '細胞毒性顆粒',
    'enemy.swarmer': '菌群（球菌）',
    'enemy.tank': '生物膜（葡萄球菌團）',
    'enemy.boss': '金黃色葡萄球菌（頭目）',
    'enemy.boss.phase2': '金黃色葡萄球菌 — 第二階段',
    'status.opsonized': '已標記（被調理）',
    'status.slowed': '減速',
    'damage.kinetic': '物理傷害',
    'damage.inflammatory': '發炎傷害',
    'mechanic.fever': '發燒',
    'fever.normo': '正常體溫',
    'fever.febrile': '輕微發燒',
    'fever.hyper': '高燒',
    'fever.critical': '危險高燒',
    'room.combat': '戰鬥',
    'room.elite': '菁英',
    'room.treasure': '治療',
    'room.boss': '頭目',
    'meta.memoryCells': '記憶細胞',
    'meta.vaccination': '接種疫苗',
    'ability.phagocytosis': '吞噬作用（基本攻擊）',
    'ability.dash': '變形運動（衝刺）',
    'ability.chargeDash': '偽足（蓄力衝刺）',
    'ability.oxidativeBurst': '氧化爆發（ROS）',
    'ability.lysozymeBurst': '溶菌酶齊射',
    'resource.atp': 'ATP',
    'mechanic.microscope': '偽色彩（SEM）',
  },
  inGame: {
    'upgrade.opsonin':
        '命中會標記目標，在 {{balance.opsonizedDuration|s}} 內受到的傷害 {{balance.opsonizedDamageTakenMulti|pctDelta}}。',
    'upgrade.histamin':
        '命中使目標減速 {{balance.slowedSpeedMulti|pctLess}}，持續 {{balance.slowedDuration|s}}。',
    'upgrade.pyrogen':
        '傷害 {{balance.pyrogenDamageMulti|pctDelta}}，但每次射擊都會讓體溫升高。',
    'upgrade.treg':
        '體溫每秒多下降 {{balance.tregDecayBonus|degC}}。',
    'upgrade.mitochondrie':
        '特殊攻擊消耗的 ATP 減少 {{balance.mitochondrieCostMulti|pctLess}}。',
    'upgrade.membrana':
        '衝刺最大次數 +{{balance.membranaExtraDashCharges|int}}。',
    'upgrade.cytotoxin':
        '彈體基本傷害 {{balance.cytotoxinDamageMulti|pctDelta}}。',
  },
);
