// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable lorePl = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonizacja (IgG)',
    'upgrade.histamin': 'Histamina',
    'upgrade.pyrogen': 'Pirogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitochondria',
    'upgrade.membrana': 'Płynność błony',
    'upgrade.cytotoxin': 'Ziarnistości cytotoksyczne',
    'enemy.swarmer': 'Rój (ziarniaki)',
    'enemy.tank': 'Biofilm (skupisko gronkowców)',
    'enemy.boss': 'Gronkowiec złocisty (boss)',
    'enemy.boss.phase2': 'Gronkowiec złocisty — druga faza',
    'status.opsonized': 'Oznaczony (opsonizowany)',
    'status.slowed': 'Spowolniony',
    'damage.kinetic': 'Obrażenia fizyczne',
    'damage.inflammatory': 'Obrażenia zapalne',
    'mechanic.fever': 'Gorączka',
    'fever.normo': 'Normalna temperatura',
    'fever.febrile': 'Lekka gorączka',
    'fever.hyper': 'Wysoka gorączka',
    'fever.critical': 'Krytyczna gorączka',
    'room.combat': 'Walka',
    'room.elite': 'Elita',
    'room.treasure': 'Leczenie',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Komórki pamięci',
    'meta.vaccination': 'Szczepienie',
    'ability.phagocytosis': 'Fagocytoza (atak podstawowy)',
    'ability.dash': 'Ruch pełzakowaty (zryw)',
    'ability.chargeDash': 'Nibynóżki (naładowany zryw)',
    'ability.oxidativeBurst': 'Wybuch tlenowy (ROS)',
    'ability.lysozymeBurst': 'Salwa lizozymu',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Fałszywe kolory (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Trafienia oznaczają cel — otrzymuje {{balance.opsonizedDamageTakenMulti|pctDelta}} obrażeń przez {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Trafienia spowalniają cel o {{balance.slowedSpeedMulti|pctLess}} na {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} obrażeń, ale każdy strzał podnosi gorączkę.',
    'upgrade.treg':
        'Gorączka spada o {{balance.tregDecayBonus|degC}}/s szybciej.',
    'upgrade.mitochondrie':
        'Atak specjalny kosztuje o {{balance.mitochondrieCostMulti|pctLess}} mniej ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maksymalny ładunek zrywu.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} podstawowych obrażeń pocisków.',
  },
);
