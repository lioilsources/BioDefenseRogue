import 'dart:io';

import 'package:cute_kid_fonts/cute_kid_fonts_testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/parser/book_loader.dart';
import 'package:immunorun/ui/book/book_overlay.dart';

// Golden testy typografie knihy (05-kniha §5) se skutečnými fonty
// CuteKidFonts. Vykreslení písma se liší mezi platformami, proto běží jen
// na macOS (lokálně); CI je přeskočí. Aktualizace:
//   flutter test --update-goldens test/book/book_golden_test.dart

final _skip = !Platform.isMacOS;

void main() {
  final book = assembleBook({
    for (final f in Directory('assets/book/cs').listSync().whereType<File>())
      f.uri.pathSegments.last: f.readAsStringSync(),
  });

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadKidFonts();
  });

  Future<void> scene(
    WidgetTester tester, {
    String? chapter,
    int page = 0,
    int fontStep = 0,
  }) async {
    tester.view.physicalSize     = const Size(1125, 2436); // 375 × 812 pt
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookScreen(
        book: book, initialChapter: chapter, fontStep: fontStep,
        onFontStep: (_) {}, onClose: () {},
      ),
    ));
    for (var i = 0; i < page; i++) {
      await tester.drag(find.byType(PageView), const Offset(-250, 0));
      await tester.pumpAndSettle();
    }
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pumpAndSettle();
  }

  testWidgets('seznam kapitol', (tester) async {
    await scene(tester);
    await expectLater(find.byType(BookScreen),
        matchesGoldenFile('goldens/book_list.png'));
  }, skip: _skip);

  for (final (page, name) in [(0, 'p1'), (2, 'p3_zvedave'), (3, 'p4_doopravdy'),
                              (4, 'p5_prakticky')]) {
    testWidgets('kapitola 5, $name', (tester) async {
      await scene(tester, chapter: '05-horecka', page: page);
      await expectLater(find.byType(BookScreen),
          matchesGoldenFile('goldens/horecka_$name.png'));
    }, skip: _skip);
  }

  testWidgets('kapitola 5, největší písmo', (tester) async {
    await scene(tester, chapter: '05-horecka', fontStep: 2);
    await expectLater(find.byType(BookScreen),
        matchesGoldenFile('goldens/horecka_p1_font3.png'));
  }, skip: _skip);
}
