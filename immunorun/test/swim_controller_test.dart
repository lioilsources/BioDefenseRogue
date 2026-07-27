import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';
import 'package:immunorun/game/systems/swim_controller.dart';

void main() {
  group('SwimController', () {
    test('výstup je omezen amplitudami z Balance', () {
      final sc = SwimController();
      const dt = 1 / 60;
      for (var i = 0; i < 60 * 60; i++) {
        sc.update(dt);
        final s = sc.snapshot;
        expect(s.offsetX.abs(),
            lessThanOrEqualTo(Balance.swimDriftAmplitude + 0.001));
        expect(s.offsetY.abs(),
            lessThanOrEqualTo(Balance.swimDriftAmplitude + 0.001));
        expect(s.angleRad.abs(),
            lessThanOrEqualTo(Balance.swimRotationMaxRad + 0.0001));
        expect((s.zoomScale - 1.0).abs(),
            lessThanOrEqualTo(Balance.swimZoomAmplitude + 0.0001));
      }
    });

    test('deterministický — dva stejně krokované controllery se shodují', () {
      final a = SwimController();
      final b = SwimController();
      for (var i = 0; i < 100; i++) {
        a.update(1 / 60);
        b.update(1 / 60);
      }
      expect(a.snapshot.offsetX, b.snapshot.offsetX);
      expect(a.snapshot.offsetY, b.snapshot.offsetY);
      expect(a.snapshot.angleRad, b.snapshot.angleRad);
      expect(a.snapshot.zoomScale, b.snapshot.zoomScale);
    });

    test('reset vrátí controller do stavu čerstvé instance', () {
      final sc = SwimController();
      for (var i = 0; i < 100; i++) {
        sc.update(1 / 60);
      }
      sc.reset();

      final fresh = SwimController();
      expect(sc.time, 0.0);
      expect(sc.snapshot.offsetX, fresh.snapshot.offsetX);
      expect(sc.snapshot.offsetY, fresh.snapshot.offsetY);
      expect(sc.snapshot.angleRad, fresh.snapshot.angleRad);
      expect(sc.snapshot.zoomScale, fresh.snapshot.zoomScale);
    });

    test('snapshot se v čase mění', () {
      final sc = SwimController();
      final s0 = sc.snapshot;
      sc.update(1.0);
      final s1 = sc.snapshot;
      expect(s1.offsetX == s0.offsetX && s1.offsetY == s0.offsetY, isFalse);
    });

    test('update(0) nemění stav', () {
      final sc = SwimController();
      sc.update(2.5);
      final before = sc.snapshot;
      sc.update(0.0);
      final after = sc.snapshot;
      expect(after.offsetX, before.offsetX);
      expect(after.offsetY, before.offsetY);
      expect(after.angleRad, before.angleRad);
      expect(after.zoomScale, before.zoomScale);
    });
  });
}
