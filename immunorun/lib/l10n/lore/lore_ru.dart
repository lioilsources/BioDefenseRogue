// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreRu = LoreTable(
  names: {
    'upgrade.opsonin': 'Опсонизация (IgG)',
    'upgrade.histamin': 'Гистамин',
    'upgrade.pyrogen': 'Пироген (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Митохондрии',
    'upgrade.membrana': 'Текучесть мембраны',
    'upgrade.cytotoxin': 'Цитотоксические гранулы',
    'enemy.swarmer': 'Рой (кокки)',
    'enemy.tank': 'Биоплёнка (скопление стафилококков)',
    'enemy.boss': 'Золотистый стафилококк (босс)',
    'enemy.boss.phase2': 'Золотистый стафилококк — вторая фаза',
    'status.opsonized': 'Помечен (опсонизирован)',
    'status.slowed': 'Замедлен',
    'damage.kinetic': 'Физический урон',
    'damage.inflammatory': 'Воспалительный урон',
    'mechanic.fever': 'Лихорадка',
    'fever.normo': 'Нормальная температура',
    'fever.febrile': 'Лёгкая лихорадка',
    'fever.hyper': 'Высокая лихорадка',
    'fever.critical': 'Критическая лихорадка',
    'room.combat': 'Бой',
    'room.elite': 'Элита',
    'room.treasure': 'Лечение',
    'room.boss': 'Босс',
    'meta.memoryCells': 'Клетки памяти',
    'meta.vaccination': 'Вакцинация',
    'ability.phagocytosis': 'Фагоцитоз (базовая атака)',
    'ability.dash': 'Амебоидное движение (рывок)',
    'ability.chargeDash': 'Ложноножки (заряженный рывок)',
    'ability.oxidativeBurst': 'Окислительный взрыв (АФК)',
    'ability.lysozymeBurst': 'Залп лизоцима',
    'resource.atp': 'АТФ',
    'mechanic.microscope': 'Ложные цвета (СЭМ)',
  },
  inGame: {
    'upgrade.opsonin':
        'Попадания метят цель — она получает {{balance.opsonizedDamageTakenMulti|pctDelta}} урона в течение {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Попадания замедляют цель на {{balance.slowedSpeedMulti|pctLess}} на {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} урона, но каждый выстрел повышает температуру.',
    'upgrade.treg':
        'Температура падает на {{balance.tregDecayBonus|degC}}/с быстрее.',
    'upgrade.mitochondrie':
        'Спецатака стоит на {{balance.mitochondrieCostMulti|pctLess}} меньше АТФ.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} к максимуму зарядов рывка.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} к базовому урону снарядов.',
  },
);
