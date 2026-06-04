import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/balance.dart';
import '../../game/components/player/player_controller.dart';

class VirtualJoystickOverlay extends StatefulWidget {
  const VirtualJoystickOverlay({super.key, required this.controller});

  final PlayerController controller;

  @override
  State<VirtualJoystickOverlay> createState() => _VirtualJoystickOverlayState();
}

class _VirtualJoystickOverlayState extends State<VirtualJoystickOverlay> {
  Offset? _baseCenter;
  Offset  _knobOffset = Offset.zero;
  int?    _pointerId;

  static const double _base = Balance.joystickBaseRadius;
  static const double _dead = Balance.joystickDeadzone;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left:   32,
      bottom: 48,
      child: SizedBox(
        width:  _base * 2,
        height: _base * 2,
        child: Listener(
          onPointerDown:   _onDown,
          onPointerMove:   _onMove,
          onPointerUp:     _onUp,
          onPointerCancel: (_) => _release(),
          child: CustomPaint(
            painter: _JoystickPainter(_knobOffset),
          ),
        ),
      ),
    );
  }

  void _onDown(PointerDownEvent e) {
    _pointerId  = e.pointer;
    _baseCenter = e.localPosition;
    _updateDelta(e.localPosition);
  }

  void _onMove(PointerMoveEvent e) {
    if (e.pointer != _pointerId) return;
    _updateDelta(e.localPosition);
  }

  void _onUp(PointerUpEvent e) {
    if (e.pointer != _pointerId) return;
    _release();
  }

  void _updateDelta(Offset pos) {
    final base  = _baseCenter!;
    var delta   = pos - base;
    if (delta.distance > _base) {
      delta = delta / delta.distance * _base;
    }
    setState(() => _knobOffset = delta);

    final norm = delta / _base;
    final v    = Vector2(norm.dx, norm.dy);
    widget.controller.joystickDelta =
        v.length < _dead ? Vector2.zero() : v;
  }

  void _release() {
    setState(() {
      _knobOffset = Offset.zero;
      _pointerId  = null;
    });
    widget.controller.joystickDelta = Vector2.zero();
  }
}

class _JoystickPainter extends CustomPainter {
  const _JoystickPainter(this.knobOffset);
  final Offset knobOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(
      center,
      Balance.joystickBaseRadius,
      Paint()..color = Colors.white.withAlpha(40),
    );
    canvas.drawCircle(
      center,
      Balance.joystickBaseRadius,
      Paint()
        ..color = Colors.white.withAlpha(80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      center + knobOffset,
      Balance.joystickKnobRadius,
      Paint()..color = Colors.white.withAlpha(160),
    );
  }

  @override
  bool shouldRepaint(_JoystickPainter old) => knobOffset != old.knobOffset;
}
