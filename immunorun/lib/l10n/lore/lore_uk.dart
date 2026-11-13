// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreUk = LoreTable(
  names: {
    'upgrade.opsonin': 'Опсонізація (IgG)',
    'upgrade.histamin': 'Гістамін',
    'upgrade.pyrogen': 'Піроген (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Мітохондрії',
    'upgrade.membrana': 'Плинність мембрани',
    'upgrade.cytotoxin': 'Цитотоксичні гранули',
    'enemy.swarmer': 'Рій (коки)',
    'enemy.tank': 'Біоплівка (скупчення стафілококів)',
    'enemy.boss': 'Золотистий стафілокок (бос)',
    'enemy.boss.phase2': 'Золотистий стафілокок — друга фаза',
    'status.opsonized': 'Позначений (опсонізований)',
    'status.slowed': 'Сповільнений',
    'damage.kinetic': 'Фізична шкода',
    'damage.inflammatory': 'Запальна шкода',
    'mechanic.fever': 'Гарячка',
    'fever.normo': 'Нормальна температура',
    'fever.febrile': 'Легка гарячка',
    'fever.hyper': 'Висока гарячка',
    'fever.critical': 'Критична гарячка',
    'room.combat': 'Бій',
    'room.elite': 'Еліта',
    'room.treasure': 'Лікування',
    'room.boss': 'Бос',
    'meta.memoryCells': 'Клітини памʼяті',
    'meta.vaccination': 'Вакцинація',
    'ability.phagocytosis': 'Фагоцитоз (базова атака)',
    'ability.dash': 'Амебоїдний рух (ривок)',
    'ability.chargeDash': 'Псевдоподії (заряджений ривок)',
    'ability.oxidativeBurst': 'Оксидативний вибух (АФК)',
    'ability.lysozymeBurst': 'Залп лізоциму',
    'resource.atp': 'АТФ',
    'mechanic.microscope': 'Хибні кольори (СЕМ)',
  },
  inGame: {
    'upgrade.opsonin':
        'Влучання позначають ціль — вона отримує {{balance.opsonizedDamageTakenMulti|pctDelta}} шкоди протягом {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Влучання сповільнюють ціль на {{balance.slowedSpeedMulti|pctLess}} на {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} шкоди, але кожен постріл підвищує температуру.',
    'upgrade.treg':
        'Температура падає на {{balance.tregDecayBonus|degC}}/с швидше.',
    'upgrade.mitochondrie':
        'Спецатака коштує на {{balance.mitochondrieCostMulti|pctLess}} менше АТФ.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} до максимуму зарядів ривка.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} до базової шкоди снарядів.',
  },
);
