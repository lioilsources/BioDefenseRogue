// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreNl = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonisatie (IgG)',
    'upgrade.histamin': 'Histamine',
    'upgrade.pyrogen': 'Pyrogeen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitochondriën',
    'upgrade.membrana': 'Membraanvloeibaarheid',
    'upgrade.cytotoxin': 'Cytotoxische korrels',
    'enemy.swarmer': 'Zwerm (kokken)',
    'enemy.tank': 'Biofilm (stafylokokkenkluit)',
    'enemy.boss': 'Gouden stafylokok (baas)',
    'enemy.boss.phase2': 'Gouden stafylokok — tweede fase',
    'status.opsonized': 'Gemarkeerd (geopsoniseerd)',
    'status.slowed': 'Vertraagd',
    'damage.kinetic': 'Fysieke schade',
    'damage.inflammatory': 'Ontstekingsschade',
    'mechanic.fever': 'Koorts',
    'fever.normo': 'Normale temperatuur',
    'fever.febrile': 'Lichte koorts',
    'fever.hyper': 'Hoge koorts',
    'fever.critical': 'Kritieke koorts',
    'room.combat': 'Gevecht',
    'room.elite': 'Elite',
    'room.treasure': 'Genezing',
    'room.boss': 'Baas',
    'meta.memoryCells': 'Geheugencellen',
    'meta.vaccination': 'Vaccinatie',
    'ability.phagocytosis': 'Fagocytose (basisaanval)',
    'ability.dash': 'Amoeboïde beweging (dash)',
    'ability.chargeDash': 'Schijnvoetjes (geladen dash)',
    'ability.oxidativeBurst': 'Oxidatieve uitbarsting (ROS)',
    'ability.lysozymeBurst': 'Lysozymsalvo',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Valse kleuren (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Treffers markeren het doelwit — het krijgt {{balance.opsonizedDamageTakenMulti|pctDelta}} schade gedurende {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Treffers vertragen het doelwit met {{balance.slowedSpeedMulti|pctLess}} gedurende {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} schade, maar elk schot verhoogt de koorts.',
    'upgrade.treg':
        'De koorts daalt {{balance.tregDecayBonus|degC}}/s sneller.',
    'upgrade.mitochondrie':
        'De speciale aanval kost {{balance.mitochondrieCostMulti|pctLess}} minder ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maximale dashlading.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} basisschade van projectielen.',
  },
);
