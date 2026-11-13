// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable lorePa = LoreTable(
  names: {
    'upgrade.opsonin': 'ਓਪਸੋਨਾਈਜ਼ੇਸ਼ਨ (IgG)',
    'upgrade.histamin': 'ਹਿਸਟਾਮੀਨ',
    'upgrade.pyrogen': 'ਪਾਇਰੋਜਨ (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'ਮਾਈਟੋਕਾਂਡਰੀਆ',
    'upgrade.membrana': 'ਝਿੱਲੀ ਦੀ ਤਰਲਤਾ',
    'upgrade.cytotoxin': 'ਸਾਈਟੋਟੌਕਸਿਕ ਦਾਣੇ',
    'enemy.swarmer': 'ਝੁੰਡ (ਕੋਕਾਈ)',
    'enemy.tank': 'ਬਾਇਓਫ਼ਿਲਮ (ਸਟੈਫ਼ੀਲੋਕੋਕਸ ਦਾ ਗੁੱਛਾ)',
    'enemy.boss': 'ਸੁਨਹਿਰੀ ਸਟੈਫ਼ੀਲੋਕੋਕਸ (ਬੌਸ)',
    'enemy.boss.phase2': 'ਸੁਨਹਿਰੀ ਸਟੈਫ਼ੀਲੋਕੋਕਸ — ਦੂਜਾ ਪੜਾਅ',
    'status.opsonized': 'ਨਿਸ਼ਾਨਬੱਧ (ਓਪਸੋਨਾਈਜ਼ਡ)',
    'status.slowed': 'ਹੌਲਾ',
    'damage.kinetic': 'ਸਰੀਰਕ ਨੁਕਸਾਨ',
    'damage.inflammatory': 'ਸੋਜ ਵਾਲਾ ਨੁਕਸਾਨ',
    'mechanic.fever': 'ਬੁਖ਼ਾਰ',
    'fever.normo': 'ਆਮ ਤਾਪਮਾਨ',
    'fever.febrile': 'ਹਲਕਾ ਬੁਖ਼ਾਰ',
    'fever.hyper': 'ਤੇਜ਼ ਬੁਖ਼ਾਰ',
    'fever.critical': 'ਗੰਭੀਰ ਬੁਖ਼ਾਰ',
    'room.combat': 'ਲੜਾਈ',
    'room.elite': 'ਐਲੀਟ',
    'room.treasure': 'ਇਲਾਜ',
    'room.boss': 'ਬੌਸ',
    'meta.memoryCells': 'ਯਾਦ ਸੈੱਲ',
    'meta.vaccination': 'ਟੀਕਾਕਰਨ',
    'ability.phagocytosis': 'ਫੈਗੋਸਾਈਟੋਸਿਸ (ਮੁੱਢਲਾ ਹਮਲਾ)',
    'ability.dash': 'ਅਮੀਬਾ ਵਰਗੀ ਗਤੀ (ਡੈਸ਼)',
    'ability.chargeDash': 'ਨਕਲੀ ਪੈਰ (ਚਾਰਜ ਡੈਸ਼)',
    'ability.oxidativeBurst': 'ਆਕਸੀਡੇਟਿਵ ਧਮਾਕਾ (ROS)',
    'ability.lysozymeBurst': 'ਲਾਇਸੋਜ਼ਾਈਮ ਬੁਛਾੜ',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'ਨਕਲੀ ਰੰਗ (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'ਵਾਰ ਨਿਸ਼ਾਨੇ \'ਤੇ ਨਿਸ਼ਾਨ ਲਾਉਂਦੇ ਹਨ — ਉਹ {{balance.opsonizedDuration|s}} ਤੱਕ {{balance.opsonizedDamageTakenMulti|pctDelta}} ਨੁਕਸਾਨ ਸਹਿੰਦਾ ਹੈ।',
    'upgrade.histamin':
        'ਵਾਰ ਨਿਸ਼ਾਨੇ ਨੂੰ {{balance.slowedDuration|s}} ਲਈ {{balance.slowedSpeedMulti|pctLess}} ਹੌਲਾ ਕਰਦੇ ਹਨ।',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} ਨੁਕਸਾਨ, ਪਰ ਹਰ ਗੋਲੀ ਬੁਖ਼ਾਰ ਵਧਾਉਂਦੀ ਹੈ।',
    'upgrade.treg':
        'ਬੁਖ਼ਾਰ {{balance.tregDecayBonus|degC}} ਪ੍ਰਤੀ ਸਕਿੰਟ ਤੇਜ਼ੀ ਨਾਲ ਉਤਰਦਾ ਹੈ।',
    'upgrade.mitochondrie':
        'ਖ਼ਾਸ ਹਮਲੇ \'ਤੇ {{balance.mitochondrieCostMulti|pctLess}} ਘੱਟ ATP ਲੱਗਦਾ ਹੈ।',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} ਵੱਧ ਤੋਂ ਵੱਧ ਡੈਸ਼ ਚਾਰਜ।',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} ਗੋਲੀਆਂ ਦਾ ਮੁੱਢਲਾ ਨੁਕਸਾਨ।',
  },
);
