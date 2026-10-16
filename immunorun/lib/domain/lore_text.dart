// Čistý Dart — bez Flame importů.
// Render placeholderů v textech registru, karet a kapitol knihy
// (06-sync ADR 0002): čísla se nepíší, dosazují se z balance.dart.
//
//   {{balance.<konstanta>|<formát>}}  → číslo z Balance (balance_map.g.dart)
//   {{lore.<id>}}                     → nameCz záznamu registru
//
// Formáty: pct (0.25 → „25 %"), pctDelta (1.25 → „+25 %", 0.6 → „−40 %"),
// pctLess (0.6 → „40 %"; jen pro hodnoty < 1, sloveso „méně/zpomalí" je
// v textu), s („4 s"), degC („41,5 °C"), int („1").
// Neznámá konstanta, id nebo formát = LoreTextException, ne prázdný text.

import '../config/balance_map.g.dart';
import 'lore.dart';

class LoreTextException implements Exception {
  const LoreTextException(this.message);

  final String message;

  @override
  String toString() => 'LoreTextException: $message';
}

final loreTextPlaceholder = RegExp(r'\{\{\s*([^}|]+?)\s*(?:\|\s*(\w+)\s*)?\}\}');

const loreTextFormats = {'pct', 'pctDelta', 'pctLess', 's', 'degC', 'int'};

String renderLore(
  String text, {
  Map<String, num> lookup = balanceLookup,
  LoreRegistry? registry,
}) {
  return text.replaceAllMapped(loreTextPlaceholder, (m) {
    final key    = m.group(1)!;
    final format = m.group(2);
    if (key.startsWith('balance.')) {
      final name  = key.substring('balance.'.length);
      final value = lookup[name];
      if (value == null) {
        throw LoreTextException('neznámá konstanta Balance.$name');
      }
      if (format == null) {
        throw LoreTextException('{{$key}} nemá formát (|pct, |s, …)');
      }
      return formatLoreNumber(value, format, name: name);
    }
    if (key.startsWith('lore.')) {
      if (format != null) {
        throw LoreTextException('{{$key|$format}}: pojem formát nemá');
      }
      final id = key.substring('lore.'.length);
      try {
        return (registry ?? lore).byId(id).nameCz;
      } on ArgumentError {
        throw LoreTextException('neznámý pojem $id');
      }
    }
    throw LoreTextException('neznámý placeholder {{$key}}');
  });
}

/// Chyby renderu (pro validátory); prázdné = text je v pořádku.
List<String> checkLoreText(
  String text, {
  Map<String, num> lookup = balanceLookup,
  LoreRegistry? registry,
}) {
  final errors = <String>[];
  for (final m in loreTextPlaceholder.allMatches(text)) {
    try {
      renderLore(m.group(0)!, lookup: lookup, registry: registry);
    } on LoreTextException catch (e) {
      errors.add(e.message);
    }
  }
  return errors;
}

String formatLoreNumber(num value, String format, {String name = '?'}) {
  switch (format) {
    case 'pct':
      return '${_cz(value * 100)} %';
    case 'pctDelta':
      final d = (value - 1) * 100;
      final sign = d > 0 ? '+' : (d < 0 ? '−' : '');
      return '$sign${_cz(d.abs())} %';
    case 'pctLess':
      if (value >= 1) {
        throw LoreTextException(
            'Balance.$name = $value: pctLess čeká hodnotu < 1 '
            '(text říká „méně"; při změně znaménka uprav text)');
      }
      return '${_cz((1 - value) * 100)} %';
    case 's':
      return '${_cz(value)} s';
    case 'degC':
      return '${_cz(value)} °C';
    case 'int':
      if (value != value.roundToDouble()) {
        throw LoreTextException('Balance.$name = $value není celé číslo');
      }
      return '${value.round()}';
    default:
      throw LoreTextException('neznámý formát „$format" (Balance.$name)');
  }
}

/// Česky: nejvýš 2 desetinná místa, bez koncových nul, desetinná čárka.
String _cz(num v) {
  final r = (v * 100).round() / 100;
  var s = r.toStringAsFixed(2);
  s = s.replaceFirst(RegExp(r'\.?0+$'), '');
  return s.replaceAll('.', ',');
}

extension LoreEntryText on LoreEntry {
  /// inGameCz s dosazenými čísly.
  String get inGameText => renderLore(inGameCz);
}
