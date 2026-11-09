// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreGu = LoreTable(
  names: {
    'upgrade.opsonin': 'ઓપ્સોનાઇઝેશન (IgG)',
    'upgrade.histamin': 'હિસ્ટામાઇન',
    'upgrade.pyrogen': 'પાયરોજન (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'માઇટોકોન્ડ્રિયા',
    'upgrade.membrana': 'પટલની પ્રવાહિતા',
    'upgrade.cytotoxin': 'સાયટોટોક્સિક દાણા',
    'enemy.swarmer': 'ટોળું (કોકાઈ)',
    'enemy.tank': 'બાયોફિલ્મ (સ્ટેફાયલોકોકસનો ઝૂમખો)',
    'enemy.boss': 'સોનેરી સ્ટેફાયલોકોકસ (બોસ)',
    'enemy.boss.phase2': 'સોનેરી સ્ટેફાયલોકોકસ — બીજો તબક્કો',
    'status.opsonized': 'ચિહ્નિત (ઓપ્સોનાઇઝ્ડ)',
    'status.slowed': 'ધીમું',
    'damage.kinetic': 'શારીરિક નુકસાન',
    'damage.inflammatory': 'સોજાનું નુકસાન',
    'mechanic.fever': 'તાવ',
    'fever.normo': 'સામાન્ય તાપમાન',
    'fever.febrile': 'હળવો તાવ',
    'fever.hyper': 'તીવ્ર તાવ',
    'fever.critical': 'ગંભીર તાવ',
    'room.combat': 'લડાઈ',
    'room.elite': 'એલીટ',
    'room.treasure': 'સારવાર',
    'room.boss': 'બોસ',
    'meta.memoryCells': 'સ્મૃતિ કોષો',
    'meta.vaccination': 'રસીકરણ',
    'ability.phagocytosis': 'ફેગોસાયટોસિસ (મૂળ હુમલો)',
    'ability.dash': 'અમીબા જેવી ગતિ (ડૅશ)',
    'ability.chargeDash': 'ખોટા પગ (ચાર્જ ડૅશ)',
    'ability.oxidativeBurst': 'ઑક્સિડેટિવ વિસ્ફોટ (ROS)',
    'ability.lysozymeBurst': 'લાયસોઝાઇમ બૌછાર',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'કૃત્રિમ રંગો (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'પ્રહાર લક્ષ્યને ચિહ્નિત કરે છે — તે {{balance.opsonizedDuration|s}} સુધી {{balance.opsonizedDamageTakenMulti|pctDelta}} નુકસાન ભોગવે છે.',
    'upgrade.histamin':
        'પ્રહાર લક્ષ્યને {{balance.slowedDuration|s}} માટે {{balance.slowedSpeedMulti|pctLess}} ધીમું કરે છે.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} નુકસાન, પણ દરેક ગોળી તાવ વધારે છે.',
    'upgrade.treg':
        'તાવ પ્રતિ સેકન્ડ {{balance.tregDecayBonus|degC}} ઝડપથી ઊતરે છે.',
    'upgrade.mitochondrie':
        'ખાસ હુમલામાં {{balance.mitochondrieCostMulti|pctLess}} ઓછું ATP લાગે છે.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} મહત્તમ ડૅશ ચાર્જ.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} ગોળીઓનું મૂળ નુકસાન.',
  },
);
