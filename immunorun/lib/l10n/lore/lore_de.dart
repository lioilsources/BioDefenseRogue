// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreDe = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonierung (IgG)',
    'upgrade.histamin': 'Histamin',
    'upgrade.pyrogen': 'Pyrogen (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitochondrien',
    'upgrade.membrana': 'Membranfluidität',
    'upgrade.cytotoxin': 'Zytotoxische Granula',
    'enemy.swarmer': 'Schwarm (Kokken)',
    'enemy.tank': 'Biofilm (Staphylokokken-Haufen)',
    'enemy.boss': 'Goldener Staphylokokkus (Boss)',
    'enemy.boss.phase2': 'Goldener Staphylokokkus — zweite Phase',
    'status.opsonized': 'Markiert (opsoniert)',
    'status.slowed': 'Verlangsamt',
    'damage.kinetic': 'Physischer Schaden',
    'damage.inflammatory': 'Entzündungsschaden',
    'mechanic.fever': 'Fieber',
    'fever.normo': 'Normale Temperatur',
    'fever.febrile': 'Leichtes Fieber',
    'fever.hyper': 'Hohes Fieber',
    'fever.critical': 'Kritisches Fieber',
    'room.combat': 'Kampf',
    'room.elite': 'Elite',
    'room.treasure': 'Heilung',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Gedächtniszellen',
    'meta.vaccination': 'Impfung',
    'ability.phagocytosis': 'Phagozytose (Grundangriff)',
    'ability.dash': 'Amöboide Bewegung (Dash)',
    'ability.chargeDash': 'Scheinfüßchen (geladener Dash)',
    'ability.oxidativeBurst': 'Oxidativer Burst (ROS)',
    'ability.lysozymeBurst': 'Lysozym-Salve',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Falschfarben (REM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Treffer markieren das Ziel — es erleidet {{balance.opsonizedDamageTakenMulti|pctDelta}} Schaden für {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Treffer verlangsamen das Ziel um {{balance.slowedSpeedMulti|pctLess}} für {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} Schaden, aber jeder Schuss erhöht das Fieber.',
    'upgrade.treg':
        'Das Fieber sinkt um {{balance.tregDecayBonus|degC}}/s schneller.',
    'upgrade.mitochondrie':
        'Der Spezialangriff kostet {{balance.mitochondrieCostMulti|pctLess}} weniger ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} maximale Dash-Ladung.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} Grundschaden der Projektile.',
  },
);
