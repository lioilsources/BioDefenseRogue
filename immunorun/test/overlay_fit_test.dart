import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/domain/room_type.dart';
import 'package:immunorun/domain/upgrade.dart';
import 'package:immunorun/game/immuno_game.dart';
import 'package:immunorun/ui/overlays/room_choice_overlay.dart';
import 'package:immunorun/ui/overlays/upgrade_choice_overlay.dart';

/// Hra s pevnou nabídkou; onLoad se nevolá, overlay čte jen gettery.
class _Game extends ImmunoGame {
  _Game() : super(providerContainer: ProviderContainer());

  @override
  List<UpgradeDef> get pendingUpgrades => allUpgrades.take(3).toList();

  @override
  List<RoomNode> get pendingChoices => [
        RoomNode(1, RoomType.combat),
        RoomNode(2, RoomType.elite),
        RoomNode(3, RoomType.treasure),
      ];
}

void main() {
  // Nejmenší telefony na šířku (pt). Testovací písmo je širší než skutečné,
  // takže je to přísnější než realita.
  const sizes = [Size(667, 375), Size(800, 360), Size(568, 320)];

  final overlays = <String, Widget Function(ImmunoGame)>{
    'upgrady': (g) => UpgradeChoiceOverlay(game: g),
    'dveře':   (g) => RoomChoiceOverlay(game: g),
  };

  for (final MapEntry(key: name, value: build) in overlays.entries) {
    for (final size in sizes) {
      testWidgets('$name se vejde na ${size.width.toInt()}×${size.height.toInt()}',
          (tester) async {
        tester.view.physicalSize     = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: build(_Game()))));
        await tester.pump();

        expect(tester.takeException(), isNull); // RenderFlex overflow
        final card = tester.getRect(find.byType(Container).first);
        expect(card.top, greaterThanOrEqualTo(0));
        expect(card.bottom, lessThanOrEqualTo(size.height));
        expect(card.left, greaterThanOrEqualTo(0));
        expect(card.right, lessThanOrEqualTo(size.width));
      });
    }
  }
}
