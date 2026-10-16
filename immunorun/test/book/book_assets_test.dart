import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';

// K4: rozpočet velikosti knihy a kredity obrázků (05-kniha §5, ADR 0004).

/// Soubory v images/, které nemají řádek v CREDITS.md.
List<String> missingCredits(Iterable<String> imageFiles, String credits) => [
      for (final f in imageFiles)
        if (!credits.contains('assets/book/images/$f ')) f,
    ];

/// Součet velikostí nad rozpočtem → popis, jinak null.
String? overBudget(Map<String, int> sizes, int budget) {
  final total = sizes.values.fold(0, (a, b) => a + b);
  return total > budget ? '$total B > $budget B' : null;
}

void main() {
  final bookDir   = Directory('assets/book');
  final imagesDir = Directory('assets/book/images');

  test('assets/book se vejde do rozpočtu', () {
    final sizes = {
      for (final f in bookDir.listSync(recursive: true).whereType<File>())
        f.path: f.lengthSync(),
    };
    expect(overBudget(sizes, Balance.bookAssetsBudgetBytes), isNull);
  });

  test('každý obrázek knihy má řádek v CREDITS.md', () {
    if (!imagesDir.existsSync()) return; // do K4 bez obrázků
    final files = imagesDir.listSync().whereType<File>()
        .map((f) => f.uri.pathSegments.last);
    final credits = File('assets/CREDITS.md').readAsStringSync();
    expect(missingCredits(files, credits), isEmpty);
  });

  group('negativní fixtury', () {
    test('obrázek bez kreditu', () {
      expect(missingCredits(['05-horecka-hero.webp', 'x.webp'],
              '- assets/book/images/05-horecka-hero.webp | flux | Apache'),
          ['x.webp']);
    });
    test('přes rozpočet', () {
      expect(overBudget({'a': 7, 'b': 6}, 12), '13 B > 12 B');
      expect(overBudget({'a': 6, 'b': 6}, 12), isNull);
    });
  });
}
