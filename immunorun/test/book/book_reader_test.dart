import 'dart:io';

import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/parser/book_loader.dart';
import 'package:immunorun/config/balance.dart';
import 'package:immunorun/domain/fever_zone.dart';
import 'package:immunorun/domain/lore.dart';
import 'package:immunorun/domain/meta_progress.dart';
import 'package:immunorun/game/immuno_game.dart';
import 'package:immunorun/ui/book/book_overlay.dart';

Book _book() => assembleBook({
      for (final f in Directory('assets/book/cs').listSync().whereType<File>())
        f.uri.pathSegments.last: f.readAsStringSync(),
    });

Finder _bubble(String text) =>
    find.byWidgetPredicate((w) => w is BubbleText && w.text == text);

Finder _rich(String fragment) =>
    find.textContaining(fragment, findRichText: true);

void main() {
  final book = _book();

  Future<({List<int> font, List<int> closed})> pump(
    WidgetTester tester, {
    String? initialChapter,
    int fontStep = 0,
  }) async {
    final font = <int>[], closed = <int>[];
    tester.view.physicalSize     = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: BookScreen(
        key:            UniqueKey(),
        book:           book,
        initialChapter: initialChapter,
        fontStep:       fontStep,
        onFontStep:     font.add,
        onClose:        () => closed.add(1),
      ),
    ));
    await tester.pumpAndSettle();
    return (font: font, closed: closed);
  }

  testWidgets('seznam kapitol → čtečka → zpět na seznam', (tester) async {
    await pump(tester);
    expect(_bubble('Lexikon zdraví'), findsOneWidget);
    final title = book.chapter('05-horecka')!.title;
    await tester.scrollUntilVisible(_bubble(title), 300);
    await tester.ensureVisible(_bubble(title));
    await tester.pumpAndSettle();
    expect(_bubble(title), findsOneWidget);

    await tester.tap(_bubble(title));
    await tester.pumpAndSettle();
    expect(_bubble('Horečka'), findsOneWidget, reason: 'nadpis stránky 1');
    expect(_rich('Od 38 °C'), findsOneWidget,
        reason: 'placeholder se vyrenderuje z Balance');

    await tester.tap(find.byTooltip('Zpět'));
    await tester.pumpAndSettle();
    expect(_bubble('Lexikon zdraví'), findsOneWidget);
  });

  testWidgets('listování stránek a box s titulkem', (tester) async {
    await pump(tester, initialChapter: '05-horecka');
    await tester.drag(find.byType(PageView), const Offset(-250, 0));
    await tester.pumpAndSettle();
    expect(_bubble('Normální teplota'), findsOneWidget);
    expect(find.bySemanticsLabel('Stránka 2 z 7'), findsOneWidget);

    for (var i = 0; i < 2; i++) {
      await tester.drag(find.byType(PageView), const Offset(-250, 0));
      await tester.pumpAndSettle();
    }
    expect(_bubble('Proč horečka pomáhá'), findsOneWidget);
    expect(_bubble('Jak je to doopravdy'), findsOneWidget);
    expect(_rich('Karta Pyrogen (IL-6)'), findsOneWidget,
        reason: '{{lore.upgrade.pyrogen}} → název z registru');
  });

  testWidgets('otočení stránky hlásí zvuk (K6)', (tester) async {
    var turns = 0;
    tester.view.physicalSize     = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: BookScreen(
        book: book, initialChapter: '05-horecka', fontStep: 0,
        onFontStep: (_) {}, onClose: () {}, onPageTurn: () => turns++,
      ),
    ));
    await tester.drag(find.byType(PageView), const Offset(-250, 0));
    await tester.pumpAndSettle();
    expect(turns, 1);
  });

  testWidgets('chybějící obrázek → placeholder s popiskem', (tester) async {
    await pump(tester, initialChapter: '05-horecka');
    for (var i = 0; i < 2; i++) {
      await tester.drag(find.byType(PageView), const Offset(-250, 0));
      await tester.pumpAndSettle();
    }
    // Načtení assetu (a jeho selhání) běží mimo fake async testu.
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pumpAndSettle();
    expect(find.textContaining('přestaví termostat výš'), findsWidgets);
  });

  testWidgets('velikost písma: volba se hlásí ven a zvětší text', (tester) async {
    final calls = await pump(tester, initialChapter: '05-horecka');
    await tester.tap(find.byKey(const ValueKey('bookFont2')));
    expect(calls.font, [2]);

    double sizeOf() => tester
        .widget<BubbleText>(_bubble('Horečka'))
        .size!;
    final base = sizeOf();
    await tester.pumpWidget(MaterialApp(
      home: BookScreen(
        book: book, initialChapter: '05-horecka', fontStep: 2,
        onFontStep: (_) {}, onClose: () {},
      ),
    ));
    await tester.pumpAndSettle();
    expect(sizeOf(), closeTo(base * Balance.bookFontScales[2], 0.01));
  });

  testWidgets('deep-link: zpět zavře knihu, ze seznamu zavře křížek', (tester) async {
    final direct = await pump(tester, initialChapter: '05-horecka');
    await tester.tap(find.byTooltip('Zpět'));
    expect(direct.closed, [1]);

    final list = await pump(tester);
    await tester.tap(find.byTooltip('Zavřít'));
    expect(list.closed, [1]);
  });

  group('razítka a deep-linky (S3)', () {
    Future<List<String>> pumpS3(WidgetTester tester, {
      String? chapter, String? anchor, Set<String> seen = const {},
      String? last,
    }) async {
      final opened = <String>[];
      tester.view.physicalSize     = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: BookScreen(
          key: UniqueKey(), book: book, fontStep: 0,
          onFontStep: (_) {}, onClose: () {},
          initialChapter: chapter, initialAnchor: anchor,
          seenLore: seen, lastChapter: last, onChapterOpened: opened.add,
        ),
      ));
      await tester.pumpAndSettle();
      return opened;
    }

    testWidgets('razítko potkáno jen u kapitoly s potkaným pojmem', (tester) async {
      final title = book.chapter('05-horecka')!.title;
      Future<void> toCard() async {
        await tester.scrollUntilVisible(_bubble(title), 300);
        await tester.pumpAndSettle();
      }
      await pumpS3(tester);
      await toCard();
      expect(_bubble('potkáno'), findsNothing);
      await pumpS3(tester, seen: {'fever.febrile'}, last: '05-horecka');
      await toCard();
      expect(_bubble('potkáno'), findsOneWidget);
      expect(_bubble('naposledy'), findsOneWidget);
    });

    testWidgets('deep-link na kotvu otevře její stránku a zapíše kapitolu', (tester) async {
      final opened = await pumpS3(tester,
          chapter: '05-horecka', anchor: 'kdy-je-horecka-nebezpecna',
          seen: {'fever.hyper'});
      expect(_bubble('Kdy je horečka nebezpečná'), findsOneWidget);
      expect(find.bySemanticsLabel('Stránka 5 z 7'), findsOneWidget);
      expect(find.bySemanticsLabel('Potkáno ve hře'), findsOneWidget);
      expect(opened, ['05-horecka']);
    });

    testWidgets('neznámá kotva → první stránka', (tester) async {
      await pumpS3(tester, chapter: '05-horecka', anchor: 'neni');
      expect(find.bySemanticsLabel('Stránka 1 z 7'), findsOneWidget);
    });
  });

  group('kvíz, slovníček, rodiče (K7)', () {
    Future<({List<String> quiz})> pumpK7(WidgetTester tester, {
      String? chapter, Set<String> quizDone = const {},
    }) async {
      final quiz = <String>[];
      tester.view.physicalSize     = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: BookScreen(
          key: UniqueKey(), book: book, fontStep: 0,
          onFontStep: (_) {}, onClose: () {}, initialChapter: chapter,
          quizDone: quizDone, onQuizDone: quiz.add,
        ),
      ));
      await tester.pumpAndSettle();
      return (quiz: quiz);
    }

    Future<void> toLastPage(WidgetTester tester) async {
      for (var i = 0; i < 6; i++) {
        await tester.drag(find.byType(PageView), const Offset(-250, 0));
        await tester.pumpAndSettle();
      }
    }

    testWidgets('kvíz: odpověď s vysvětlením, po třech otázkách razítko', (tester) async {
      final r = await pumpK7(tester, chapter: '05-horecka');
      await toLastPage(tester);
      expect(_bubble('Kvíz'), findsOneWidget);
      expect(find.bySemanticsLabel('Stránka 7 z 7'), findsOneWidget);

      final quiz = book.chapter('05-horecka')!.quiz;
      for (final q in quiz) {
        final wrong = q.answers.firstWhere((a) => !a.correct);
        final answer = find.text(wrong.text).first;
        await tester.ensureVisible(answer);
        await tester.pumpAndSettle();
        await tester.tap(answer);
        await tester.pumpAndSettle();
        expect(find.textContaining(q.why), findsOneWidget);
      }
      expect(find.textContaining('Ne tak docela.'), findsNWidgets(3));
      expect(r.quiz, ['05-horecka'], reason: 'onQuizDone právě jednou');
      await tester.ensureVisible(_bubble('kvíz hotov'));
      await tester.pumpAndSettle();
      expect(_bubble('kvíz hotov'), findsOneWidget);
    });

    testWidgets('kvíz: první volba platí', (tester) async {
      await pumpK7(tester, chapter: '05-horecka');
      await toLastPage(tester);
      final q = book.chapter('05-horecka')!.quiz.first;
      final right = q.answers.firstWhere((a) => a.correct);
      final wrong = q.answers.firstWhere((a) => !a.correct);
      await tester.tap(find.text(right.text));
      await tester.pumpAndSettle();
      await tester.tap(find.text(wrong.text));
      await tester.pumpAndSettle();
      expect(find.textContaining('Správně!'), findsOneWidget);
      expect(find.textContaining('Ne tak docela.'), findsNothing);
    });

    testWidgets('heslo: tap → bublina s definicí, tap mimo zavře', (tester) async {
      await pumpK7(tester, chapter: '05-horecka');
      await tester.drag(find.byType(PageView), const Offset(-250, 0));
      await tester.pumpAndSettle();
      final term = book.glossary['hypotalamus']!;
      final finder = _rich('hypotalamus');
      // Tap na slovo „hypotalamus" v odstavci (TextSpan s recognizerem).
      final rich = tester.widget<RichText>(finder.first);
      var hit = false;
      rich.text.visitChildren((span) {
        if (span is TextSpan && span.text == 'hypotalamus') {
          (span.recognizer as TapGestureRecognizer).onTap!();
          hit = true;
          return false;
        }
        return true;
      });
      expect(hit, isTrue);
      await tester.pumpAndSettle();
      expect(_bubble(term.name), findsOneWidget);
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(_bubble(term.name), findsNothing);
    });

    testWidgets('strana pro rodiče ze seznamu kapitol', (tester) async {
      await pumpK7(tester);
      final btn = _bubble('Pro rodiče a učitele');
      await tester.scrollUntilVisible(btn, 400);
      await tester.tap(btn);
      await tester.pumpAndSettle();
      expect(_bubble('Co je Lexikon zdraví'), findsOneWidget);
      await tester.tap(find.byTooltip('Zpět'));
      await tester.pumpAndSettle();
      expect(_bubble('Lexikon zdraví'), findsOneWidget);
    });
  });

  group('hra: openBook / closeBook', () {
    ImmunoGame game({void Function(MetaProgress)? onMetaChanged}) {
      final g = ImmunoGame(
        providerContainer: ProviderContainer(),
        onMetaChanged:     onMetaChanged,
      );
      for (final name in ['book', 'pause']) {
        g.overlays.addEntry(name, (_, _) => const SizedBox());
      }
      return g;
    }

    test('z běžící hry pauzne a po zavření pustí', () {
      final g = game()..resumeEngine();
      g.openBook(chapterId: '05-horecka');
      expect(g.isBookOpen, isTrue);
      expect(g.paused, isTrue);
      expect(g.bookChapterRequest, '05-horecka');
      g.closeBook();
      expect(g.isBookOpen, isFalse);
      expect(g.paused, isFalse);
    });

    test('z pauzy/menu nechá hru pauznutou', () {
      final g = game()..pauseEngine();
      g.openBook();
      g.closeBook();
      expect(g.paused, isTrue);
    });

    test('pauza se přes otevřenou knihu neotevře', () {
      final g = game()..resumeEngine();
      g.openBook();
      g.pauseGame();
      expect(g.overlays.isActive('pause'), isFalse);
    });

    test('deep-link na pojem nese kapitolu i kotvu', () {
      final g = game()..pauseEngine();
      g.openBookAt(lore.byRef(FeverZone.hyper));
      expect(g.bookChapterRequest, '05-horecka');
      expect(g.bookAnchorRequest, 'kdy-je-horecka-nebezpecna');
    });

    test('poslední kapitola a výběr upgradu se uloží', () {
      final saved = <MetaProgress>[];
      final g = game(onMetaChanged: saved.add);
      g.setLastChapter('03-nepratele');
      expect(saved.last.lastChapter, '03-nepratele');
      g.setLastChapter('03-nepratele');
      expect(saved, hasLength(1), reason: 'beze změny se neukládá');
    });

    test('dokončený kvíz se uloží jednou', () {
      final saved = <MetaProgress>[];
      final g = game(onMetaChanged: saved.add)
        ..markQuizDone('05-horecka')
        ..markQuizDone('05-horecka');
      expect(g.meta.quizDone, {'05-horecka'});
      expect(saved, hasLength(1));
    });

    test('velikost písma se uloží do mety', () {
      final saved = <MetaProgress>[];
      final g = game(onMetaChanged: saved.add);
      g.setBookFontStep(1);
      expect(g.meta.bookFontStep, 1);
      expect(saved.single.bookFontStep, 1);
    });
  });
}
