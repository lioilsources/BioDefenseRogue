// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreHe = LoreTable(
  names: {
    'upgrade.opsonin': 'אופסוניזציה (IgG)',
    'upgrade.histamin': 'היסטמין',
    'upgrade.pyrogen': 'פירוגן (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'מיטוכונדריה',
    'upgrade.membrana': 'נזילות הקרום',
    'upgrade.cytotoxin': 'גרנולות ציטוטוקסיות',
    'enemy.swarmer': 'נחיל (קוקים)',
    'enemy.tank': 'ביופילם (צביר סטפילוקוקים)',
    'enemy.boss': 'סטפילוקוק זהוב (בוס)',
    'enemy.boss.phase2': 'סטפילוקוק זהוב — שלב שני',
    'status.opsonized': 'מסומן (מאופסן)',
    'status.slowed': 'מואט',
    'damage.kinetic': 'נזק פיזי',
    'damage.inflammatory': 'נזק דלקתי',
    'mechanic.fever': 'חום',
    'fever.normo': 'טמפרטורה תקינה',
    'fever.febrile': 'חום קל',
    'fever.hyper': 'חום גבוה',
    'fever.critical': 'חום קריטי',
    'room.combat': 'קרב',
    'room.elite': 'עילית',
    'room.treasure': 'ריפוי',
    'room.boss': 'בוס',
    'meta.memoryCells': 'תאי זיכרון',
    'meta.vaccination': 'חיסון',
    'ability.phagocytosis': 'פגוציטוזה (התקפה בסיסית)',
    'ability.dash': 'תנועה אמבואידית (זינוק)',
    'ability.chargeDash': 'רגלים מדומות (זינוק טעון)',
    'ability.oxidativeBurst': 'התפרצות חמצונית (ROS)',
    'ability.lysozymeBurst': 'מטח ליזוזים',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'צבעים מלאכותיים (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'הפגיעות מסמנות את המטרה — היא סופגת {{balance.opsonizedDamageTakenMulti|pctDelta}} נזק למשך {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'הפגיעות מאטות את המטרה ב־{{balance.slowedSpeedMulti|pctLess}} למשך {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} נזק, אבל כל ירייה מעלה את החום.',
    'upgrade.treg':
        'החום יורד מהר יותר ב־{{balance.tregDecayBonus|degC}} לשנייה.',
    'upgrade.mitochondrie':
        'ההתקפה המיוחדת עולה {{balance.mitochondrieCostMulti|pctLess}} פחות ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} מטען זינוק מרבי.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} לנזק הבסיסי של הקליעים.',
  },
);
