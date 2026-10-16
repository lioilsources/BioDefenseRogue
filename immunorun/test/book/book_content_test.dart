import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/parser/book_loader.dart';
import 'package:immunorun/book/validation/book_validator.dart';

// Validace obsahu nad skutečnými soubory v assets/book/cs/ (05-kniha K1).
// Release režim: flutter test --dart-define=BOOK_RELEASE=true

const _release = bool.fromEnvironment('BOOK_RELEASE');

void main() {
  final dir   = Directory('assets/book/cs');
  final files = {
    for (final f in dir.listSync().whereType<File>())
      f.uri.pathSegments.last: f.readAsStringSync(),
  };
  final book = assembleBook(files);

  final imagesDir = Directory('assets/book/images');
  final ctx = BookContext(
    glossaryIds: book.glossary.keys.toSet(),
    sourceKeys:  parseSourceKeys(
        File('../Prompts/05-kniha/sources.md').readAsStringSync()),
    imageFiles:  imagesDir.existsSync()
        ? {
            for (final f in imagesDir.listSync().whereType<File>())
              f.uri.pathSegments.last,
          }
        : null,
    release:     _release,
  );

  test('všechny soubory jdou přečíst', () {
    expect(book.errors, isEmpty, reason: book.errors.join('\n'));
    expect(book.chapters, isNotEmpty);
  });

  test('sources.md má klíče', () {
    expect(ctx.sourceKeys, containsAll(['HOREJSI', 'JANEWAY', 'SZU']));
  });

  test('slovníček projde validací', () {
    final errors = validateGlossary(book.glossary.values.toList(), ctx);
    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  for (final c in book.chapters) {
    test('kapitola ${c.id} projde validací', () {
      final issues = validateChapter(c, ctx, fileName: '${c.id}.md');
      for (final w in issues.where((i) => !i.isError)) {
        // ignore: avoid_print
        print('varování: $w');
      }
      final errors = issues.where((i) => i.isError);
      expect(errors, isEmpty, reason: errors.join('\n'));
    });
  }
}
