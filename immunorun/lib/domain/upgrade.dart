// Čistý Dart — bez Flame importů.
// Definice in-run upgradů (receptory / cytokiny). Magnitudy v balance.dart.

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
  const UpgradeDef({
    required this.id,
    required this.nameCz,
    required this.descCz,
  });

  final UpgradeId id;
  final String    nameCz;
  final String    descCz;
}

const List<UpgradeDef> allUpgrades = [
  UpgradeDef(
    id:     UpgradeId.opsonin,
    nameCz: 'Opsonizace (IgG)',
    descCz: 'Zásahy značkují cíl — bere +25 % poškození po 4 s.',
  ),
  UpgradeDef(
    id:     UpgradeId.histamin,
    nameCz: 'Histamin',
    descCz: 'Zásahy zpomalují cíl o 40 % na 2 s.',
  ),
  UpgradeDef(
    id:     UpgradeId.pyrogen,
    nameCz: 'Pyrogen (IL-6)',
    descCz: '+20 % poškození, ale každý výstřel zvyšuje horečku.',
  ),
  UpgradeDef(
    id:     UpgradeId.treg,
    nameCz: 'Treg (IL-10)',
    descCz: 'Horečka klesá o 0.15 °C/s rychleji.',
  ),
  UpgradeDef(
    id:     UpgradeId.mitochondrie,
    nameCz: 'Mitochondrie',
    descCz: 'Speciální útok stojí o 30 % méně ATP.',
  ),
  UpgradeDef(
    id:     UpgradeId.membrana,
    nameCz: 'Membránová fluidita',
    descCz: '+1 maximální dash náboj.',
  ),
  UpgradeDef(
    id:     UpgradeId.cytotoxin,
    nameCz: 'Cytotoxické granule',
    descCz: '+25 % základní poškození projektilů.',
  ),
];
