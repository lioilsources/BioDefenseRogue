import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/domain/room_type.dart';
import 'package:immunorun/domain/upgrade.dart';
import 'package:immunorun/ui/overlays/room_choice_overlay.dart';
import 'package:immunorun/ui/overlays/upgrade_choice_overlay.dart';

void main() {
  test('každý upgrade má ikonu karty v assets', () {
    for (final id in UpgradeId.values) {
      final path = upgradeIconAsset(id);
      expect(File(path).existsSync(), isTrue, reason: '$id → $path');
    }
  });

  test('každý typ místnosti má ikonu karty v assets', () {
    for (final t in RoomType.values) {
      final path = roomIconAsset(t);
      expect(File(path).existsSync(), isTrue, reason: '$t → $path');
    }
  });
}
