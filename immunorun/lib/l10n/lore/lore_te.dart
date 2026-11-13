// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreTe = LoreTable(
  names: {
    'upgrade.opsonin': 'ఆప్సొనైజేషన్ (IgG)',
    'upgrade.histamin': 'హిస్టమిన్',
    'upgrade.pyrogen': 'పైరోజెన్ (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'మైటోకాండ్రియా',
    'upgrade.membrana': 'పొర ద్రవత్వం',
    'upgrade.cytotoxin': 'కణ విష కణికలు',
    'enemy.swarmer': 'గుంపు (కోకై)',
    'enemy.tank': 'బయోఫిల్మ్ (స్టాఫిలోకాకస్ గుత్తి)',
    'enemy.boss': 'బంగారు స్టాఫిలోకాకస్ (బాస్)',
    'enemy.boss.phase2': 'బంగారు స్టాఫిలోకాకస్ — రెండో దశ',
    'status.opsonized': 'గుర్తించబడింది (ఆప్సొనైజ్డ్)',
    'status.slowed': 'నెమ్మదించింది',
    'damage.kinetic': 'భౌతిక నష్టం',
    'damage.inflammatory': 'వాపు నష్టం',
    'mechanic.fever': 'జ్వరం',
    'fever.normo': 'సాధారణ ఉష్ణోగ్రత',
    'fever.febrile': 'తేలికపాటి జ్వరం',
    'fever.hyper': 'తీవ్ర జ్వరం',
    'fever.critical': 'ప్రమాదకర జ్వరం',
    'room.combat': 'పోరాటం',
    'room.elite': 'ఎలైట్',
    'room.treasure': 'చికిత్స',
    'room.boss': 'బాస్',
    'meta.memoryCells': 'జ్ఞాపక కణాలు',
    'meta.vaccination': 'టీకా',
    'ability.phagocytosis': 'ఫాగోసైటోసిస్ (ప్రాథమిక దాడి)',
    'ability.dash': 'అమీబా కదలిక (డాష్)',
    'ability.chargeDash': 'మిథ్యాపాదాలు (ఛార్జ్ డాష్)',
    'ability.oxidativeBurst': 'ఆక్సీకరణ విస్ఫోటనం (ROS)',
    'ability.lysozymeBurst': 'లైసోజైమ్ వర్షం',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'కృత్రిమ రంగులు (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'దెబ్బలు లక్ష్యాన్ని గుర్తిస్తాయి — అది {{balance.opsonizedDuration|s}} పాటు {{balance.opsonizedDamageTakenMulti|pctDelta}} నష్టం పొందుతుంది.',
    'upgrade.histamin':
        'దెబ్బలు లక్ష్యాన్ని {{balance.slowedDuration|s}} పాటు {{balance.slowedSpeedMulti|pctLess}} నెమ్మదిస్తాయి.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} నష్టం, కానీ ప్రతి కాల్పు జ్వరాన్ని పెంచుతుంది.',
    'upgrade.treg':
        'జ్వరం సెకనుకు {{balance.tregDecayBonus|degC}} వేగంగా తగ్గుతుంది.',
    'upgrade.mitochondrie':
        'ప్రత్యేక దాడికి {{balance.mitochondrieCostMulti|pctLess}} తక్కువ ATP ఖర్చవుతుంది.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} గరిష్ఠ డాష్ ఛార్జ్.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} ప్రక్షేపకాల ప్రాథమిక నష్టం.',
  },
);
