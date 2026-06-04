import 'package:flutter/material.dart';

import '../../game/systems/fever_controller.dart';

// Teploměr — hero prvek HUD. Zobrazuje aktuální teplotu a zónu.
class Thermometer extends StatelessWidget {
  const Thermometer({super.key, required this.snapshot});

  final FeverSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = _zoneColor(snapshot.zone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${snapshot.tempC.toStringAsFixed(1)}°C',
          style: TextStyle(
            color:      color,
            fontSize:   20,
            fontWeight: FontWeight.bold,
            shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width:  10,
          height: 80,
          child:  _BarPainter(snapshot.normalized, color),
        ),
      ],
    );
  }

  Color _zoneColor(FeverZone zone) => switch (zone) {
    FeverZone.normal   => const Color(0xFF5DADE2),
    FeverZone.febrile  => const Color(0xFFF4D03F),
    FeverZone.hyper    => const Color(0xFFE67E22),
    FeverZone.critical => const Color(0xFFE74C3C),
  };
}

class _BarPainter extends StatelessWidget {
  const _BarPainter(this.fill, this.color);
  final double fill;
  final Color  color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ThermoPainter(fill, color));
  }
}

class _ThermoPainter extends CustomPainter {
  const _ThermoPainter(this.fill, this.color);
  final double fill;
  final Color  color;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = Colors.white24;
    final fg = Paint()..color = color;

    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(5)),
      bg,
    );
    final fillH = size.height * fill;
    canvas.drawRRect(
      RRect.fromLTRBR(
        0, size.height - fillH, size.width, size.height,
        const Radius.circular(5),
      ),
      fg,
    );
  }

  @override
  bool shouldRepaint(_ThermoPainter old) =>
      fill != old.fill || color != old.color;
}
