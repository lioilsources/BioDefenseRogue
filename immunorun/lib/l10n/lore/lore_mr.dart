// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreMr = LoreTable(
  names: {
    'upgrade.opsonin': 'ऑप्सोनायझेशन (IgG)',
    'upgrade.histamin': 'हिस्टामिन',
    'upgrade.pyrogen': 'पायरोजन (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'मायटोकॉन्ड्रिया',
    'upgrade.membrana': 'पटलाची प्रवाहीता',
    'upgrade.cytotoxin': 'सायटोटॉक्सिक कण',
    'enemy.swarmer': 'थवा (कोकाय)',
    'enemy.tank': 'बायोफिल्म (स्टॅफिलोकोकसचा पुंजका)',
    'enemy.boss': 'सोनेरी स्टॅफिलोकोकस (बॉस)',
    'enemy.boss.phase2': 'सोनेरी स्टॅफिलोकोकस — दुसरा टप्पा',
    'status.opsonized': 'चिन्हांकित (ऑप्सोनाइज्ड)',
    'status.slowed': 'मंदावलेला',
    'damage.kinetic': 'शारीरिक नुकसान',
    'damage.inflammatory': 'दाहजन्य नुकसान',
    'mechanic.fever': 'ताप',
    'fever.normo': 'सामान्य तापमान',
    'fever.febrile': 'सौम्य ताप',
    'fever.hyper': 'जास्त ताप',
    'fever.critical': 'गंभीर ताप',
    'room.combat': 'लढाई',
    'room.elite': 'एलिट',
    'room.treasure': 'उपचार',
    'room.boss': 'बॉस',
    'meta.memoryCells': 'स्मृती पेशी',
    'meta.vaccination': 'लसीकरण',
    'ability.phagocytosis': 'फॅगोसायटोसिस (मूळ हल्ला)',
    'ability.dash': 'अमिबासारखी हालचाल (डॅश)',
    'ability.chargeDash': 'छद्मपाद (चार्ज डॅश)',
    'ability.oxidativeBurst': 'ऑक्सिडेटिव्ह स्फोट (ROS)',
    'ability.lysozymeBurst': 'लायसोझाइम मारा',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'कृत्रिम रंग (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'प्रहार लक्ष्यावर खूण करतात — त्याला {{balance.opsonizedDuration|s}} पर्यंत {{balance.opsonizedDamageTakenMulti|pctDelta}} नुकसान होते.',
    'upgrade.histamin':
        'प्रहार लक्ष्याला {{balance.slowedDuration|s}} साठी {{balance.slowedSpeedMulti|pctLess}} मंदावतात.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} नुकसान, पण प्रत्येक गोळी ताप वाढवते.',
    'upgrade.treg':
        'ताप प्रति सेकंद {{balance.tregDecayBonus|degC}} वेगाने उतरतो.',
    'upgrade.mitochondrie':
        'विशेष हल्ल्याला {{balance.mitochondrieCostMulti|pctLess}} कमी ATP लागते.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} कमाल डॅश चार्ज.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} गोळ्यांचे मूळ नुकसान.',
  },
);
