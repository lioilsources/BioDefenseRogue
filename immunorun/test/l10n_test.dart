// Úplnost překladů UI hry a pojmů registru (lib/l10n/).

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/domain/lore.dart';
import 'package:immunorun/domain/lore_text.dart';
import 'package:immunorun/l10n/app_localizations.dart';
import 'package:immunorun/l10n/lore_l10n.dart';
import 'package:immunorun/main.dart';

final _ph = RegExp(r'\{\{[^}]+\}\}');

List<String> _placeholders(String s) =>
    _ph.allMatches(s).map((m) => m.group(0)!).toList()..sort();

void main() {
  tearDown(() => loreLocale = 'cs');

  test('každý jazyk UI má tabulku pojmů a naopak', () {
    final ui = {
      for (final l in AppLocalizations.supportedLocales)
        if (l.languageCode != 'cs')
          [l.languageCode, ?l.scriptCode, ?l.countryCode].join('_'),
    };
    expect(ui, hasLength(44));
    expect(loreTables.keys.toSet(), ui);
  });

  test('tabulky překládají všechny live pojmy a věty karet', () {
    final live   = lore.entries.where((e) => e.status == LoreStatus.live);
    final cards  = live.where((e) => e.kind == LoreKind.upgrade);
    for (final MapEntry(key: locale, value: t) in loreTables.entries) {
      for (final e in live) {
        expect(t.names[e.id], isNotNull, reason: '$locale: ${e.id}');
        expect(t.names[e.id]!.trim(), isNotEmpty, reason: '$locale: ${e.id}');
      }
      for (final e in cards) {
        final text = t.inGame[e.id];
        expect(text, isNotNull, reason: '$locale: ${e.id}');
        expect(_placeholders(text!), _placeholders(e.inGameCz),
            reason: '$locale: ${e.id} má jiné placeholdery než čeština');
        expect(checkLoreText(text), isEmpty, reason: '$locale: ${e.id}');
      }
      expect(t.names.keys.toSet().difference({for (final e in lore.entries) e.id}),
          isEmpty, reason: '$locale: neznámé id');
    }
  });

  test('karty se vyrenderují ve všech jazycích', () {
    for (final locale in loreTables.keys) {
      loreLocale = locale;
      for (final e in lore.where(kind: LoreKind.upgrade)) {
        expect(e.inGame, isNot(contains('{{')), reason: '$locale: ${e.id}');
        expect(e.name, isNotEmpty, reason: '$locale: ${e.id}');
      }
    }
  });

  test('čeština zůstává beze změny', () {
    loreLocale = 'cs';
    final e = lore.byId('upgrade.histamin');
    expect(e.name, e.nameCz);
    expect(e.inGame, e.inGameText);
    expect(lore.byId('enemy.tank').vaccinationTarget, 'biofilmu');
  });

  test('jiný jazyk: překlad a čísla podle locale', () {
    loreLocale = 'en';
    expect(lore.byId('meta.memoryCells').name, 'Memory cells');
    expect(lore.byId('enemy.tank').vaccinationTarget,
        lore.byId('enemy.tank').name);
    expect(formatLoreNumber(41.5, 'degC', locale: 'en'), '41.5 °C');
    expect(formatLoreNumber(41.5, 'degC', locale: 'de'), '41,5 °C');
    expect(formatLoreNumber(1.25, 'pctDelta', locale: 'en'), '+25%');
    expect(formatLoreNumber(0.25, 'pct'), '25 %', reason: 'cs default');
  });

  test('tradiční čínština bez skriptu nespadne do zjednodušené', () {
    const supported = AppLocalizations.supportedLocales;
    expect(resolveAppLocale([const Locale('zh', 'TW')], supported),
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'));
    expect(resolveAppLocale([const Locale('zh', 'CN')], supported),
        const Locale('zh'));
    expect(resolveAppLocale([const Locale('pt', 'BR')], supported),
        const Locale('pt', 'BR'));
  });
}
