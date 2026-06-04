import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/balance.dart';
import '../../game/systems/fever_controller.dart';
import 'thermometer.dart';

// Notifier aktualizuje herní smyčka přes ProviderContainer
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

class HudOverlay extends ConsumerWidget {
  const HudOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fever = ref.watch(feverProvider);

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            right: 16,
            top:   16,
            child: Thermometer(snapshot: fever),
          ),
          const Positioned(
            left: 16,
            top:  16,
            child: _HpBar(),
          ),
        ],
      ),
    );
  }
}

class _HpBar extends StatelessWidget {
  const _HpBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  120,
      height: 16,
      decoration: BoxDecoration(
        color:        Colors.green.withAlpha(180),
        border:       Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
