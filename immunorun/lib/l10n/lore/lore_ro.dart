// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreRo = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonizare (IgG)',
    'upgrade.histamin': 'Histamină',
    'upgrade.pyrogen': 'Pirogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitocondrii',
    'upgrade.membrana': 'Fluiditatea membranei',
    'upgrade.cytotoxin': 'Granule citotoxice',
    'enemy.swarmer': 'Roi (coci)',
    'enemy.tank': 'Biofilm (grup de stafilococi)',
    'enemy.boss': 'Stafilococul auriu (boss)',
    'enemy.boss.phase2': 'Stafilococul auriu — faza a doua',
    'status.opsonized': 'Marcat (opsonizat)',
    'status.slowed': 'Încetinit',
    'damage.kinetic': 'Daune fizice',
    'damage.inflammatory': 'Daune inflamatorii',
    'mechanic.fever': 'Febră',
    'fever.normo': 'Temperatură normală',
    'fever.febrile': 'Febră ușoară',
    'fever.hyper': 'Febră mare',
    'fever.critical': 'Febră critică',
    'room.combat': 'Luptă',
    'room.elite': 'Elită',
    'room.treasure': 'Vindecare',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Celule de memorie',
    'meta.vaccination': 'Vaccinare',
    'ability.phagocytosis': 'Fagocitoză (atac de bază)',
    'ability.dash': 'Mișcare amiboidală (salt)',
    'ability.chargeDash': 'Pseudopode (salt încărcat)',
    'ability.oxidativeBurst': 'Explozie oxidativă (ROS)',
    'ability.lysozymeBurst': 'Salvă de lizozim',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Culori false (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Loviturile marchează ținta — primește {{balance.opsonizedDamageTakenMulti|pctDelta}} daune timp de {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Loviturile încetinesc ținta cu {{balance.slowedSpeedMulti|pctLess}} timp de {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} daune, dar fiecare foc crește febra.',
    'upgrade.treg':
        'Febra scade cu {{balance.tregDecayBonus|degC}}/s mai repede.',
    'upgrade.mitochondrie':
        'Atacul special costă cu {{balance.mitochondrieCostMulti|pctLess}} mai puțin ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} încărcare maximă de salt.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} daune de bază ale proiectilelor.',
  },
);
