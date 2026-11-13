import 'package:flutter/material.dart';

import '../../config/balance.dart';
import '../../domain/lore.dart';
import '../../domain/room_type.dart';
import '../../game/immuno_game.dart';

class RoomChoiceOverlay extends StatelessWidget {
  const RoomChoiceOverlay({super.key, required this.game});

  final ImmunoGame game;

  @override
  Widget build(BuildContext context) {
    final choices = game.pendingChoices;
    return Center(
      child: Container(
        padding:    const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        decoration: BoxDecoration(
          color:        Colors.black87,
          borderRadius: BorderRadius.circular(16),
          border:       Border.all(color: Colors.green.shade700, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'VYBER CESTU',
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
                  .map((node) => _DoorButton(node: node, game: game))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ilustrace karty dveří: ikona toho, co v místnosti čeká (`assets/images/icons/`).
/// Boj = roj koků, elite = biofilm (tank), léčení = červená krvinka, boss = stafylokok.
String roomIconAsset(RoomType t) => 'assets/images/icons/${switch (t) {
      RoomType.combat   => 'kok',
      RoomType.elite    => 'biofilm',
      RoomType.treasure => 'cervena-krvinka',
      RoomType.boss     => 'stafylokok',
    }}.webp';

class _DoorButton extends StatelessWidget {
  const _DoorButton({required this.node, required this.game});

  final RoomNode   node;
  final ImmunoGame game;

  static String _label(RoomType t) => lore.byRef(t).nameCz.toUpperCase();

  static Color _color(RoomType t) => switch (t) {
        RoomType.combat   => Colors.red,
        RoomType.elite    => Colors.orange,
        RoomType.treasure => Colors.green,
        RoomType.boss     => Colors.deepPurple,
      };

  @override
  Widget build(BuildContext context) {
    final c = _color(node.type);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: () => game.chooseDoor(node),
        child: Container(
          width:   130,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color:        c.withValues(alpha: 0.15),
            border:       Border.all(color: c, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                roomIconAsset(node.type),
                width:  Balance.roomCardIconSize,
                height: Balance.roomCardIconSize,
                cacheWidth: (Balance.roomCardIconSize *
                        MediaQuery.devicePixelRatioOf(context))
                    .round(),
                excludeFromSemantics: true, // název místnosti je hned pod ní
                errorBuilder: (context, _, _) => const SizedBox.square(
                    dimension: Balance.roomCardIconSize),
              ),
              const SizedBox(height: 10),
              Text(
                _label(node.type),
                style: TextStyle(
                  color:      c,
                  fontWeight: FontWeight.bold,
                  fontSize:   16,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
