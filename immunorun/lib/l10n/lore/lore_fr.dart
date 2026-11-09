// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreFr = LoreTable(
  names: {
    'upgrade.opsonin': 'Opsonisation (IgG)',
    'upgrade.histamin': 'Histamine',
    'upgrade.pyrogen': 'Pyrogène (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Mitochondries',
    'upgrade.membrana': 'Fluidité membranaire',
    'upgrade.cytotoxin': 'Granules cytotoxiques',
    'enemy.swarmer': 'Essaim (coques)',
    'enemy.tank': 'Biofilm (amas de staphylocoques)',
    'enemy.boss': 'Staphylocoque doré (boss)',
    'enemy.boss.phase2': 'Staphylocoque doré — deuxième phase',
    'status.opsonized': 'Marqué (opsonisé)',
    'status.slowed': 'Ralenti',
    'damage.kinetic': 'Dégâts physiques',
    'damage.inflammatory': 'Dégâts inflammatoires',
    'mechanic.fever': 'Fièvre',
    'fever.normo': 'Température normale',
    'fever.febrile': 'Fièvre légère',
    'fever.hyper': 'Forte fièvre',
    'fever.critical': 'Fièvre critique',
    'room.combat': 'Combat',
    'room.elite': 'Élite',
    'room.treasure': 'Soin',
    'room.boss': 'Boss',
    'meta.memoryCells': 'Cellules mémoire',
    'meta.vaccination': 'Vaccination',
    'ability.phagocytosis': 'Phagocytose (attaque de base)',
    'ability.dash': 'Mouvement amiboïde (ruée)',
    'ability.chargeDash': 'Pseudopodes (ruée chargée)',
    'ability.oxidativeBurst': 'Explosion oxydative (ROS)',
    'ability.lysozymeBurst': 'Salve de lysozyme',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Fausses couleurs (MEB)',
  },
  inGame: {
    'upgrade.opsonin':
        'Tes tirs marquent la cible — elle subit {{balance.opsonizedDamageTakenMulti|pctDelta}} de dégâts pendant {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Tes tirs ralentissent la cible de {{balance.slowedSpeedMulti|pctLess}} pendant {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} de dégâts, mais chaque tir fait monter la fièvre.',
    'upgrade.treg':
        'La fièvre baisse de {{balance.tregDecayBonus|degC}}/s plus vite.',
    'upgrade.mitochondrie':
        'L\'attaque spéciale coûte {{balance.mitochondrieCostMulti|pctLess}} d\'ATP en moins.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} charge de ruée maximale.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} de dégâts de base des projectiles.',
  },
);
