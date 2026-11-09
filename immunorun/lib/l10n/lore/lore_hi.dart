// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreHi = LoreTable(
  names: {
    'upgrade.opsonin': 'ऑप्सोनाइज़ेशन (IgG)',
    'upgrade.histamin': 'हिस्टामिन',
    'upgrade.pyrogen': 'पाइरोजन (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'माइटोकॉन्ड्रिया',
    'upgrade.membrana': 'झिल्ली की तरलता',
    'upgrade.cytotoxin': 'साइटोटॉक्सिक कणिकाएँ',
    'enemy.swarmer': 'झुंड (कोकाई)',
    'enemy.tank': 'बायोफ़िल्म (स्टैफ़िलोकोकस का गुच्छा)',
    'enemy.boss': 'सुनहरा स्टैफ़िलोकोकस (बॉस)',
    'enemy.boss.phase2': 'सुनहरा स्टैफ़िलोकोकस — दूसरा चरण',
    'status.opsonized': 'चिह्नित (ऑप्सोनाइज़्ड)',
    'status.slowed': 'धीमा',
    'damage.kinetic': 'शारीरिक नुकसान',
    'damage.inflammatory': 'सूजन से नुकसान',
    'mechanic.fever': 'बुखार',
    'fever.normo': 'सामान्य तापमान',
    'fever.febrile': 'हल्का बुखार',
    'fever.hyper': 'तेज़ बुखार',
    'fever.critical': 'गंभीर बुखार',
    'room.combat': 'लड़ाई',
    'room.elite': 'एलीट',
    'room.treasure': 'उपचार',
    'room.boss': 'बॉस',
    'meta.memoryCells': 'स्मृति कोशिकाएँ',
    'meta.vaccination': 'टीकाकरण',
    'ability.phagocytosis': 'फ़ैगोसाइटोसिस (मूल हमला)',
    'ability.dash': 'अमीबीय गति (डैश)',
    'ability.chargeDash': 'कूटपाद (चार्ज डैश)',
    'ability.oxidativeBurst': 'ऑक्सीडेटिव विस्फोट (ROS)',
    'ability.lysozymeBurst': 'लाइसोज़ाइम बौछार',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'नकली रंग (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'वार लक्ष्य को चिह्नित करते हैं — वह {{balance.opsonizedDuration|s}} तक {{balance.opsonizedDamageTakenMulti|pctDelta}} नुकसान लेता है।',
    'upgrade.histamin':
        'वार लक्ष्य को {{balance.slowedDuration|s}} के लिए {{balance.slowedSpeedMulti|pctLess}} धीमा करते हैं।',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} नुकसान, लेकिन हर गोली बुखार बढ़ाती है।',
    'upgrade.treg':
        'बुखार {{balance.tregDecayBonus|degC}}/s तेज़ी से उतरता है।',
    'upgrade.mitochondrie':
        'विशेष हमले में {{balance.mitochondrieCostMulti|pctLess}} कम ATP लगता है।',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} अधिकतम डैश चार्ज।',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} गोलियों का मूल नुकसान।',
  },
);
