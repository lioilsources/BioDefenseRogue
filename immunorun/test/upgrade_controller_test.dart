import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';
import 'package:immunorun/domain/status_effects.dart';
import 'package:immunorun/domain/upgrade.dart';
import 'package:immunorun/game/systems/upgrade_controller.dart';

void main() {
  group('UpgradeController', () {
    test('bez upgradů jsou modifikátory neutrální', () {
      final c = UpgradeController();
      expect(c.damageMulti, 1.0);
      expect(c.feverDecayBonus, 0.0);
      expect(c.atpCostMulti, 1.0);
      expect(c.extraDashCharges, 0);
      expect(c.feverPerShot, 0.0);
      expect(c.onHitStatuses, isEmpty);
    });

    test('pyrogen + cytotoxin: damage multi se násobí', () {
      final c = UpgradeController()
        ..acquire(UpgradeId.pyrogen)
        ..acquire(UpgradeId.cytotoxin);
      expect(
        c.damageMulti,
        closeTo(Balance.pyrogenDamageMulti * Balance.cytotoxinDamageMulti, 0.001),
      );
      expect(c.feverPerShot, Balance.pyrogenFeverPerShot);
    });

    test('opsonin + histamin: on-hit statusy', () {
      final c = UpgradeController()
        ..acquire(UpgradeId.opsonin)
        ..acquire(UpgradeId.histamin);
      expect(c.onHitStatuses,
          containsAll([StatusEffect.opsonized, StatusEffect.slowed]));
    });

    test('rollOffer nenabízí vlastněné a respektuje count', () {
      final c = UpgradeController()..acquire(UpgradeId.treg);
      final offer = c.rollOffer(Random(42), 3);
      expect(offer.length, 3);
      expect(offer.any((u) => u.id == UpgradeId.treg), isFalse);
    });

    test('rollOffer po vlastnění všeho vrací prázdno', () {
      final c = UpgradeController();
      for (final u in allUpgrades) {
        c.acquire(u.id);
      }
      expect(c.rollOffer(Random(1), 3), isEmpty);
    });

    test('reset vyčistí vlastněné', () {
      final c = UpgradeController()..acquire(UpgradeId.membrana);
      expect(c.extraDashCharges, Balance.membranaExtraDashCharges);
      c.reset();
      expect(c.extraDashCharges, 0);
      expect(c.owned, isEmpty);
    });
  });
}
