import 'package:flutter/material.dart';

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

class _DoorButton extends StatelessWidget {
  const _DoorButton({required this.node, required this.game});

  final RoomNode   node;
  final ImmunoGame game;

  static String _label(RoomType t) => switch (t) {
        RoomType.combat   => 'BOJ',
        RoomType.elite    => 'ELITE',
        RoomType.treasure => 'LÉČENÍ',
        RoomType.boss     => 'BOSS',
      };

  static IconData _icon(RoomType t) => switch (t) {
        RoomType.combat   => Icons.gps_fixed,
        RoomType.elite    => Icons.star,
        RoomType.treasure => Icons.medical_services,
        RoomType.boss     => Icons.whatshot,
      };

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
              Icon(_icon(node.type), color: c, size: 44),
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
