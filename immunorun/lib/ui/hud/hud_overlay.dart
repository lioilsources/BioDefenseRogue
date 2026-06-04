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

    return Stack(
      children: [
        // fever vignette — fullscreen, pod HUD prvky
        Positioned.fill(
          child: _FeverVignette(normalized: fever.normalized, zone: fever.zone),
        ),
        SafeArea(
          child: Stack(
            children: [
              Positioned(right: 16, top: 16, child: Thermometer(snapshot: fever)),
              Positioned(left:  16, top: 16, child: _HpBar(normalized: hp)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Fever vignette ────────────────────────────────────────────────────────

class _FeverVignette extends StatelessWidget {
  const _FeverVignette({required this.normalized, required this.zone});
  final double    normalized;
  final FeverZone zone;

  @override
  Widget build(BuildContext context) {
    if (normalized < 0.05) return const SizedBox.shrink();
    return IgnorePointer(
      child: CustomPaint(
        painter: _VignettePainter(normalized, zone),
        size:    Size.infinite,
      ),
    );
  }
}

class _VignettePainter extends CustomPainter {
  _VignettePainter(this.n, this.zone);
  final double    n;
  final FeverZone zone;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.longestSide * 0.85;

    Color edge;
    if (n < 0.3) {
      edge = Color.lerp(
          const Color(0x00F4D03F), const Color(0x55F4D03F), n / 0.3)!;
    } else if (n < 0.7) {
      edge = Color.lerp(
          const Color(0x55F4D03F), const Color(0x99E67E22), (n - 0.3) / 0.4)!;
    } else {
      edge = Color.lerp(
          const Color(0x99E67E22), const Color(0xCCE74C3C), (n - 0.7) / 0.3)!;
    }

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, edge],
        stops:  const [0.35, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_VignettePainter old) => n != old.n;
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
