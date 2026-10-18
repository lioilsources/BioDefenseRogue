// Report pokrytí registru pojmů v knize + render kapitol pro garanta (06-sync S4).
//
//   flutter test tool/lore_report.dart                       # → build/lore_report.md (+ stdout)
//   flutter test tool/lore_report.dart --dart-define=LORE_RENDER=out/
//                                                           # + kapitoly s dosazenými čísly do out/
//
// Běží přes `flutter test`, ne `dart run`: registr sahá na balance.dart, které
// importuje dart:ui (barvy), a ten čistý Dart VM nemá (06-sync OQ-22).

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/parser/book_loader.dart';
import 'package:immunorun/book/report/lore_report.dart';

const _render = String.fromEnvironment('LORE_RENDER');

void main() {
  test('lore_report', () {
    final dir   = Directory('assets/book/cs');
    final files = {
      for (final f in dir.listSync().whereType<File>())
        f.uri.pathSegments.last: f.readAsStringSync(),
    };
    final book   = assembleBook(files);
    final images = Directory('assets/book/images');
    final report = loreReport(
      book.chapters,
      imageFiles: images.existsSync()
          ? {for (final f in images.listSync().whereType<File>()) f.uri.pathSegments.last}
          : null,
    );
    File('build/lore_report.md')
      ..createSync(recursive: true)
      ..writeAsStringSync(report);
    // ignore: avoid_print
    print(report);

    if (_render.isNotEmpty) {
      final out = Directory(_render)..createSync(recursive: true);
      for (final c in book.chapters) {
        File('${out.path}/${c.id}.md')
            .writeAsStringSync(renderChapterForGarant(files['${c.id}.md']!));
      }
      // ignore: avoid_print
      print('Kapitoly pro garanta: ${out.path} (${book.chapters.length})');
    }
  });
}
