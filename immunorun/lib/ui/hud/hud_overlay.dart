import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/balance.dart';
import '../../game/systems/fever_controller.dart';
import 'thermometer.dart';

class FeverNotifier extends Notifier<FeverSnapshot> {
  @override
  FeverSnapshot build() => FeverSnapshot(
        tempC:         Balance.feverMin,
        normalized:    0.0,
        zone:          FeverZone.normal,
        atkSpeedMulti: Balance.feverAtkSpeedMin,
      );

  void setSnapshot(FeverSnapshot snap) => state = snap;
}

final feverProvider =
    NotifierProvider<FeverNotifier, FeverSnapshot>(FeverNotifier.new);

class PlayerHpNotifier extends Notifier<double> {
  @override
  double build() => 1.0;
  void set(double v) => state = v;
}

final playerHpProvider =
    NotifierProvider<PlayerHpNotifier, double>(PlayerHpNotifier.new);

class HudOverlay extends ConsumerWidget {
  const HudOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fever = ref.watch(feverProvider);
    final hp    = ref.watch(playerHpProvider);

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            right: 16,
            top:   16,
            child: Thermometer(snapshot: fever),
          ),
          Positioned(
            left: 16,
            top:  16,
            child: _HpBar(normalized: hp),
          ),
        ],
      ),
    );
  }
}

class _HpBar extends StatelessWidget {
  const _HpBar({required this.normalized});
  final double normalized;

  @override
  Widget build(BuildContext context) {
    final color = normalized > 0.5
        ? const Color(0xFF2ECC71)
        : normalized > 0.25
            ? const Color(0xFFE67E22)
            : const Color(0xFFE74C3C);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HP',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            shadows: [Shadow(blurRadius: 3, color: Colors.black)],
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width:  120,
          height: 14,
          decoration: BoxDecoration(
            color:        Colors.black45,
            border:       Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(7),
          ),
          child: FractionallySizedBox(
            widthFactor: normalized.clamp(0.0, 1.0),
            alignment:   Alignment.centerLeft,
            child:       Container(
              decoration: BoxDecoration(
                color:        color,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
