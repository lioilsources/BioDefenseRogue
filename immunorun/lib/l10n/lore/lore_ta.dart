// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreTa = LoreTable(
  names: {
    'upgrade.opsonin': 'ஆப்சோனைசேஷன் (IgG)',
    'upgrade.histamin': 'ஹிஸ்டமின்',
    'upgrade.pyrogen': 'பைரோஜன் (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'மைட்டோகாண்ட்ரியா',
    'upgrade.membrana': 'சவ்வு நீர்மை',
    'upgrade.cytotoxin': 'செல் நச்சுத் துகள்கள்',
    'enemy.swarmer': 'கூட்டம் (கோக்கை)',
    'enemy.tank': 'உயிர்ப்படலம் (ஸ்டாஃபிலோகாக்கஸ் கொத்து)',
    'enemy.boss': 'தங்க ஸ்டாஃபிலோகாக்கஸ் (பாஸ்)',
    'enemy.boss.phase2': 'தங்க ஸ்டாஃபிலோகாக்கஸ் — இரண்டாம் கட்டம்',
    'status.opsonized': 'குறியிடப்பட்டது (ஆப்சோனைஸ்டு)',
    'status.slowed': 'மெதுவானது',
    'damage.kinetic': 'உடல் சேதம்',
    'damage.inflammatory': 'அழற்சி சேதம்',
    'mechanic.fever': 'காய்ச்சல்',
    'fever.normo': 'இயல்பு வெப்பநிலை',
    'fever.febrile': 'லேசான காய்ச்சல்',
    'fever.hyper': 'கடும் காய்ச்சல்',
    'fever.critical': 'ஆபத்தான காய்ச்சல்',
    'room.combat': 'சண்டை',
    'room.elite': 'எலைட்',
    'room.treasure': 'குணமாக்கல்',
    'room.boss': 'பாஸ்',
    'meta.memoryCells': 'நினைவு செல்கள்',
    'meta.vaccination': 'தடுப்பூசி',
    'ability.phagocytosis': 'ஃபேகோசைட்டோசிஸ் (அடிப்படைத் தாக்குதல்)',
    'ability.dash': 'அமீபா இயக்கம் (டாஷ்)',
    'ability.chargeDash': 'போலிக்கால்கள் (சார்ஜ் டாஷ்)',
    'ability.oxidativeBurst': 'ஆக்ஸிஜனேற்ற வெடிப்பு (ROS)',
    'ability.lysozymeBurst': 'லைசோசைம் சரமாரி',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'போலி நிறங்கள் (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'தாக்குதல்கள் இலக்கைக் குறியிடுகின்றன — அது {{balance.opsonizedDuration|s}} வரை {{balance.opsonizedDamageTakenMulti|pctDelta}} சேதம் பெறும்.',
    'upgrade.histamin':
        'தாக்குதல்கள் இலக்கை {{balance.slowedDuration|s}} வரை {{balance.slowedSpeedMulti|pctLess}} மெதுவாக்கும்.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} சேதம், ஆனால் ஒவ்வொரு சுடுதலும் காய்ச்சலை உயர்த்தும்.',
    'upgrade.treg':
        'காய்ச்சல் வினாடிக்கு {{balance.tregDecayBonus|degC}} வேகமாகக் குறையும்.',
    'upgrade.mitochondrie':
        'சிறப்புத் தாக்குதலுக்கு {{balance.mitochondrieCostMulti|pctLess}} குறைவான ATP தேவை.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} அதிகபட்ச டாஷ் சார்ஜ்.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} எறிகணைகளின் அடிப்படைச் சேதம்.',
  },
);
