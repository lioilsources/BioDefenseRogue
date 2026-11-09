// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreJa = LoreTable(
  names: {
    'upgrade.opsonin': 'オプソニン化（IgG）',
    'upgrade.histamin': 'ヒスタミン',
    'upgrade.pyrogen': '発熱物質（IL-6）',
    'upgrade.treg': 'Treg（IL-10）',
    'upgrade.mitochondrie': 'ミトコンドリア',
    'upgrade.membrana': '膜の流動性',
    'upgrade.cytotoxin': '細胞傷害性顆粒',
    'enemy.swarmer': '群れ（球菌）',
    'enemy.tank': 'バイオフィルム（ブドウ球菌の塊）',
    'enemy.boss': '黄色ブドウ球菌（ボス）',
    'enemy.boss.phase2': '黄色ブドウ球菌 — 第2形態',
    'status.opsonized': 'マーク済み（オプソニン化）',
    'status.slowed': '減速',
    'damage.kinetic': '物理ダメージ',
    'damage.inflammatory': '炎症ダメージ',
    'mechanic.fever': '発熱',
    'fever.normo': '平熱',
    'fever.febrile': '微熱',
    'fever.hyper': '高熱',
    'fever.critical': '危険な高熱',
    'room.combat': '戦闘',
    'room.elite': 'エリート',
    'room.treasure': '回復',
    'room.boss': 'ボス',
    'meta.memoryCells': '記憶細胞',
    'meta.vaccination': 'ワクチン接種',
    'ability.phagocytosis': '食作用（通常攻撃）',
    'ability.dash': 'アメーバ運動（ダッシュ）',
    'ability.chargeDash': '仮足（チャージダッシュ）',
    'ability.oxidativeBurst': '酸化的バースト（ROS）',
    'ability.lysozymeBurst': 'リゾチーム一斉射撃',
    'resource.atp': 'ATP',
    'mechanic.microscope': '疑似カラー（SEM）',
  },
  inGame: {
    'upgrade.opsonin':
        '攻撃が標的にマークを付け、{{balance.opsonizedDuration|s}}の間、受けるダメージが{{balance.opsonizedDamageTakenMulti|pctDelta}}。',
    'upgrade.histamin':
        '攻撃が標的を{{balance.slowedDuration|s}}の間、{{balance.slowedSpeedMulti|pctLess}}減速させる。',
    'upgrade.pyrogen':
        'ダメージ{{balance.pyrogenDamageMulti|pctDelta}}。ただし撃つたびに熱が上がる。',
    'upgrade.treg':
        '熱が毎秒{{balance.tregDecayBonus|degC}}早く下がる。',
    'upgrade.mitochondrie':
        '特殊攻撃のATPコストが{{balance.mitochondrieCostMulti|pctLess}}減る。',
    'upgrade.membrana':
        'ダッシュの最大チャージ+{{balance.membranaExtraDashCharges|int}}。',
    'upgrade.cytotoxin':
        '弾の基本ダメージ{{balance.cytotoxinDamageMulti|pctDelta}}。',
  },
);
