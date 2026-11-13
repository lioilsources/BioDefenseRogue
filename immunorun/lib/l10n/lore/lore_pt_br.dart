// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable lorePtBr = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonização (IgG)',
    'upgrade.histamin': 'Histamina',
    'upgrade.pyrogen': 'Pirogênio (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitocôndrias',
    'upgrade.membrana': 'Fluidez da membrana',
    'upgrade.cytotoxin': 'Grânulos citotóxicos',
    'enemy.swarmer': 'Enxame (cocos)',
    'enemy.tank': 'Biofilme (aglomerado de estafilococos)',
    'enemy.boss': 'Estafilococo dourado (chefe)',
    'enemy.boss.phase2': 'Estafilococo dourado — segunda fase',
    'status.opsonized': 'Marcado (opsonizado)',
    'status.slowed': 'Lento',
    'damage.kinetic': 'Dano físico',
    'damage.inflammatory': 'Dano inflamatório',
    'mechanic.fever': 'Febre',
    'fever.normo': 'Temperatura normal',
    'fever.febrile': 'Febre leve',
    'fever.hyper': 'Febre alta',
    'fever.critical': 'Febre crítica',
    'room.combat': 'Combate',
    'room.elite': 'Elite',
    'room.treasure': 'Cura',
    'room.boss': 'Chefe',
    'meta.memoryCells': 'Células de memória',
    'meta.vaccination': 'Vacinação',
    'ability.phagocytosis': 'Fagocitose (ataque básico)',
    'ability.dash': 'Movimento ameboide (investida)',
    'ability.chargeDash': 'Pseudópodes (investida carregada)',
    'ability.oxidativeBurst': 'Explosão oxidativa (ROS)',
    'ability.lysozymeBurst': 'Rajada de lisozima',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Cores falsas (MEV)',
  },
  inGame: {
    'upgrade.opsonin':
        'Os acertos marcam o alvo — ele sofre {{balance.opsonizedDamageTakenMulti|pctDelta}} de dano por {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Os acertos deixam o alvo {{balance.slowedSpeedMulti|pctLess}} mais lento por {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} de dano, mas cada tiro aumenta a febre.',
    'upgrade.treg':
        'A febre cai {{balance.tregDecayBonus|degC}}/s mais rápido.',
    'upgrade.mitochondrie':
        'O ataque especial custa {{balance.mitochondrieCostMulti|pctLess}} menos ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} carga máxima de investida.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} de dano base dos projéteis.',
  },
);
