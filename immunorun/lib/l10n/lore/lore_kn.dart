// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreKn = LoreTable(
  names: {
    'upgrade.opsonin': 'ಆಪ್ಸೊನೈಸೇಶನ್ (IgG)',
    'upgrade.histamin': 'ಹಿಸ್ಟಮಿನ್',
    'upgrade.pyrogen': 'ಪೈರೋಜೆನ್ (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'ಮೈಟೊಕಾಂಡ್ರಿಯಾ',
    'upgrade.membrana': 'ಪೊರೆಯ ದ್ರವತ್ವ',
    'upgrade.cytotoxin': 'ಕೋಶವಿಷ ಕಣಗಳು',
    'enemy.swarmer': 'ಹಿಂಡು (ಕಾಕೈ)',
    'enemy.tank': 'ಬಯೋಫಿಲ್ಮ್ (ಸ್ಟ್ಯಾಫಿಲೋಕಾಕಸ್ ಗೊಂಚಲು)',
    'enemy.boss': 'ಚಿನ್ನದ ಸ್ಟ್ಯಾಫಿಲೋಕಾಕಸ್ (ಬಾಸ್)',
    'enemy.boss.phase2': 'ಚಿನ್ನದ ಸ್ಟ್ಯಾಫಿಲೋಕಾಕಸ್ — ಎರಡನೇ ಹಂತ',
    'status.opsonized': 'ಗುರುತಿಸಲಾಗಿದೆ (ಆಪ್ಸೊನೈಸ್ಡ್)',
    'status.slowed': 'ನಿಧಾನಗೊಂಡಿದೆ',
    'damage.kinetic': 'ದೈಹಿಕ ಹಾನಿ',
    'damage.inflammatory': 'ಉರಿಯೂತದ ಹಾನಿ',
    'mechanic.fever': 'ಜ್ವರ',
    'fever.normo': 'ಸಾಮಾನ್ಯ ತಾಪಮಾನ',
    'fever.febrile': 'ಸೌಮ್ಯ ಜ್ವರ',
    'fever.hyper': 'ತೀವ್ರ ಜ್ವರ',
    'fever.critical': 'ಅಪಾಯಕಾರಿ ಜ್ವರ',
    'room.combat': 'ಹೋರಾಟ',
    'room.elite': 'ಎಲೈಟ್',
    'room.treasure': 'ಚಿಕಿತ್ಸೆ',
    'room.boss': 'ಬಾಸ್',
    'meta.memoryCells': 'ಸ್ಮೃತಿ ಕೋಶಗಳು',
    'meta.vaccination': 'ಲಸಿಕೆ',
    'ability.phagocytosis': 'ಫ್ಯಾಗೊಸೈಟೋಸಿಸ್ (ಮೂಲ ದಾಳಿ)',
    'ability.dash': 'ಅಮೀಬಾ ಚಲನೆ (ಡ್ಯಾಶ್)',
    'ability.chargeDash': 'ಮಿಥ್ಯಾಪಾದಗಳು (ಚಾರ್ಜ್ ಡ್ಯಾಶ್)',
    'ability.oxidativeBurst': 'ಆಕ್ಸಿಡೇಟಿವ್ ಸ್ಫೋಟ (ROS)',
    'ability.lysozymeBurst': 'ಲೈಸೋಜೈಮ್ ಮಳೆ',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'ಕೃತಕ ಬಣ್ಣಗಳು (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'ಹೊಡೆತಗಳು ಗುರಿಯನ್ನು ಗುರುತಿಸುತ್ತವೆ — ಅದು {{balance.opsonizedDuration|s}} ಕಾಲ {{balance.opsonizedDamageTakenMulti|pctDelta}} ಹಾನಿ ಪಡೆಯುತ್ತದೆ.',
    'upgrade.histamin':
        'ಹೊಡೆತಗಳು ಗುರಿಯನ್ನು {{balance.slowedDuration|s}} ಕಾಲ {{balance.slowedSpeedMulti|pctLess}} ನಿಧಾನಗೊಳಿಸುತ್ತವೆ.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} ಹಾನಿ, ಆದರೆ ಪ್ರತಿ ಗುಂಡು ಜ್ವರ ಏರಿಸುತ್ತದೆ.',
    'upgrade.treg':
        'ಜ್ವರ ಪ್ರತಿ ಸೆಕೆಂಡಿಗೆ {{balance.tregDecayBonus|degC}} ವೇಗವಾಗಿ ಇಳಿಯುತ್ತದೆ.',
    'upgrade.mitochondrie':
        'ವಿಶೇಷ ದಾಳಿಗೆ {{balance.mitochondrieCostMulti|pctLess}} ಕಡಿಮೆ ATP ಬೇಕು.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} ಗರಿಷ್ಠ ಡ್ಯಾಶ್ ಚಾರ್ಜ್.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} ಉತ್ಕ್ಷೇಪಕಗಳ ಮೂಲ ಹಾನಿ.',
  },
);
