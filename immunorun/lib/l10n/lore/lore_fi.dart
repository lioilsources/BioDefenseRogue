// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreFi = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonisaatio (IgG)',
    'upgrade.histamin': 'Histamiini',
    'upgrade.pyrogen': 'Pyrogeeni (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitokondriot',
    'upgrade.membrana': 'Kalvon juoksevuus',
    'upgrade.cytotoxin': 'Sytotoksiset jyväset',
    'enemy.swarmer': 'Parvi (kokit)',
    'enemy.tank': 'Biofilmi (stafylokokkirypäs)',
    'enemy.boss': 'Kultainen stafylokokki (pomo)',
    'enemy.boss.phase2': 'Kultainen stafylokokki — toinen vaihe',
    'status.opsonized': 'Merkitty (opsonoitu)',
    'status.slowed': 'Hidastettu',
    'damage.kinetic': 'Fyysinen vahinko',
    'damage.inflammatory': 'Tulehdusvahinko',
    'mechanic.fever': 'Kuume',
    'fever.normo': 'Normaali lämpö',
    'fever.febrile': 'Lievä kuume',
    'fever.hyper': 'Korkea kuume',
    'fever.critical': 'Kriittinen kuume',
    'room.combat': 'Taistelu',
    'room.elite': 'Eliitti',
    'room.treasure': 'Parannus',
    'room.boss': 'Pomo',
    'meta.memoryCells': 'Muistisolut',
    'meta.vaccination': 'Rokotus',
    'ability.phagocytosis': 'Fagosytoosi (perushyökkäys)',
    'ability.dash': 'Ameboidiliike (syöksy)',
    'ability.chargeDash': 'Valejalat (ladattu syöksy)',
    'ability.oxidativeBurst': 'Oksidatiivinen purkaus (ROS)',
    'ability.lysozymeBurst': 'Lysotsyymisarja',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Väärät värit (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Osumat merkitsevät kohteen — se ottaa {{balance.opsonizedDamageTakenMulti|pctDelta}} vahinkoa {{balance.opsonizedDuration|s}} ajan.',
    'upgrade.histamin':
        'Osumat hidastavat kohdetta {{balance.slowedSpeedMulti|pctLess}} {{balance.slowedDuration|s}} ajaksi.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} vahinkoa, mutta jokainen laukaus nostaa kuumetta.',
    'upgrade.treg':
        'Kuume laskee {{balance.tregDecayBonus|degC}}/s nopeammin.',
    'upgrade.mitochondrie':
        'Erikoishyökkäys maksaa {{balance.mitochondrieCostMulti|pctLess}} vähemmän ATP:tä.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} syöksylataus maksimiin.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} ammusten perusvahinkoa.',
  },
);
