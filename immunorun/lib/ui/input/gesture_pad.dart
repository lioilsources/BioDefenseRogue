import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/balance.dart';
import '../../game/components/player/player_controller.dart';

/// Bod dráhy gesta: pozice na obrazovce + čas v ms (z pointer timeStamp).
class _Sample {
  const _Sample(this.pos, this.tMs);
  final Offset pos;
  final double tMs;
}

/// Celoplošná gesta-vrstva (mobil). Nahrazuje virtuální joystick.
///
/// - **pomalé tažení** → drift (jemné doladění pozice)
/// - **flick** (rychlé švihnutí) → dash ve směru švihu
/// - **dvojflick stejným směrem** → charge dash (průjezd s dmg)
/// - **flick tam a zpět** → juke (i-frames + odrazová pulzace)
/// - **kruhové gesto** → radiální nova (AoE, stojí ATP)
class GesturePadOverlay extends StatefulWidget {
  const GesturePadOverlay({super.key, required this.controller});

  final PlayerController controller;

  @override
  State<GesturePadOverlay> createState() => _GesturePadOverlayState();
}

class _GesturePadOverlayState extends State<GesturePadOverlay> {
  int?    _pointerId;
  Offset  _origin = Offset.zero;
  final List<_Sample> _path = [];

  // Dvojflick → charge dash
  double  _lastFlickMs = -1e9;
  Offset  _lastFlickDir = Offset.zero;

  PlayerController get _ctrl => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Listener(
        behavior:        HitTestBehavior.translucent,
        onPointerDown:   _onDown,
        onPointerMove:   _onMove,
        onPointerUp:     _onUp,
        onPointerCancel: (_) => _cancel(),
        child: IgnorePointer(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: ValueListenableBuilder<int>(
                valueListenable: _ctrl.dashCharges,
                builder: (_, charges, _) => _DashPips(
                  charges: charges,
                  max:     Balance.dashMaxCharges,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _ms(PointerEvent e) => e.timeStamp.inMicroseconds / 1000.0;

  void _onDown(PointerDownEvent e) {
    if (_pointerId != null) return; // v1: sledujeme jen jeden prst
    _pointerId = e.pointer;
    _origin    = e.localPosition;
    _path
      ..clear()
      ..add(_Sample(e.localPosition, _ms(e)));
  }

  void _onMove(PointerMoveEvent e) {
    if (e.pointer != _pointerId) return;
    final now = _ms(e);
    _path.add(_Sample(e.localPosition, now));

    // Okamžitá rychlost prstu z posledních dvou vzorků
    final n = _path.length;
    final dtMs = n >= 2 ? (now - _path[n - 2].tMs) : 0.0;
    final instSpeed = dtMs > 0
        ? (e.localPosition - _path[n - 2].pos).distance / (dtMs / 1000.0)
        : 0.0;

    // Rychlý pohyb = flick → drift vypneme, ať dash „vlastní" gesto
    if (instSpeed > Balance.gestureFlickMinSpeed) {
      _ctrl.driftDelta = Vector2.zero();
    } else {
      _applyDrift(e.localPosition);
    }
  }

  void _onUp(PointerUpEvent e) {
    if (e.pointer != _pointerId) return;
    _classify(_ms(e));
    _cancel();
  }

  void _applyDrift(Offset pos) {
    final delta = pos - _origin;
    final dist  = delta.distance;
    if (dist < 1e-3) {
      _ctrl.driftDelta = Vector2.zero();
      return;
    }
    final mag = (dist / Balance.gestureDriftRadius).clamp(0.0, 1.0);
    if (mag < Balance.gestureDriftDeadzone) {
      _ctrl.driftDelta = Vector2.zero();
      return;
    }
    final dir = delta / dist;
    _ctrl.driftDelta = Vector2(dir.dx * mag, dir.dy * mag);
  }

  void _cancel() {
    _pointerId       = null;
    _ctrl.driftDelta = Vector2.zero();
    _path.clear();
  }

  // ── Klasifikace gesta na pointer-up ────────────────────────────────────────

  void _classify(double endMs) {
    if (_path.length < 2) return;

    final first = _path.first;
    final last  = _path.last;
    final net   = last.pos - first.pos;
    final netLen = net.distance;

    final pathLength = _pathLength();
    final totalTurn  = _totalTurn();
    final durationS  = (endMs - first.tMs) / 1000.0;

    // 1) Combo s návratem k originu (juke / AoE)
    if (netLen < Balance.gestureComboReturnDist &&
        pathLength > Balance.gestureComboMinLength) {
      if (totalTurn >= Balance.gestureAoeMinTurn) {
        _ctrl.pushAction(const PlayerAction(PlayerActionKind.aoe));
      } else {
        _ctrl.pushAction(const PlayerAction(PlayerActionKind.juke));
      }
      return;
    }

    // 2) Flick → dash (nebo dvojflick → charge dash)
    final endSpeed = _endSpeed();
    final isFlick = netLen >= Balance.gestureFlickMinDist &&
        (durationS <= Balance.gestureFlickMaxDuration ||
            endSpeed >= Balance.gestureFlickMinSpeed);
    if (isFlick) {
      final dirN = net / netLen;
      final dir  = Vector2(dirN.dx, dirN.dy);

      final sinceLast = endMs - _lastFlickMs;
      final dot = dirN.dx * _lastFlickDir.dx + dirN.dy * _lastFlickDir.dy;
      final isDouble = sinceLast <= Balance.gestureDoubleFlickWindow * 1000.0 &&
          dot >= Balance.gestureDoubleFlickDot;

      if (isDouble) {
        _ctrl.pushAction(PlayerAction(PlayerActionKind.chargeDash, dir));
        _lastFlickMs  = -1e9; // spotřebováno
        _lastFlickDir = Offset.zero;
      } else {
        _ctrl.pushAction(PlayerAction(PlayerActionKind.dash, dir));
        _lastFlickMs  = endMs;
        _lastFlickDir = dirN;
      }
    }
    // jinak: bylo to pomalé tažení (drift) — na release nic
  }

  double _pathLength() {
    var sum = 0.0;
    for (var i = 1; i < _path.length; i++) {
      sum += (_path[i].pos - _path[i - 1].pos).distance;
    }
    return sum;
  }

  /// Součet absolutních změn směru — kruh má velké otočení, rovný flick malé.
  double _totalTurn() {
    var sum = 0.0;
    double? prevHeading;
    for (var i = 1; i < _path.length; i++) {
      final seg = _path[i].pos - _path[i - 1].pos;
      if (seg.distance < 2.0) continue; // ignoruj šum
      final heading = atan2(seg.dy, seg.dx);
      if (prevHeading != null) {
        var d = heading - prevHeading;
        while (d >  pi) {
          d -= 2 * pi;
        }
        while (d < -pi) {
          d += 2 * pi;
        }
        sum += d.abs();
      }
      prevHeading = heading;
    }
    return sum;
  }

  /// Rychlost prstu v posledních ~60 ms dráhy (px/s).
  double _endSpeed() {
    const windowMs = 60.0;
    final endT = _path.last.tMs;
    var dist = 0.0;
    for (var i = _path.length - 1; i > 0; i--) {
      dist += (_path[i].pos - _path[i - 1].pos).distance;
      if (endT - _path[i - 1].tMs >= windowMs) {
        final dtS = (endT - _path[i - 1].tMs) / 1000.0;
        return dtS > 0 ? dist / dtS : 0.0;
      }
    }
    final dtS = (endT - _path.first.tMs) / 1000.0;
    return dtS > 0 ? dist / dtS : 0.0;
  }
}

/// Indikátor dostupných dashů (pips) — jemný, dole uprostřed.
class _DashPips extends StatelessWidget {
  const _DashPips({required this.charges, required this.max});
  final int charges;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (i) {
        final filled = i < charges;
        return Container(
          width:  10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled
                ? Colors.cyanAccent.withAlpha(210)
                : Colors.white.withAlpha(40),
            border: Border.all(
              color: Colors.white.withAlpha(filled ? 180 : 60),
              width: 1,
            ),
          ),
        );
      }),
    );
  }
}
