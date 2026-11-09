// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreZh = LoreTable(
  names: {
    'upgrade.opsonin': '调理作用（IgG）',
    'upgrade.histamin': '组胺',
    'upgrade.pyrogen': '致热原（IL-6）',
    'upgrade.treg': 'Treg（IL-10）',
    'upgrade.mitochondrie': '线粒体',
    'upgrade.membrana': '膜流动性',
    'upgrade.cytotoxin': '细胞毒性颗粒',
    'enemy.swarmer': '菌群（球菌）',
    'enemy.tank': '生物膜（葡萄球菌团）',
    'enemy.boss': '金黄色葡萄球菌（首领）',
    'enemy.boss.phase2': '金黄色葡萄球菌 — 第二阶段',
    'status.opsonized': '已标记（被调理）',
    'status.slowed': '减速',
    'damage.kinetic': '物理伤害',
    'damage.inflammatory': '炎症伤害',
    'mechanic.fever': '发烧',
    'fever.normo': '正常体温',
    'fever.febrile': '低烧',
    'fever.hyper': '高烧',
    'fever.critical': '危险高烧',
    'room.combat': '战斗',
    'room.elite': '精英',
    'room.treasure': '治疗',
    'room.boss': '首领',
    'meta.memoryCells': '记忆细胞',
    'meta.vaccination': '接种疫苗',
    'ability.phagocytosis': '吞噬作用（基础攻击）',
    'ability.dash': '变形运动（冲刺）',
    'ability.chargeDash': '伪足（蓄力冲刺）',
    'ability.oxidativeBurst': '氧化爆发（ROS）',
    'ability.lysozymeBurst': '溶菌酶齐射',
    'resource.atp': 'ATP',
    'mechanic.microscope': '伪彩色（SEM）',
  },
  inGame: {
    'upgrade.opsonin':
        '命中会标记目标，在 {{balance.opsonizedDuration|s}} 内受到的伤害 {{balance.opsonizedDamageTakenMulti|pctDelta}}。',
    'upgrade.histamin':
        '命中使目标减速 {{balance.slowedSpeedMulti|pctLess}}，持续 {{balance.slowedDuration|s}}。',
    'upgrade.pyrogen':
        '伤害 {{balance.pyrogenDamageMulti|pctDelta}}，但每次射击都会让体温升高。',
    'upgrade.treg':
        '体温每秒多下降 {{balance.tregDecayBonus|degC}}。',
    'upgrade.mitochondrie':
        '特殊攻击消耗的 ATP 减少 {{balance.mitochondrieCostMulti|pctLess}}。',
    'upgrade.membrana':
        '冲刺最大次数 +{{balance.membranaExtraDashCharges|int}}。',
    'upgrade.cytotoxin':
        '弹体基础伤害 {{balance.cytotoxinDamageMulti|pctDelta}}。',
  },
);
