// Čistý Dart — bez Flame importů. Vlastněné upgrady runu + odvozené modifikátory.

import 'dart:math';

import '../../config/balance.dart';
import '../../domain/status_effects.dart';
import '../../domain/upgrade.dart';

class UpgradeController {
  final Set<UpgradeId> _owned = {};

  Set<UpgradeId> get owned => Set.unmodifiable(_owned);
  bool has(UpgradeId id)   => _owned.contains(id);
  void acquire(UpgradeId id) => _owned.add(id);

  /// Multiplikátor base damage projektilů (pyrogen, cytotoxin).
  double get damageMulti =>
      (has(UpgradeId.pyrogen)   ? Balance.pyrogenDamageMulti   : 1.0) *
      (has(UpgradeId.cytotoxin) ? Balance.cytotoxinDamageMulti : 1.0);

  /// Bonus decay horečky za sekundu (treg).
  double get feverDecayBonus =>
      has(UpgradeId.treg) ? Balance.tregDecayBonus : 0.0;

  /// Multiplikátor ATP ceny specialu (mitochondrie).
  double get atpCostMulti =>
      has(UpgradeId.mitochondrie) ? Balance.mitochondrieCostMulti : 1.0;

  /// Extra max dash náboje (membrána).
  int get extraDashCharges =>
      has(UpgradeId.membrana) ? Balance.membranaExtraDashCharges : 0;

  /// Nárůst horečky za výstřel (pyrogen — risk/reward).
  double get feverPerShot =>
      has(UpgradeId.pyrogen) ? Balance.pyrogenFeverPerShot : 0.0;

  /// Statusy aplikované projektily při zásahu.
  List<StatusEffect> get onHitStatuses => [
        if (has(UpgradeId.opsonin))  StatusEffect.opsonized,
        if (has(UpgradeId.histamin)) StatusEffect.slowed,
      ];

  /// Náhodná nabídka [count] nevlastněných upgradů (může být kratší/prázdná).
  List<UpgradeDef> rollOffer(Random rng, int count) {
    final available = allUpgrades.where((u) => !has(u.id)).toList()
      ..shuffle(rng);
    return available.take(count).toList();
  }

  void reset() => _owned.clear();
}
