// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreAr = LoreTable(
  names: {
    'upgrade.opsonin': 'الطهاية (IgG)',
    'upgrade.histamin': 'الهيستامين',
    'upgrade.pyrogen': 'مولّد الحمى (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'الميتوكوندريا',
    'upgrade.membrana': 'سيولة الغشاء',
    'upgrade.cytotoxin': 'الحبيبات السامة للخلايا',
    'enemy.swarmer': 'سرب (مكورات)',
    'enemy.tank': 'غشاء حيوي (تجمع مكورات عنقودية)',
    'enemy.boss': 'المكورة العنقودية الذهبية (الزعيم)',
    'enemy.boss.phase2': 'المكورة العنقودية الذهبية — المرحلة الثانية',
    'status.opsonized': 'موسوم (مُطهّى)',
    'status.slowed': 'مُبطّأ',
    'damage.kinetic': 'ضرر جسدي',
    'damage.inflammatory': 'ضرر التهابي',
    'mechanic.fever': 'الحمى',
    'fever.normo': 'حرارة طبيعية',
    'fever.febrile': 'حمى خفيفة',
    'fever.hyper': 'حمى مرتفعة',
    'fever.critical': 'حمى حرجة',
    'room.combat': 'قتال',
    'room.elite': 'نخبة',
    'room.treasure': 'علاج',
    'room.boss': 'الزعيم',
    'meta.memoryCells': 'خلايا الذاكرة',
    'meta.vaccination': 'التطعيم',
    'ability.phagocytosis': 'البلعمة (هجوم أساسي)',
    'ability.dash': 'حركة أميبية (اندفاع)',
    'ability.chargeDash': 'الأقدام الكاذبة (اندفاع مشحون)',
    'ability.oxidativeBurst': 'الانفجار التأكسدي (ROS)',
    'ability.lysozymeBurst': 'رشقة الليزوزيم',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'ألوان زائفة (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'الإصابات تَسِم الهدف — يتلقى {{balance.opsonizedDamageTakenMulti|pctDelta}} ضررًا لمدة {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'الإصابات تبطئ الهدف بنسبة {{balance.slowedSpeedMulti|pctLess}} لمدة {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} ضررًا، لكن كل طلقة ترفع الحمى.',
    'upgrade.treg':
        'تنخفض الحمى أسرع بمقدار {{balance.tregDecayBonus|degC}} في الثانية.',
    'upgrade.mitochondrie':
        'يكلّف الهجوم الخاص ATP أقل بنسبة {{balance.mitochondrieCostMulti|pctLess}}.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} شحنة اندفاع قصوى.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} للضرر الأساسي للمقذوفات.',
  },
);
