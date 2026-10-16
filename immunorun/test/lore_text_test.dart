import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/parser/chapter_parser.dart';
import 'package:immunorun/book/validation/book_validator.dart';
import 'package:immunorun/config/balance_map.g.dart';
import 'package:immunorun/domain/lore.dart';
import 'package:immunorun/domain/lore_text.dart';
import 'package:immunorun/domain/upgrade.dart';

void main() {
  group('formáty', () {
    String f(num v, String fmt) => formatLoreNumber(v, fmt);

    test('pct, pctDelta, pctLess', () {
      expect(f(0.25, 'pct'), '25 %');
      expect(f(1.25, 'pctDelta'), '+25 %');
      expect(f(0.6, 'pctDelta'), '−40 %');
      expect(f(1.0, 'pctDelta'), '0 %');
      expect(f(1.1, 'pctDelta'), '+10 %', reason: 'zaokrouhlení float chyby');
      expect(f(0.7, 'pctLess'), '30 %');
    });
    test('s, degC, int s desetinnou čárkou', () {
      expect(f(4.0, 's'), '4 s');
      expect(f(41.5, 'degC'), '41,5 °C');
      expect(f(0.15, 'degC'), '0,15 °C');
      expect(f(1, 'int'), '1');
    });
    test('pctLess hlídá znaménko', () {
      expect(() => f(1.2, 'pctLess'), throwsA(isA<LoreTextException>()));
    });
    test('int odmítne desetinné číslo', () {
      expect(() => f(1.5, 'int'), throwsA(isA<LoreTextException>()));
    });
    test('neznámý formát', () {
      expect(() => f(1, 'procenta'), throwsA(isA<LoreTextException>()));
    });
  });

  group('renderLore', () {
    test('dosadí balance i pojem', () {
      expect(renderLore('{{balance.feverCriticalStart|degC}}'), '41,5 °C');
      expect(renderLore('karta {{lore.upgrade.pyrogen}}'),
          'karta ${lore.byId('upgrade.pyrogen').nameCz}');
    });
    test('neznámá konstanta, pojem a chybějící formát jsou chyba', () {
      for (final bad in [
        '{{balance.neexistuje|pct}}',
        '{{lore.upgrade.neexistuje}}',
        '{{balance.feverMax}}',
        '{{lore.upgrade.pyrogen|pct}}',
        '{{neco.jineho}}',
      ]) {
        expect(() => renderLore(bad), throwsA(isA<LoreTextException>()),
            reason: bad);
      }
    });
  });

  test('karty upgradů po renderu (S1 znění, desetinná čárka OQ-12)', () {
    final cards = {for (final u in allUpgrades) u.nameCz: u.descCz};
    expect(cards.values, [
      'Zásahy značkují cíl — bere +25 % poškození po 4 s.',
      'Zásahy zpomalují cíl o 40 % na 2 s.',
      '+20 % poškození, ale každý výstřel zvyšuje horečku.',
      'Horečka klesá o 0,15 °C/s rychleji.',
      'Speciální útok stojí o 30 % méně ATP.',
      '+1 maximální dash náboj.',
      '+25 % základní poškození projektilů.',
    ]);
  });

  test('změna balance změní kartu i kapitolu bez úpravy textu (S2 acceptance)', () {
    final tuned = {...balanceLookup, 'opsonizedDamageTakenMulti': 1.30,
        'feverFebrilStart': 38.5};
    final card = renderLore(lore.byRef(UpgradeId.opsonin).inGameCz,
        lookup: tuned);
    expect(card, contains('+30 %'));

    final ch = parseChapter(
        File('assets/book/cs/05-horecka.md').readAsStringSync()).chapter!;
    final page1 = renderLore(mainText(ch.pages.first), lookup: tuned);
    expect(page1, contains('Od 38,5 °C'));
  });
}
