// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreUr = LoreTable(
  names: {
    'upgrade.opsonin': 'اوپسونائزیشن (IgG)',
    'upgrade.histamin': 'ہسٹامین',
    'upgrade.pyrogen': 'پائروجن (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'مائٹوکونڈریا',
    'upgrade.membrana': 'جھلی کی روانی',
    'upgrade.cytotoxin': 'سائٹوٹاکسک دانے',
    'enemy.swarmer': 'غول (کوکائی)',
    'enemy.tank': 'بائیوفلم (اسٹیفیلوکوکس کا گچھا)',
    'enemy.boss': 'سنہری اسٹیفیلوکوکس (باس)',
    'enemy.boss.phase2': 'سنہری اسٹیفیلوکوکس — دوسرا مرحلہ',
    'status.opsonized': 'نشان زدہ (اوپسونائزڈ)',
    'status.slowed': 'سست',
    'damage.kinetic': 'جسمانی نقصان',
    'damage.inflammatory': 'سوزشی نقصان',
    'mechanic.fever': 'بخار',
    'fever.normo': 'معمول کا درجہ حرارت',
    'fever.febrile': 'ہلکا بخار',
    'fever.hyper': 'تیز بخار',
    'fever.critical': 'خطرناک بخار',
    'room.combat': 'لڑائی',
    'room.elite': 'ایلیٹ',
    'room.treasure': 'علاج',
    'room.boss': 'باس',
    'meta.memoryCells': 'یادداشتی خلیے',
    'meta.vaccination': 'ویکسینیشن',
    'ability.phagocytosis': 'فیگوسائٹوسس (بنیادی حملہ)',
    'ability.dash': 'امیبائی حرکت (ڈیش)',
    'ability.chargeDash': 'کاذب پاؤں (چارج ڈیش)',
    'ability.oxidativeBurst': 'آکسیڈیٹو دھماکا (ROS)',
    'ability.lysozymeBurst': 'لائسوزائم بوچھاڑ',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'مصنوعی رنگ (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'وار ہدف پر نشان لگاتے ہیں — وہ {{balance.opsonizedDuration|s}} تک {{balance.opsonizedDamageTakenMulti|pctDelta}} نقصان اٹھاتا ہے۔',
    'upgrade.histamin':
        'وار ہدف کو {{balance.slowedDuration|s}} کے لیے {{balance.slowedSpeedMulti|pctLess}} سست کرتے ہیں۔',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} نقصان، لیکن ہر گولی بخار بڑھاتی ہے۔',
    'upgrade.treg':
        'بخار {{balance.tregDecayBonus|degC}} فی سیکنڈ تیزی سے اترتا ہے۔',
    'upgrade.mitochondrie':
        'خاص حملے پر {{balance.mitochondrieCostMulti|pctLess}} کم ATP لگتا ہے۔',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} زیادہ سے زیادہ ڈیش چارج۔',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} گولیوں کا بنیادی نقصان۔',
  },
);
