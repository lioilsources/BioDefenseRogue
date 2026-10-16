import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/config/balance.dart';
import 'package:immunorun/config/balance_map.g.dart';

import '../tool/gen_balance_map.dart';

void main() {
  final source = File(balancePath).readAsStringSync();

  test('balance_map.g.dart je aktuální (dart run tool/gen_balance_map.dart)', () {
    expect(File(outputPath).readAsStringSync(), generateBalanceMap(source));
  });

  test('mapa obsahuje číselné konstanty a nic jiného', () {
    expect(balanceLookup['feverFebrilStart'], Balance.feverFebrilStart);
    expect(balanceLookup['membranaExtraDashCharges'], 1);
    expect(balanceLookup.containsKey('pickupColor'), isFalse);
    expect(balanceLookup.containsKey('swimWeights'), isFalse);
  });

  test('nová konstanta v balance.dart rozbije gen-check', () {
    final changed = source.replaceFirst(
        'abstract final class Balance {',
        'abstract final class Balance {\n  static const double novaKonstanta = 1.0;');
    expect(generateBalanceMap(changed), isNot(generateBalanceMap(source)));
    expect(generateBalanceMap(changed), contains("'novaKonstanta'"));
  });
}
