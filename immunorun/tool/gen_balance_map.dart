// Generátor mapy jméno → hodnota pro placeholdery {{balance.<konstanta>|…}}
// (06-sync ADR 0002). Spusť po každé změně názvů v balance.dart:
//   dart run tool/gen_balance_map.dart   (z adresáře immunorun/)
// Výstup: lib/config/balance_map.g.dart — needitovat ručně, CI gen-check.

import 'dart:io';

const balancePath = 'lib/config/balance.dart';
const outputPath  = 'lib/config/balance_map.g.dart';

final _constRe = RegExp(
  r'^\s*static const (?:int|double)\s+(\w+)\s*=',
  multiLine: true,
);

/// Jen `static const int|double`; seznamy, barvy a záznamy se přeskočí.
String generateBalanceMap(String balanceSource) {
  final names = _constRe
      .allMatches(balanceSource)
      .map((m) => m.group(1)!)
      .toList();
  final buf = StringBuffer()
    ..writeln('// GENEROVÁNO: dart run tool/gen_balance_map.dart — needitovat ručně.')
    ..writeln('// Zdroj: $balancePath (static const int/double), ${names.length} konstant.')
    ..writeln()
    ..writeln("import 'balance.dart';")
    ..writeln()
    ..writeln('const Map<String, num> balanceLookup = {');
  for (final n in names) {
    buf.writeln("  '$n': Balance.$n,");
  }
  buf.writeln('};');
  return buf.toString();
}

void main() {
  final src = File(balancePath).readAsStringSync();
  File(outputPath).writeAsStringSync(generateBalanceMap(src));
  stdout.writeln('$outputPath zapsán.');
}
