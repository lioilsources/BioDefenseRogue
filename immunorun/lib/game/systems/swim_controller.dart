// Čistý Dart — „plavání v roztoku": pomalý drift kamery jako pod mikroskopem.
// Vrstvené sinusoidy s nesoudělnými frekvencemi, váhy se součtem 1.0
// → každý kanál je striktně omezen svou amplitudou z Balance.

import 'dart:math' as math;

import '../../config/balance.dart';

class SwimSnapshot {
  const SwimSnapshot({
    required this.offsetX,
    required this.offsetY,
    required this.angleRad,
    required this.zoomScale,
  });

  final double offsetX;   // px
  final double offsetY;   // px
  final double angleRad;  // rad
  final double zoomScale; // multiplikátor, ~1.0
}

class SwimController {
  double _t = 0.0;

  double get time => _t;

  SwimSnapshot get snapshot => SwimSnapshot(
        offsetX:   Balance.swimDriftAmplitude * _wave(Balance.swimFreqsX),
        offsetY:   Balance.swimDriftAmplitude * _wave(Balance.swimFreqsY),
        angleRad:  Balance.swimRotationMaxRad * _wave(Balance.swimFreqsAngle),
        zoomScale: 1.0 + Balance.swimZoomAmplitude * _wave(Balance.swimFreqsZoom),
      );

  double _wave(List<double> freqs) {
    var sum = 0.0;
    for (var i = 0; i < freqs.length; i++) {
      sum += Balance.swimWeights[i] *
          math.sin(2 * math.pi * freqs[i] * _t + Balance.swimPhases[i]);
    }
    return sum;
  }

  void update(double dt) => _t += dt;

  void reset() => _t = 0.0;
}
