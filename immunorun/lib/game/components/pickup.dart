import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../config/balance.dart';
import 'particle_burst.dart';
import 'player/player.dart';

/// ATP drop z killu — magnet-drift k hráči, po sběru dá ATP.
/// Recyklace přes ObjectPool (viz ImmunoGame) — resetForPool + onDone.
class AtpPickup extends CircleComponent {
  AtpPickup()
      : super(
          radius: Balance.pickupRadius,
          anchor: Anchor.center,
          paint:  Paint()..color = Balance.pickupColor,
        );

  double  _life   = Balance.pickupLifetime;
  double  _amount = 0;
  double  _phase  = 0; // pulzování
  Player? _player;
  void Function(AtpPickup)? _onDone;
  void Function()?          _onCollected;

  void resetForPool(
    Vector2 pos,
    double amount,
    Player player,
    void Function(AtpPickup) onDone, {
    void Function()? onCollected,
  }) {
    position     = pos;
    scale        = Vector2.all(1);
    _life        = Balance.pickupLifetime;
    _amount      = amount;
    _phase       = 0;
    _player      = player;
    _onDone      = onDone;
    _onCollected = onCollected;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final player = _player;
    if (player == null) return;

    _life  -= dt;
    _phase += dt;
    // Jemné pulzování, ke konci života zrychlí (varování před despawnem)
    final pulseFreq = _life < 2.0 ? 8.0 : 3.0;
    scale.setAll(1.0 + 0.15 * sin(_phase * pulseFreq));

    if (_life <= 0) {
      _finish();
      return;
    }

    final delta = player.position - position;
    final dist  = delta.length;

    if (dist < Balance.playerRadius + Balance.pickupRadius) {
      player.gainAtp(_amount);
      parent?.add(ParticleBurst(
        origin:    position.clone(),
        count:     Balance.hitParticleCount,
        baseColor: Balance.pickupColor,
        speedMul:  0.6,
      ));
      _onCollected?.call();
      _finish();
      return;
    }

    if (dist < Balance.pickupMagnetRadius && dist > 1.0) {
      position += delta / dist * Balance.pickupMagnetSpeed * dt;
    }
  }

  void _finish() {
    final cb     = _onDone;
    _onDone      = null;
    _onCollected = null;
    _player      = null;
    cb != null ? cb(this) : removeFromParent();
  }
}
