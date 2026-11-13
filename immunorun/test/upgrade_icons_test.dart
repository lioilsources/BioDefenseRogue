import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/domain/upgrade.dart';
import 'package:immunorun/ui/overlays/upgrade_choice_overlay.dart';

void main() {
  test('každý upgrade má ikonu karty v assets', () {
    for (final id in UpgradeId.values) {
      final path = upgradeIconAsset(id);
      expect(File(path).existsSync(), isTrue, reason: '$id → $path');
    }
  });
}
