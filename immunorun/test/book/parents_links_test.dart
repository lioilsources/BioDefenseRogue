import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/parser/book_loader.dart';
import 'package:immunorun/ui/book/parents_view.dart';

/// Odkazy ze strany pro rodiče se otevřou až po potvrzení (05-kniha OQ-29).
void main() {
  final book = assembleBook({
    for (final f in Directory('assets/book/cs').listSync().whereType<File>())
      f.uri.pathSegments.last: f.readAsStringSync(),
  });

  Future<List<Uri>> pump(WidgetTester tester, {bool canOpen = true}) async {
    final opened = <Uri>[];
    tester.view.physicalSize     = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ParentsView(
          sections: book.parents,
          onBack:   () {},
          openUrl:  (u) async {
            opened.add(u);
            return canOpen;
          },
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
        find.textContaining('szu.cz', findRichText: true), 200);
    await tester.pumpAndSettle();
    return opened;
  }

  Future<void> tapLink(WidgetTester tester, String domain) async {
    await tester.tapOnText(find.textRange.ofSubstring(domain));
    await tester.pumpAndSettle();
  }

  testWidgets('ťuknutí na adresu se zeptá a po potvrzení otevře https', (tester) async {
    final opened = await pump(tester);
    await tapLink(tester, 'szu.cz');
    expect(find.text('Otevřít v prohlížeči?'), findsOneWidget);
    expect(opened, isEmpty); // nic se neotevřelo bez potvrzení

    await tester.tap(find.text('Otevřít'));
    await tester.pumpAndSettle();
    expect(opened, [Uri.parse('https://szu.cz')]);
  });

  testWidgets('„Zůstat“ nic neotevře', (tester) async {
    final opened = await pump(tester);
    await tapLink(tester, 'who.int');
    await tester.tap(find.text('Zůstat'));
    await tester.pumpAndSettle();
    expect(opened, isEmpty);
    expect(find.text('Otevřít v prohlížeči?'), findsNothing);
  });

  testWidgets('když web nejde otevřít, řekne to', (tester) async {
    await pump(tester, canOpen: false);
    await tapLink(tester, 'mzcr.cz');
    await tester.tap(find.text('Otevřít'));
    await tester.pumpAndSettle();
    expect(find.text('Web mzcr.cz se nepodařilo otevřít.'), findsOneWidget);
  });

  testWidgets('všechny tři adresy z „Kam dál“ jdou ťuknout', (tester) async {
    await pump(tester);
    for (final d in ['szu.cz', 'mzcr.cz', 'who.int']) {
      await tapLink(tester, d);
      expect(find.text('Otevřít v prohlížeči?'), findsOneWidget, reason: d);
      await tester.tap(find.text('Zůstat'));
      await tester.pumpAndSettle();
    }
  });
}
