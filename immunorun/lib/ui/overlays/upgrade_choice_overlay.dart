import 'package:flutter/material.dart';

import '../../domain/lore.dart';
import '../../domain/upgrade.dart';
import '../../game/immuno_game.dart';

/// Výběr upgradu po vyčištění místnosti — 1 z N karet.
class UpgradeChoiceOverlay extends StatelessWidget {
  const UpgradeChoiceOverlay({super.key, required this.game});

  final ImmunoGame game;

  @override
  Widget build(BuildContext context) {
    final choices = game.pendingUpgrades;
    return Center(
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

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({required this.def, required this.game});

  final UpgradeDef def;
  final ImmunoGame game;

  static IconData _icon(UpgradeId id) => switch (id) {
        UpgradeId.opsonin      => Icons.gps_fixed,
        UpgradeId.histamin     => Icons.slow_motion_video,
        UpgradeId.pyrogen      => Icons.local_fire_department,
        UpgradeId.treg         => Icons.ac_unit,
        UpgradeId.mitochondrie => Icons.battery_charging_full,
        UpgradeId.membrana     => Icons.double_arrow,
        UpgradeId.cytotoxin    => Icons.bolt,
      };

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
              Icon(_icon(def.id), color: c, size: 38),
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
