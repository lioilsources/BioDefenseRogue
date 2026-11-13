import 'package:flutter/material.dart';

import '../../config/balance.dart';
import '../../domain/lore.dart';
import '../../domain/upgrade.dart';
import '../../game/immuno_game.dart';
import 'fit_to_screen.dart';

/// Výběr upgradu po vyčištění místnosti — 1 z N karet.
class UpgradeChoiceOverlay extends StatelessWidget {
  const UpgradeChoiceOverlay({super.key, required this.game});

  final ImmunoGame game;

  @override
  Widget build(BuildContext context) {
    final choices = game.pendingUpgrades;
    return FitToScreen(
      child: Container(
        padding:    const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        decoration: BoxDecoration(
          color:        Colors.black87,
          borderRadius: BorderRadius.circular(16),
          border:       Border.all(color: Colors.cyan.shade700, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'VYBER CYTOKIN / RECEPTOR',
              style: TextStyle(
                color:      Colors.white,
                fontSize:   22,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: choices
                  .map((def) => _UpgradeCard(def: def, game: game))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fotorealistická ikona karty (art/icons/manifest.json, `use: card:upgrade.*`).
String upgradeIconAsset(UpgradeId id) => 'assets/images/icons/${switch (id) {
      UpgradeId.opsonin      => 'opsonizace',
      UpgradeId.histamin     => 'zirna-bunka',
      UpgradeId.pyrogen      => 'pyrogen',
      UpgradeId.treg         => 'treg',
      UpgradeId.mitochondrie => 'mitochondrie',
      UpgradeId.membrana     => 'membrana',
      UpgradeId.cytotoxin    => 'cytotoxin',
    }}.webp';

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({required this.def, required this.game});

  final UpgradeDef def;
  final ImmunoGame game;


  @override
  Widget build(BuildContext context) {
    const c = Colors.cyanAccent;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () => game.chooseUpgrade(def),
        child: Container(
          width:   170,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:        c.withValues(alpha: 0.10),
            border:       Border.all(color: c, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  tooltip:   'Co to je? (Lexikon)',
                  icon:      const Icon(Icons.info_outline, color: c, size: 22),
                  onPressed: () => game.openBookAt(lore.byRef(def.id)),
                ),
              ),
              Image.asset(
                upgradeIconAsset(def.id),
                width:  Balance.upgradeCardIconSize,
                height: Balance.upgradeCardIconSize,
                // Zdroj má 512 px; dekóduje se jen tolik, kolik slot potřebuje.
                cacheWidth: (Balance.upgradeCardIconSize *
                        MediaQuery.devicePixelRatioOf(context))
                    .round(),
                excludeFromSemantics: true, // název karty je hned pod ní
                errorBuilder: (context, _, _) => const SizedBox.square(
                    dimension: Balance.upgradeCardIconSize),
              ),
              const SizedBox(height: 10),
              Text(
                def.nameCz,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color:      c,
                  fontWeight: FontWeight.bold,
                  fontSize:   15,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                def.descCz,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color:    Colors.white70,
                  fontSize: 12,
                  height:   1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
