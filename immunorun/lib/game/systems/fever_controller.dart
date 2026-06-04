// Čistý Dart — centrální systém horečky, bez Flame importů.
// FeverController je update-loop kompatibilní (volá se s dt z FlameGame).

import '../../config/balance.dart';

class FeverSnapshot {
  const FeverSnapshot({
    required this.tempC,
    required this.normalized,
    required this.zone,
    required this.atkSpeedMulti,
  });

  final double    tempC;
  final double    normalized; // 0..1
  final FeverZone zone;
  final double    atkSpeedMulti;
}

enum FeverZone { normal, febrile, hyper, critical }

class FeverController {
  FeverController() : _tempC = Balance.feverMin;

  double _tempC;
  double _criticalAccumulator = 0.0;
  bool   _roomClear           = false;

  double get tempC      => _tempC;
  bool   get isDead     => _criticalAccumulator >= Balance.feverCriticalKillDelay;

  FeverSnapshot get snapshot {
    final norm = (_tempC - Balance.feverMin) /
                 (Balance.feverMax - Balance.feverMin);
    return FeverSnapshot(
      tempC:         _tempC,
      normalized:    norm.clamp(0.0, 1.0),
      zone:          _zone,
      atkSpeedMulti: _atkSpeedMultiplier,
    );
  }

  FeverZone get _zone {
    if (_tempC >= Balance.feverCriticalStart) return FeverZone.critical;
    if (_tempC >= Balance.feverHyperStart)    return FeverZone.hyper;
    if (_tempC >= Balance.feverFebrilStart)   return FeverZone.febrile;
    return FeverZone.normal;
  }

  double get _atkSpeedMultiplier {
    if (_zone == FeverZone.normal) return Balance.feverAtkSpeedMin;
    final t = (_tempC - Balance.feverFebrilStart) /
              (Balance.feverHyperStart - Balance.feverFebrilStart);
    return (Balance.feverAtkSpeedMin +
            t.clamp(0.0, 1.0) *
            (Balance.feverAtkSpeedMax - Balance.feverAtkSpeedMin));
  }

  void onHit()    => _rise(Balance.feverRisePerHit);
  void onAbility() => _rise(Balance.feverRisePerAbility);

  void setRoomClear(bool clear) => _roomClear = clear;

  void update(double dt, {int activeEnemies = 0}) {
    // pasivní stoupání podle počtu nepřátel
    _rise(Balance.feverRisePassivePerEnemy * activeEnemies * dt);

    // decay
    double decay = Balance.feverDecayBaseline;
    if (_roomClear) decay += Balance.feverDecayRoomClear;
    _tempC = (_tempC - decay * dt)
             .clamp(Balance.feverMin, Balance.feverMax);

    // kritický akumulátor
    if (_zone == FeverZone.critical) {
      _criticalAccumulator += dt;
    } else {
      _criticalAccumulator = (_criticalAccumulator - dt * 0.5).clamp(0.0, double.infinity);
    }
  }

  void _rise(double amount) {
    _tempC = (_tempC + amount).clamp(Balance.feverMin, Balance.feverMax);
  }

  void reset() {
    _tempC = Balance.feverMin;
    _criticalAccumulator = 0.0;
    _roomClear = false;
  }
}
