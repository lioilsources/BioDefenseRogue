// Index překladů pojmů pro UI hry (lib/l10n/lore_l10n.dart). Klíč = localeName
// z AppLocalizations; čeština tu není, ta žije v lib/domain/lore.dart.

import 'lore_en.dart';

/// Přeložené názvy (live pojmy) a věty „ve hře" (karty upgradů).
class LoreTable {
  const LoreTable({required this.names, required this.inGame});

  final Map<String, String> names;

  /// Věty s placeholdery {{balance.X|fmt}} jako v inGameCz.
  final Map<String, String> inGame;
}

const Map<String, LoreTable> loreTables = {
  'en': loreEn,
};
