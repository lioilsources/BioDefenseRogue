// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreSk = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonizácia (IgG)',
    'upgrade.histamin': 'Histamín',
    'upgrade.pyrogen': 'Pyrogén (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitochondrie',
    'upgrade.membrana': 'Fluidita membrány',
    'upgrade.cytotoxin': 'Cytotoxické granuly',
    'enemy.swarmer': 'Roj (koky)',
    'enemy.tank': 'Biofilm (zhluk stafylokokov)',
    'enemy.boss': 'Zlatý stafylokok (boss)',
    'enemy.boss.phase2': 'Zlatý stafylokok — druhá fáza',
    'status.opsonized': 'Označený (opsonizovaný)',
    'status.slowed': 'Spomalený',
    'damage.kinetic': 'Fyzické poškodenie',
    'damage.inflammatory': 'Zápalové poškodenie',
    'mechanic.fever': 'Horúčka',
    'fever.normo': 'Normálna teplota',
    'fever.febrile': 'Mierna horúčka',
    'fever.hyper': 'Vysoká horúčka',
    'fever.critical': 'Kritická horúčka',
    'room.combat': 'Boj',
    'room.elite': 'Elite',
    'room.treasure': 'Liečenie',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Pamäťové bunky',
    'meta.vaccination': 'Vakcinácia',
    'ability.phagocytosis': 'Fagocytóza (základný útok)',
    'ability.dash': 'Améboidný pohyb (dash)',
    'ability.chargeDash': 'Panôžky (nabitý dash)',
    'ability.oxidativeBurst': 'Oxidačné vzplanutie (ROS)',
    'ability.lysozymeBurst': 'Lyzozýmová salva',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Falošné farby (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Zásahy označujú cieľ — dostáva {{balance.opsonizedDamageTakenMulti|pctDelta}} poškodenia počas {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Zásahy spomaľujú cieľ o {{balance.slowedSpeedMulti|pctLess}} na {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} poškodenia, ale každý výstrel zvyšuje horúčku.',
    'upgrade.treg':
        'Horúčka klesá o {{balance.tregDecayBonus|degC}}/s rýchlejšie.',
    'upgrade.mitochondrie':
        'Špeciálny útok stojí o {{balance.mitochondrieCostMulti|pctLess}} menej ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maximálny náboj dashu.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} základného poškodenia projektilov.',
  },
);
