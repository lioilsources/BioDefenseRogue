// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreOr = LoreTable(
  names: {
    'upgrade.opsonin': 'ଅପସୋନାଇଜେସନ୍ (IgG)',
    'upgrade.histamin': 'ହିଷ୍ଟାମିନ୍',
    'upgrade.pyrogen': 'ପାଇରୋଜେନ୍ (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'ମାଇଟୋକଣ୍ଡ୍ରିଆ',
    'upgrade.membrana': 'ଝିଲ୍ଲୀର ତରଳତା',
    'upgrade.cytotoxin': 'ସାଇଟୋଟକ୍ସିକ୍ ଦାନା',
    'enemy.swarmer': 'ଝାଙ୍କ (କକାଇ)',
    'enemy.tank': 'ବାୟୋଫିଲ୍ମ (ଷ୍ଟାଫିଲୋକକସ୍ ଗୁଚ୍ଛ)',
    'enemy.boss': 'ସୁନେଲି ଷ୍ଟାଫିଲୋକକସ୍ (ବସ୍)',
    'enemy.boss.phase2': 'ସୁନେଲି ଷ୍ଟାଫିଲୋକକସ୍ — ଦ୍ୱିତୀୟ ପର୍ଯ୍ୟାୟ',
    'status.opsonized': 'ଚିହ୍ନିତ (ଅପସୋନାଇଜଡ୍)',
    'status.slowed': 'ମନ୍ଥର',
    'damage.kinetic': 'ଶାରୀରିକ କ୍ଷତି',
    'damage.inflammatory': 'ପ୍ରଦାହ କ୍ଷତି',
    'mechanic.fever': 'ଜ୍ୱର',
    'fever.normo': 'ସାଧାରଣ ତାପମାତ୍ରା',
    'fever.febrile': 'ସାମାନ୍ୟ ଜ୍ୱର',
    'fever.hyper': 'ଅଧିକ ଜ୍ୱର',
    'fever.critical': 'ସଙ୍କଟଜନକ ଜ୍ୱର',
    'room.combat': 'ଯୁଦ୍ଧ',
    'room.elite': 'ଏଲିଟ୍',
    'room.treasure': 'ଚିକିତ୍ସା',
    'room.boss': 'ବସ୍',
    'meta.memoryCells': 'ସ୍ମୃତି କୋଷ',
    'meta.vaccination': 'ଟୀକାକରଣ',
    'ability.phagocytosis': 'ଫାଗୋସାଇଟୋସିସ୍ (ମୌଳିକ ଆକ୍ରମଣ)',
    'ability.dash': 'ଆମିବା ଭଳି ଗତି (ଡ୍ୟାସ୍)',
    'ability.chargeDash': 'ଛଦ୍ମପାଦ (ଚାର୍ଜ ଡ୍ୟାସ୍)',
    'ability.oxidativeBurst': 'ଅକ୍ସିଡେଟିଭ୍ ବିସ୍ଫୋରଣ (ROS)',
    'ability.lysozymeBurst': 'ଲାଇସୋଜାଇମ୍ ବର୍ଷା',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'କୃତ୍ରିମ ରଙ୍ଗ (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'ଆଘାତ ଲକ୍ଷ୍ୟକୁ ଚିହ୍ନିତ କରେ — ଏହା {{balance.opsonizedDuration|s}} ପର୍ଯ୍ୟନ୍ତ {{balance.opsonizedDamageTakenMulti|pctDelta}} କ୍ଷତି ପାଏ।',
    'upgrade.histamin':
        'ଆଘାତ ଲକ୍ଷ୍ୟକୁ {{balance.slowedDuration|s}} ପାଇଁ {{balance.slowedSpeedMulti|pctLess}} ମନ୍ଥର କରେ।',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} କ୍ଷତି, କିନ୍ତୁ ପ୍ରତ୍ୟେକ ଗୁଳି ଜ୍ୱର ବଢ଼ାଏ।',
    'upgrade.treg':
        'ଜ୍ୱର ପ୍ରତି ସେକେଣ୍ଡରେ {{balance.tregDecayBonus|degC}} ଶୀଘ୍ର କମେ।',
    'upgrade.mitochondrie':
        'ବିଶେଷ ଆକ୍ରମଣରେ {{balance.mitochondrieCostMulti|pctLess}} କମ୍ ATP ଲାଗେ।',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} ସର୍ବାଧିକ ଡ୍ୟାସ୍ ଚାର୍ଜ।',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} ଗୁଳିର ମୌଳିକ କ୍ଷତି।',
  },
);
