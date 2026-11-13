// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreMl = LoreTable(
  names: {
    'upgrade.opsonin': 'ഓപ്സണൈസേഷൻ (IgG)',
    'upgrade.histamin': 'ഹിസ്റ്റമിൻ',
    'upgrade.pyrogen': 'പൈറോജൻ (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'മൈറ്റോകോൺ‌ഡ്രിയ',
    'upgrade.membrana': 'സ്തരത്തിന്റെ ദ്രവത്വം',
    'upgrade.cytotoxin': 'കോശവിഷ തരികൾ',
    'enemy.swarmer': 'കൂട്ടം (കോക്കൈ)',
    'enemy.tank': 'ബയോഫിലിം (സ്റ്റഫൈലോകോക്കസ് കൂട്ടം)',
    'enemy.boss': 'സ്വർണ സ്റ്റഫൈലോകോക്കസ് (ബോസ്)',
    'enemy.boss.phase2': 'സ്വർണ സ്റ്റഫൈലോകോക്കസ് — രണ്ടാം ഘട്ടം',
    'status.opsonized': 'അടയാളപ്പെടുത്തിയത് (ഓപ്സണൈസ്ഡ്)',
    'status.slowed': 'മന്ദഗതിയിലായി',
    'damage.kinetic': 'ശാരീരിക കേട്',
    'damage.inflammatory': 'വീക്ക കേട്',
    'mechanic.fever': 'പനി',
    'fever.normo': 'സാധാരണ താപനില',
    'fever.febrile': 'നേരിയ പനി',
    'fever.hyper': 'കടുത്ത പനി',
    'fever.critical': 'ഗുരുതര പനി',
    'room.combat': 'പോരാട്ടം',
    'room.elite': 'എലൈറ്റ്',
    'room.treasure': 'ചികിത്സ',
    'room.boss': 'ബോസ്',
    'meta.memoryCells': 'ഓർമ്മ കോശങ്ങൾ',
    'meta.vaccination': 'വാക്സിനേഷൻ',
    'ability.phagocytosis': 'ഫാഗോസൈറ്റോസിസ് (അടിസ്ഥാന ആക്രമണം)',
    'ability.dash': 'അമീബ ചലനം (ഡാഷ്)',
    'ability.chargeDash': 'കപടപാദങ്ങൾ (ചാർജ് ഡാഷ്)',
    'ability.oxidativeBurst': 'ഓക്സിഡേറ്റീവ് സ്ഫോടനം (ROS)',
    'ability.lysozymeBurst': 'ലൈസോസൈം വർഷം',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'കൃത്രിമ നിറങ്ങൾ (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'അടികൾ ലക്ഷ്യത്തെ അടയാളപ്പെടുത്തുന്നു — അതിന് {{balance.opsonizedDuration|s}} നേരം {{balance.opsonizedDamageTakenMulti|pctDelta}} കേട് ഏൽക്കും.',
    'upgrade.histamin':
        'അടികൾ ലക്ഷ്യത്തെ {{balance.slowedDuration|s}} നേരം {{balance.slowedSpeedMulti|pctLess}} മന്ദഗതിയിലാക്കുന്നു.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} കേട്, പക്ഷേ ഓരോ വെടിയും പനി കൂട്ടുന്നു.',
    'upgrade.treg':
        'പനി സെക്കൻഡിൽ {{balance.tregDecayBonus|degC}} വേഗത്തിൽ കുറയുന്നു.',
    'upgrade.mitochondrie':
        'പ്രത്യേക ആക്രമണത്തിന് {{balance.mitochondrieCostMulti|pctLess}} കുറവ് ATP മതി.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} പരമാവധി ഡാഷ് ചാർജ്.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} പ്രൊജക്റ്റൈലുകളുടെ അടിസ്ഥാന കേട്.',
  },
);
