// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreEs = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonización (IgG)',
    'upgrade.histamin': 'Histamina',
    'upgrade.pyrogen': 'Pirógeno (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitocondrias',
    'upgrade.membrana': 'Fluidez de membrana',
    'upgrade.cytotoxin': 'Gránulos citotóxicos',
    'enemy.swarmer': 'Enjambre (cocos)',
    'enemy.tank': 'Biopelícula (racimo de estafilococos)',
    'enemy.boss': 'Estafilococo dorado (jefe)',
    'enemy.boss.phase2': 'Estafilococo dorado — segunda fase',
    'status.opsonized': 'Marcado (opsonizado)',
    'status.slowed': 'Ralentizado',
    'damage.kinetic': 'Daño físico',
    'damage.inflammatory': 'Daño inflamatorio',
    'mechanic.fever': 'Fiebre',
    'fever.normo': 'Temperatura normal',
    'fever.febrile': 'Fiebre leve',
    'fever.hyper': 'Fiebre alta',
    'fever.critical': 'Fiebre crítica',
    'room.combat': 'Combate',
    'room.elite': 'Élite',
    'room.treasure': 'Curación',
    'room.boss': 'Jefe',
    'meta.memoryCells': 'Células de memoria',
    'meta.vaccination': 'Vacunación',
    'ability.phagocytosis': 'Fagocitosis (ataque básico)',
    'ability.dash': 'Movimiento ameboide (embestida)',
    'ability.chargeDash': 'Pseudópodos (embestida cargada)',
    'ability.oxidativeBurst': 'Estallido oxidativo (ROS)',
    'ability.lysozymeBurst': 'Salva de lisozima',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Colores falsos (MEB)',
  },
  inGame: {
    'upgrade.opsonin':
        'Los impactos marcan al objetivo — recibe {{balance.opsonizedDamageTakenMulti|pctDelta}} de daño durante {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Los impactos ralentizan al objetivo un {{balance.slowedSpeedMulti|pctLess}} durante {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} de daño, pero cada disparo sube la fiebre.',
    'upgrade.treg':
        'La fiebre baja {{balance.tregDecayBonus|degC}}/s más rápido.',
    'upgrade.mitochondrie':
        'El ataque especial cuesta un {{balance.mitochondrieCostMulti|pctLess}} menos de ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} carga máxima de embestida.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} de daño base de los proyectiles.',
  },
);
