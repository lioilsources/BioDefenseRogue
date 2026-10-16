import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/model/book_model.dart';
import 'package:immunorun/book/parser/book_loader.dart';
import 'package:immunorun/book/report/lore_report.dart';
import 'package:immunorun/book/validation/book_sync.dart';
import 'package:immunorun/book/validation/book_validator.dart';
import 'package:immunorun/domain/lore.dart';

void main() {
  final keys = parseSourceKeys(
      File('../Prompts/05-kniha/sources.md').readAsStringSync());

  group('zdroje registru (S4)', () {
    test('každý sourceRef má klíč ze sources.md', () {
      final errors = loreSourceErrors(allLore, keys);
      expect(errors, isEmpty, reason: errors.join('\n'));
    });

    LoreEntry entry(String ref) => LoreEntry(
          id: 'mechanic.x', kind: LoreKind.mechanic, nameCz: 'X',
          inGameCz: 'Ve hře.', realityCz: 'Doopravdy.', lie: LieSize.small,
          chapter: BookChapter.horecka, sourceRef: ref,
        );

    test('neznámý klíč', () {
      expect(loreSourceErrors([entry('TODO-FACT: WIKIPEDIE – x')], keys),
          [contains('neznámý klíč zdroje „WIKIPEDIE"')]);
    });
    test('sourceRef bez klíče (volný text)', () {
      expect(loreSourceErrors([entry('TODO-FACT: Janeway (opsonizace)')], keys),
          [contains('bez klíče')]);
    });
  });

  group('lore_report', () {
    final book = assembleBook({
      for (final f in Directory('assets/book/cs').listSync().whereType<File>())
        f.uri.pathSegments.last: f.readAsStringSync(),
    });

    test('reálná kniha pokrývá 100 % live pojmů', () {
      final r = loreReport(book.chapters);
      final live = allLore.where((e) => e.status == LoreStatus.live).length;
      expect(r, contains('$live / $live (100 %)'));
      expect(r, contains('`fever.febrile`'));
    });

    test('chybějící kapitola sníží pokrytí a je vidět', () {
      final without =
          book.chapters.where((c) => c.id != BookChapter.horecka).toList();
      final r = loreReport(without);
      expect(r, isNot(contains('(100 %)')));
      expect(r, contains('05-horecka (chybí)'));
    });

    test('render pro garanta dosadí čísla a ukáže co ověřit', () {
      final out = renderChapterForGarant(
          'Od {{balance.feverFebrilStart|degC}}.\n<!-- TODO-FACT: PEDIATRIE – x -->\n'
          '<!-- src: JANEWAY s. 1 -->\n<!-- poznámka -->');
      expect(out, contains('Od 38 °C.'));
      expect(out, contains('**OVĚŘIT:** PEDIATRIE – x'));
      expect(out, contains('*[zdroj: JANEWAY s. 1]*'));
      expect(out, isNot(contains('poznámka')));
    });
  });

  test('BookPart a kapitoly sedí s registrem (sanity)', () {
    expect(BookPart.byNumber(3)!.palette, 'peach');
  });
}
