// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreBn = LoreTable(
  names: {
    'upgrade.opsonin': 'অপসোনাইজেশন (IgG)',
    'upgrade.histamin': 'হিস্টামিন',
    'upgrade.pyrogen': 'পাইরোজেন (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'মাইটোকন্ড্রিয়া',
    'upgrade.membrana': 'ঝিল্লির তরলতা',
    'upgrade.cytotoxin': 'সাইটোটক্সিক দানা',
    'enemy.swarmer': 'ঝাঁক (কক্কাই)',
    'enemy.tank': 'বায়োফিল্ম (স্ট্যাফাইলোকক্কাসের গুচ্ছ)',
    'enemy.boss': 'সোনালি স্ট্যাফাইলোকক্কাস (বস)',
    'enemy.boss.phase2': 'সোনালি স্ট্যাফাইলোকক্কাস — দ্বিতীয় পর্ব',
    'status.opsonized': 'চিহ্নিত (অপসোনাইজড)',
    'status.slowed': 'ধীর',
    'damage.kinetic': 'শারীরিক ক্ষতি',
    'damage.inflammatory': 'প্রদাহজনিত ক্ষতি',
    'mechanic.fever': 'জ্বর',
    'fever.normo': 'স্বাভাবিক তাপমাত্রা',
    'fever.febrile': 'হালকা জ্বর',
    'fever.hyper': 'উচ্চ জ্বর',
    'fever.critical': 'সংকটজনক জ্বর',
    'room.combat': 'লড়াই',
    'room.elite': 'এলিট',
    'room.treasure': 'নিরাময়',
    'room.boss': 'বস',
    'meta.memoryCells': 'স্মৃতি কোষ',
    'meta.vaccination': 'টিকাদান',
    'ability.phagocytosis': 'ফ্যাগোসাইটোসিস (মৌলিক আক্রমণ)',
    'ability.dash': 'অ্যামিবয়েড চলন (ড্যাশ)',
    'ability.chargeDash': 'ক্ষণপদ (চার্জ ড্যাশ)',
    'ability.oxidativeBurst': 'অক্সিডেটিভ বিস্ফোরণ (ROS)',
    'ability.lysozymeBurst': 'লাইসোজাইম ঝাঁক',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'কৃত্রিম রং (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'আঘাত লক্ষ্যকে চিহ্নিত করে — সেটি {{balance.opsonizedDuration|s}} ধরে {{balance.opsonizedDamageTakenMulti|pctDelta}} ক্ষতি পায়।',
    'upgrade.histamin':
        'আঘাত লক্ষ্যকে {{balance.slowedDuration|s}} ধরে {{balance.slowedSpeedMulti|pctLess}} ধীর করে।',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} ক্ষতি, কিন্তু প্রতিটি গুলি জ্বর বাড়ায়।',
    'upgrade.treg':
        'জ্বর প্রতি সেকেন্ডে {{balance.tregDecayBonus|degC}} দ্রুত কমে।',
    'upgrade.mitochondrie':
        'বিশেষ আক্রমণে {{balance.mitochondrieCostMulti|pctLess}} কম ATP লাগে।',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} সর্বোচ্চ ড্যাশ চার্জ।',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} প্রক্ষেপকের মৌলিক ক্ষতি।',
  },
);
