// Překlady pojmů registru (lib/domain/lore.dart) pro UI hry.
//
// Zdroj pravdy zůstává čeština v lore.dart; tabulky v lore/ jsou překlady
// z ní (jen live pojmy: názvy, u karet upgradů i věta „ve hře"). Kniha,
// validace a report dál čtou nameCz/inGameCz — kniha je zatím jen česky.
// Chybějící překlad → česky (test/l10n_test.dart hlídá úplnost).

import '../domain/lore.dart';
import '../domain/lore_text.dart';
import 'lore/lore_tables.dart';

export 'lore/lore_tables.dart' show LoreTable, loreTables;

/// Jazyk textů pojmů v UI hry = AppLocalizations.localeName (main.dart).
/// Globální, protože registr čte i herní kód bez BuildContextu.
String loreLocale = 'cs';

LoreTable? loreTableFor(String locale) =>
    loreTables[locale] ?? loreTables[locale.split('_').first];

extension LoreEntryL10n on LoreEntry {
  /// Název pojmu v jazyce UI.
  String get name {
    if (loreLocale == 'cs') return nameCz;
    return loreTableFor(loreLocale)?.names[id] ?? nameCz;
  }

  /// Věta „ve hře" v jazyce UI s dosazenými čísly.
  String get inGame {
    if (loreLocale == 'cs') return inGameText;
    final t = loreTableFor(loreLocale)?.inGame[id];
    return t == null ? inGameText : renderLore(t, locale: loreLocale);
  }

  /// Nepřítel ve větě „imunizace proti …": česky 3. pád, jinde název
  /// (překlady věty jsou postavené tak, aby pád nepotřebovaly).
  String get vaccinationTarget =>
      loreLocale == 'cs' ? (dativeCz ?? nameCz) : name;
}
