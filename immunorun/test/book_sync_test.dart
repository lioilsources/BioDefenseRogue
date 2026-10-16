import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/model/book_model.dart';
import 'package:immunorun/book/parser/book_loader.dart';
import 'package:immunorun/book/validation/book_sync.dart';
import 'package:immunorun/domain/lore.dart';

// Sync kniha ↔ registr ↔ balance (06-sync S2). Nad skutečnými assety
// a nad fixturami, kde každé pravidlo musí spadnout.

const _release = bool.fromEnvironment('BOOK_RELEASE');

// ── Fixtury ──────────────────────────────────────────────────────────────

const _ch = BookChapter.zanet;

LoreEntry _entry(String id, {String? anchor = 'otok', String? reality}) =>
    LoreEntry(
      id:        id,
      kind:      LoreKind.mechanic,
      nameCz:    'Pojem $id',
      inGameCz:  'Ve hře.',
      realityCz: reality,
      lie:       reality == null ? LieSize.none : LieSize.small,
      sourceRef: reality == null ? null : 'TODO-FACT: X',
      chapter:   _ch,
      anchor:    anchor,
    );

final _upgrade = LoreEntry(
  id:       'upgrade.fixture',
  kind:     LoreKind.upgrade,
  nameCz:   'Karta Fixture (X)',
  inGameCz: 'Ve hře.',
  chapter:  BookChapter.cytokiny,
);

Chapter _chapter({
  List<String> lore = const ['mechanic.a'],
  String text = 'Text.',
  bool honesty = true,
  ChapterStatus status = ChapterStatus.live,
  String quizWhy = 'Protože.',
}) =>
    Chapter(
      id:      _ch,
      title:   'T',
      part:    3,
      palette: 'peach',
      hero:    '$_ch-hero.webp',
      lore:    lore,
      status:  status,
      quiz:    [
        QuizQuestion(question: 'Q?', answers: const [QuizAnswer('A')],
            why: quizWhy),
      ],
      pages: [
        BookPage([
          const HeadingBlock(level: 2, text: 'Otok', anchor: 'otok'),
          ParagraphBlock([TextRun(text)]),
          if (honesty)
            const BoxBlock(BoxKind.doopravdy, [ParagraphBlock([TextRun('D.')])]),
        ]),
      ],
    );

List<String> _sync(
  List<Chapter> chapters, {
  List<LoreEntry>? entries,
  bool release = false,
  Iterable<String> known = const [_ch],
}) =>
    validateBookSync(
      chapters,
      registry:      LoreRegistry(entries ?? [_entry('mechanic.a'), _upgrade]),
      release:       release,
      knownChapters: known,
    ).where((i) => i.isError).map((i) => '$i').toList();

Matcher _has(String fragment) =>
    contains(predicate<String>((e) => e.contains(fragment), '„$fragment"'));

void main() {
  group('reálné assety', () {
    final dir   = Directory('assets/book/cs');
    final book  = assembleBook({
      for (final f in dir.listSync().whereType<File>())
        f.uri.pathSegments.last: f.readAsStringSync(),
    });

    test('kapitoly sedí s registrem a balance', () {
      final errors = validateBookSync(book.chapters, release: _release)
          .where((i) => i.isError);
      expect(errors, isEmpty, reason: errors.join('\n'));
    });

    test('mimo release se chybějící kapitoly přeskočí, v release ne', () {
      final ids = book.chapters.map((c) => c.id).toSet();
      final missing = BookChapter.all.where((id) => !ids.contains(id)).length;
      final errs = validateBookSync(book.chapters, release: true)
          .where((i) => i.message == 'kapitola chybí');
      expect(errs, hasLength(missing));
    });
  });

  group('fixtury', () {
    test('fixture sama je validní', () {
      expect(_sync([_chapter()]), isEmpty);
    });

    test('lore: id, které v registru není', () {
      expect(_sync([_chapter(lore: ['mechanic.a', 'mechanic.neni'])]),
          _has('„mechanic.neni" není v registru'));
    });

    test('lore: záznam z jiné kapitoly', () {
      expect(_sync([_chapter(lore: ['mechanic.a', 'upgrade.fixture'])]),
          _has('patří do kapitoly „${BookChapter.cytokiny}"'));
    });

    test('live záznam, který kapitola neuvádí', () {
      expect(_sync([_chapter()],
              entries: [_entry('mechanic.a'), _entry('mechanic.b')]),
          _has('mechanic.b: kapitola $_ch ho neuvádí'));
    });

    test('kotva záznamu v kapitole neexistuje', () {
      expect(_sync([_chapter()],
              entries: [_entry('mechanic.a', anchor: 'jinde')]),
          _has('kotva #jinde'));
    });

    test('realityCz bez boxu doopravdy', () {
      expect(_sync([_chapter(honesty: false)],
              entries: [_entry('mechanic.a', reality: 'Doopravdy.')]),
          _has('chybí box [!doopravdy]'));
    });

    test('placeholder, který nejde vyrenderovat (text i kvíz)', () {
      expect(_sync([_chapter(text: 'Od {{balance.neni|degC}}.')]),
          _has('neznámá konstanta Balance.neni'));
      expect(_sync([_chapter(quizWhy: 'Viz {{lore.mechanic.neni}}.')]),
          _has('neznámý pojem mechanic.neni'));
    });

    test('jednoslovný název karty je běžné slovo, ne chyba', () {
      final word = LoreEntry(
        id: 'upgrade.slovo', kind: LoreKind.upgrade, nameCz: 'Histamin',
        inGameCz: 'Ve hře.', chapter: BookChapter.zanet, anchor: 'otok',
      );
      expect(_sync([_chapter(text: 'Histamin roztáhne cévy.',
              lore: ['mechanic.a', 'upgrade.slovo'])],
              entries: [_entry('mechanic.a'), word]),
          isEmpty);
    });

    test('název karty natvrdo místo {{lore.…}}', () {
      expect(_sync([_chapter(text: 'Karta Fixture (X) pomáhá.')]),
          _has('natvrdo'));
      expect(_sync([_chapter(text: 'Karta {{lore.upgrade.fixture}} pomáhá.')]),
          isEmpty);
    });

    test('release: chybějící kapitola a planned kapitola', () {
      expect(_sync([_chapter()], release: true,
              known: const [_ch, BookChapter.horecka]),
          _has('${BookChapter.horecka}: kapitola chybí'));
      expect(_sync([_chapter(status: ChapterStatus.planned,
              lore: const [])], release: true, entries: const []),
          isEmpty, reason: 'pahýl fáze 2 v release smí být, čtečka ho skryje');
    });

    test('planned kapitola s live záznamem', () {
      expect(_sync([_chapter(status: ChapterStatus.planned)]),
          _has('live záznam „mechanic.a" v planned kapitole'));
    });

    test('release: live záznam s neexistující kapitolou', () {
      final orphan = LoreEntry(
        id: 'mechanic.c', kind: LoreKind.mechanic, nameCz: 'C',
        inGameCz: 'Ve hře.', chapter: BookChapter.horecka,
      );
      expect(_sync([_chapter()], entries: [_entry('mechanic.a'), orphan]),
          isEmpty, reason: 'mimo release se kapitola K3 přeskočí');
      expect(_sync([_chapter()], entries: [_entry('mechanic.a'), orphan],
              release: true, known: const [_ch]),
          _has('mechanic.c: kapitola „${BookChapter.horecka}" neexistuje'));
    });
  });
}
