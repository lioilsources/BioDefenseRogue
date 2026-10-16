// Čistý Dart — bez Flame importů.
// Definice in-run upgradů (receptory / cytokiny). Magnitudy v balance.dart,
// texty v lore.dart.

import 'lore.dart';
import 'lore_text.dart';

enum UpgradeId {
  opsonin,
  histamin,
  pyrogen,
  treg,
  mitochondrie,
  membrana,
  cytotoxin,
}

class UpgradeDef {
  const UpgradeDef({required this.id});

  final UpgradeId id;

  // Název a popis karty čte z registru pojmů (lore.dart) — jediný zdroj textu.
  String get nameCz => lore.byRef(id).nameCz;
  String get descCz => lore.byRef(id).inGameText;
}

final List<UpgradeDef> allUpgrades = [
  for (final id in UpgradeId.values) UpgradeDef(id: id),
];
