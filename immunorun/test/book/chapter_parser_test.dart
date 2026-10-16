import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/model/book_model.dart';
import 'package:immunorun/book/parser/chapter_parser.dart';

const _fm = '''
---
id: 06-zanet-a-histamin
title: T
part: 3
palette: peach
hero: 06-zanet-a-histamin-hero.webp
lore: []
quiz: []
---
''';

List<String> _bodyErrors(String body) => parseChapter('$_fm$body').errors;

Matcher _has(String fragment) =>
    contains(predicate<String>((e) => e.contains(fragment), '„$fragment"'));

void main() {
  group('vzorová kapitola 05-horecka', () {
    late Chapter c;

    setUpAll(() {
      final r = parseChapter(
          File('assets/book/cs/05-horecka.md').readAsStringSync());
      expect(r.errors, isEmpty, reason: r.errors.join('\n'));
      c = r.chapter!;
    });

    test('front matter', () {
      expect(c.id, '05-horecka');
      expect(c.part, 3);
      expect(c.palette, 'peach');
      expect(c.lore, contains('fever.febrile'));
      expect(c.quiz, hasLength(3));
      expect(c.quiz.first.answers.where((a) => a.correct), hasLength(1));
    });

    test('stránky a kotvy', () {
      expect(c.pages, hasLength(6));
      expect(c.pages.map((p) => p.anchor), [
        'horecka',
        'normalni-teplota',
        'pyrogeny',
        'proc-horecka-pomaha',
        'kdy-je-horecka-nebezpecna',
        'horecka-u-zvirat',
      ]);
    });

    test('hesla včetně tvaru se svislítkem', () {
      final terms = c.allBlocks
          .whereType<ParagraphBlock>()
          .expand((p) => p.inlines)
          .whereType<TermRun>()
          .map((t) => '${t.text}→${t.termId}');
      expect(terms, containsAll([
        'hypotalamus→hypotalamus',
        'pyrogen→pyrogen',
        'Bílé krvinky→bila-krvinka',
      ]));
    });

    test('boxy, obrázek a zdroje', () {
      final boxes = c.allBlocks.whereType<BoxBlock>().map((b) => b.kind);
      expect(boxes, [
        BoxKind.zvedave, BoxKind.doopravdy, BoxKind.prakticky, BoxKind.vedel,
      ]);
      final practical =
          c.allBlocks.whereType<BoxBlock>().firstWhere((b) => b.kind == BoxKind.prakticky);
      expect(practical.children.single, isA<ListBlock>());
      expect(practical.sources.single.keys, ['SZU', 'PEDIATRIE']);

      expect(c.allBlocks.whereType<ImageBlock>().single.file,
          '05-horecka-schema-1.webp');

      final firstSource = c.pages[1].blocks
          .whereType<ParagraphBlock>()
          .first
          .sources
          .single;
      expect(firstSource.verified, isFalse);
      expect(firstSource.keys, ['PEDIATRIE']);
    });

    test('placeholdery zůstávají v textu nevyrenderované', () {
      final p = c.pages.first.blocks.whereType<ParagraphBlock>().first;
      expect(p.plainText, contains('{{balance.feverFebrilStart|degC}}'));
    });
  });

  group('zdroje v komentářích', () {
    test('ověřený zdroj', () {
      final n = parseSourceNote(' src: JANEWAY kap. 3, s. 85 ')!;
      expect(n.verified, isTrue);
      expect(n.keys, ['JANEWAY']);
    });
    test('více klíčů a části oddělené středníkem', () {
      final n = parseSourceNote(
          'TODO-FACT: JANEWAY / KLUGER1975 – a; HOREJSI – b IL-6')!;
      expect(n.verified, isFalse);
      expect(n.keys, ['JANEWAY', 'KLUGER1975', 'HOREJSI']);
    });
    test('obyčejný komentář není zdroj', () {
      expect(parseSourceNote(' poznámka autora '), isNull);
    });
  });

  test('termSlug skládá id hesla bez diakritiky', () {
    expect(termSlug('Žírná buňka'), 'zirna-bunka');
    expect(termSlug('NK buňka'), 'nk-bunka');
  });

  group('parser odmítne nepovolené konstrukce', () {
    test('chybí front matter', () {
      expect(parseChapter('## A {#a}\n\nText.').errors,
          _has('chybí front matter'));
    });
    test('rozbitý YAML', () {
      expect(parseChapter('---\nid: [\n---\n').chapter, isNull);
    });
    test('chybí lore a quiz', () {
      final r = parseChapter('---\nid: x\ntitle: T\npart: 1\n'
          'palette: mint\nhero: x\n---\n## A {#a}\n\nText.');
      expect(r.errors, _has('chybí „lore"'));
      expect(r.errors, _has('chybí „quiz"'));
    });
    test('tabulka', () {
      expect(_bodyErrors('## A {#a}\n\n| a | b |\n|---|---|\n| 1 | 2 |\n'),
          _has('<table>'));
    });
    test('odkaz', () {
      expect(_bodyErrors('## A {#a}\n\nViz [web](https://szu.cz).\n'),
          _has('<a>'));
    });
    test('nadpis #', () {
      expect(_bodyErrors('# Velký\n'), _has('<h1>'));
    });
    test('číslovaný seznam', () {
      expect(_bodyErrors('## A {#a}\n\n1. jedna\n2. dvě\n'), _has('<ol>'));
    });
    test('odrážky mimo box a v jiném boxu', () {
      expect(_bodyErrors('## A {#a}\n\n- jedna\n'), _has('mimo box'));
      expect(_bodyErrors('## A {#a}\n\nT.\n\n> [!vedel]\n> - jedna\n'),
          _has('jen v boxu [!prakticky]'));
    });
    test('neznámý box a citace bez tagu', () {
      expect(_bodyErrors('## A {#a}\n\nT.\n\n> [!tip]\n> x\n'),
          _has('neznámý box [!tip]'));
      expect(_bodyErrors('## A {#a}\n\nT.\n\n> jen citace\n'),
          _has('citace bez tagu'));
    });
    test('dva nadpisy ## bez oddělovače', () {
      expect(_bodyErrors('## A {#a}\n\nT.\n\n## B {#b}\n\nU.\n'),
          _has('dva nadpisy ##'));
    });
    test('HTML mimo komentář', () {
      expect(_bodyErrors('## A {#a}\n\nT.\n\n<div>x</div>\n'),
          _has('HTML mimo komentář'));
    });
    test('zdroj bez odstavce', () {
      expect(_bodyErrors('<!-- src: JANEWAY s. 1 -->\n\n## A {#a}\n\nT.\n'),
          _has('zdroj bez odstavce'));
    });
  });
}
