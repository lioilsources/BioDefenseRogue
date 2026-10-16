import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/model/book_model.dart';
import 'package:immunorun/book/parser/chapter_parser.dart';
import 'package:immunorun/book/validation/book_validator.dart';

// Negativní fixtury: každé pravidlo validace musí na rozbité kapitole spadnout
// (06-sync 02-plan §4: test, který nikdy nepadá, nic nehlídá).

const _id = '06-zanet-a-histamin';

const _quiz = '''
quiz:
  - question: Otázka jedna?
    answers:
      - text: Ano.
        correct: true
      - text: Ne.
      - text: Možná.
    why: Protože ano.
  - question: Otázka dvě?
    answers:
      - text: Ano.
        correct: true
      - text: Ne.
      - text: Možná.
    why: Protože ano.
  - question: Otázka tři?
    answers:
      - text: Ano.
        correct: true
      - text: Ne.
      - text: Možná.
    why: Protože ano.
''';

const _valid = '''
---
id: $_id
title: Zánět a histamin
part: 3
palette: peach
hero: $_id-hero.webp
lore: []
$_quiz---

## Zánět {#zanet}

Ve hře zpomalíš nepřítele. Doopravdy **histamin** roztáhne cévy.
<!-- TODO-FACT: HOREJSI – histamin a cévy -->

---

## Otok {#otok}

Tekutina z cév vytvoří otok.

> [!doopravdy]
> Ve hře histamin zpomalí bakterii. Doopravdy působí na cévy.

---

## Alergie {#alergie}

Alergie je falešný poplach.

> [!vedel]
> Překvapivý fakt.

---

## Doma {#doma}

Co dělat doma.

> [!prakticky]
> - Řekni dospělému.
''';

const _ctx = BookContext(
  glossaryIds: {'histamin', 'otok'},
  sourceKeys:  {'HOREJSI', 'JANEWAY'},
  limits:      BookLimits(chapterWordsMin: 10),
);

List<BookIssue> _validate(
  String md, {
  BookContext ctx = _ctx,
  String fileName = '$_id.md',
}) {
  final r = parseChapter(md);
  expect(r.errors, isEmpty, reason: 'fixture se musí dát přečíst');
  return validateChapter(r.chapter!, ctx, fileName: fileName);
}

List<String> _errors(String md, {BookContext ctx = _ctx, String? fileName}) =>
    _validate(md, ctx: ctx, fileName: fileName ?? '$_id.md')
        .where((i) => i.isError)
        .map((i) => i.toString())
        .toList();

String _swap(String from, String to) {
  expect(_valid.contains(from), isTrue, reason: 'fixture neobsahuje „$from"');
  return _valid.replaceFirst(from, to);
}

Matcher _has(String fragment) =>
    contains(predicate<String>((e) => e.contains(fragment), '„$fragment"'));

BookContext _ctxWith({
  Set<String>? imageFiles,
  bool release = false,
  BookLimits limits = const BookLimits(chapterWordsMin: 10),
}) =>
    BookContext(
      glossaryIds: _ctx.glossaryIds,
      sourceKeys:  _ctx.sourceKeys,
      imageFiles:  imageFiles,
      release:     release,
      limits:      limits,
    );

void main() {
  test('fixture sama je validní', () {
    expect(_errors(_valid), isEmpty);
  });

  group('front matter', () {
    test('id neodpovídá souboru', () {
      expect(_errors(_valid, fileName: 'jiny.md'), _has('neodpovídá souboru'));
    });
    test('id není v BookChapter.all', () {
      final md = _valid.replaceAll(_id, '99-neexistuje');
      expect(_errors(md, fileName: '99-neexistuje.md'),
          _has('není v BookChapter.all'));
    });
    test('příliš dlouhý title', () {
      expect(_errors(_swap('title: Zánět a histamin', 'title: ${'x' * 41}')),
          _has('title má 41 znaků'));
    });
    test('paleta neodpovídá části', () {
      expect(_errors(_swap('palette: peach', 'palette: mint')),
          _has('neodpovídá části 3'));
    });
    test('part mimo 1–4', () {
      expect(_errors(_swap('part: 3', 'part: 5')), _has('není 1–4'));
    });
    test('hero se špatným jménem', () {
      expect(_errors(_swap('hero: $_id-hero.webp', 'hero: obrazek.webp')),
          _has('neodpovídá jménu $_id-hero.webp'));
    });
  });

  group('obrázky', () {
    test('chybějící hero, když se obrázky kontrolují', () {
      expect(_errors(_valid, ctx: _ctxWith(imageFiles: {})),
          _has('„$_id-hero.webp" neexistuje'));
    });
    test('release vyžaduje obrázky i bez výpisu složky', () {
      expect(_errors(_valid, ctx: _ctxWith(release: true)),
          _has('neexistuje'));
    });
    test('chybějící schéma v textu', () {
      final md = _swap('Tekutina z cév vytvoří otok.',
          'Tekutina z cév vytvoří otok.\n\n![Popisek]($_id-schema-1.webp)');
      expect(_errors(md, ctx: _ctxWith(imageFiles: {'$_id-hero.webp'})),
          _has('„$_id-schema-1.webp" neexistuje'));
    });
    test('schéma se špatným jménem', () {
      final md = _swap('Tekutina z cév vytvoří otok.',
          'Tekutina z cév vytvoří otok.\n\n![Popisek](obr.webp)');
      expect(_errors(md), _has('neodpovídá jménu $_id-schema-<n>.webp'));
    });
    test('schéma bez popisku', () {
      final md = _swap('Tekutina z cév vytvoří otok.',
          'Tekutina z cév vytvoří otok.\n\n![]($_id-schema-1.webp)');
      expect(_errors(md), _has('bez popisku'));
    });
    test('kapitola s mechanismem bez schématu', () {
      final md = _valid
          .replaceAll(_id, '05-horecka')
          .replaceFirst('title: Zánět a histamin', 'title: Horečka');
      expect(_errors(md, fileName: '05-horecka.md'), _has('nemá schéma'));
    });
  });

  group('kvíz', () {
    test('4 otázky', () {
      final md = _swap('quiz:\n', '''
quiz:
  - question: Navíc?
    answers:
      - text: Ano.
        correct: true
      - text: Ne.
      - text: Možná.
    why: Protože.
''');
      expect(_errors(md), _has('kvíz má 4 otázek'));
    });
    test('2 odpovědi', () {
      expect(_errors(_swap('      - text: Možná.\n', '')),
          _has('2 odpovědi'));
    });
    test('žádná správná odpověď', () {
      expect(_errors(_swap('        correct: true\n', '')),
          _has('0 správných'));
    });
    test('dvě správné odpovědi', () {
      expect(_errors(_swap('      - text: Ne.\n',
          '      - text: Ne.\n        correct: true\n')),
          _has('2 správných'));
    });
    test('why příliš dlouhé', () {
      expect(_errors(_swap('why: Protože ano.', 'why: ${'slovo ' * 26}')),
          _has('why má 26 slov'));
    });
  });

  group('stránky a bloky', () {
    test('málo stránek', () {
      final md = _valid.substring(0, _valid.indexOf('\n---\n\n## Doma'));
      expect(_errors(md), _has('3 stránek'));
    });
    test('stránka bez kotvy', () {
      expect(_errors(_swap('## Otok {#otok}', '## Otok')),
          _has('nemá kotvu'));
    });
    test('duplicitní kotva', () {
      expect(_errors(_swap('{#otok}', '{#zanet}')), _has('duplicitní kotva'));
    });
    test('kotva s diakritikou', () {
      expect(_errors(_swap('{#otok}', '{#otok-cév}')), _has('kebab-case'));
    });
    test('dva mezititulky', () {
      expect(_errors(_swap('Tekutina z cév vytvoří otok.',
          '### A\n\nTekutina.\n\n### B\n\nZ cév.')),
          _has('2 mezititulky'));
    });
    test('dva boxy na stránce', () {
      expect(_errors(_swap('Alergie je falešný poplach.',
          'Alergie je falešný poplach.\n\n> [!zvedave]\n> Hlubší vrstva.')),
          _has('2 boxy na stránce'));
    });
    test('moc slov na stránce', () {
      expect(_errors(_swap('Alergie je falešný poplach.', 'slovo ' * 81)),
          _has('81 slov na stránce'));
    });
    test('kapitola mimo rozsah slov', () {
      expect(_errors(_valid, ctx: _ctxWith()), isEmpty);
      expect(_errors(_valid, ctx: _ctxWith(limits: const BookLimits())),
          _has('slov hlavního textu'));
    });
    test('moc odstavců na stránce', () {
      expect(_errors(_swap('Alergie je falešný poplach.',
          'A.\n\nB.\n\nC.\n\nD.\n\nE.')),
          _has('5 odstavců'));
    });
    test('dlouhá věta je jen varování', () {
      final issues = _validate(_swap('Alergie je falešný poplach.',
          '${'slovo ' * 21}konec.'));
      expect(issues.where((i) => i.isError), isEmpty);
      expect(issues.map((i) => i.toString()), _has('věta má 22 slov'));
    });
  });

  group('boxy', () {
    test('chybí doopravdy', () {
      expect(_errors(_swap('> [!doopravdy]', '> [!zvedave]')),
          _has('chybí box [!doopravdy]'));
    });
    test('chybí vedel', () {
      expect(_errors(_swap('> [!vedel]', '> [!zvedave]')),
          _has('0 boxů [!vedel]'));
    });
    test('dva prakticke boxy', () {
      expect(_errors(_swap('> [!vedel]\n> Překvapivý fakt.',
          '> [!prakticky]\n> - Druhý.\n\n---\n\n## V {#v}\n\nText.\n\n'
          '> [!vedel]\n> Fakt.')),
          _has('2 boxů [!prakticky]'));
    });
    test('box příliš dlouhý', () {
      expect(_errors(_swap('> Překvapivý fakt.', '> ${'slovo ' * 61}')),
          _has('má 61 slov'));
    });
  });

  group('hesla', () {
    test('chybějící heslo ve slovníčku', () {
      expect(_errors(_swap('**histamin**', '**cévy|ceva**')),
          _has('heslo „ceva"'));
    });
    test('heslo tučně dvakrát', () {
      expect(_errors(_swap('Tekutina z cév vytvoří otok.',
          'Tekutina z cév vytvoří **otok**. Zase **otok**.')),
          _has('heslo „otok" je tučně 2×'));
    });
  });

  group('zdroje', () {
    test('neznámý klíč', () {
      expect(_errors(_swap('TODO-FACT: HOREJSI', 'TODO-FACT: WIKIPEDIE')),
          _has('neznámý klíč zdroje „WIKIPEDIE"'));
    });
    test('zdroj bez klíče', () {
      expect(_errors(_swap('TODO-FACT: HOREJSI – histamin a cévy',
          'TODO-FACT: ověřit histamin')),
          _has('zdroj bez klíče'));
    });
    test('TODO-FACT v release', () {
      final ctx = _ctxWith(release: true, imageFiles: {'$_id-hero.webp'});
      expect(_errors(_valid, ctx: ctx), _has('TODO-FACT v release'));
      final verified =
          _swap('TODO-FACT: HOREJSI – histamin a cévy', 'src: HOREJSI s. 1');
      expect(_errors(verified, ctx: ctx), isEmpty);
    });
  });

  group('slovníček', () {
    GlossaryParseResult g(String s) => parseGlossary(s);

    test('validní heslo', () {
      final r = g('## Otok {#otok}\n\nTekutina v tkáni.\n'
          '<!-- TODO-FACT: HOREJSI – otok -->\n');
      expect(r.errors, isEmpty);
      expect(validateGlossary(r.terms, _ctx), isEmpty);
    });
    test('duplicitní heslo a heslo bez definice', () {
      final r = g('## Otok {#otok}\n\nA.\n\n## Otok {#otok}\n\n'
          '## Céva {#ceva}\n');
      final errs = validateGlossary(r.terms, _ctx).map((e) => '$e');
      expect(errs, _has('duplicitní heslo'));
      expect(errs, _has('ceva: heslo bez definice'));
    });
    test('heslo bez id', () {
      expect(g('## Otok\n\nA.\n').errors, _has('chybí {#id}'));
    });
  });

  test('BookPart mapuje části na palety', () {
    expect(BookPart.values.map((p) => '${p.number}:${p.palette}'),
        ['1:mint', '2:sky', '3:peach', '4:lavender']);
  });
}
