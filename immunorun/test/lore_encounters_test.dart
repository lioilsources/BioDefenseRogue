import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/domain/enemy_archetype.dart';
import 'package:immunorun/domain/fever_zone.dart';
import 'package:immunorun/domain/room_type.dart';
import 'package:immunorun/domain/status_effects.dart';
import 'package:immunorun/domain/upgrade.dart';
import 'package:immunorun/game/systems/lore_encounters.dart';

enum _Unknown { x }

void main() {
  test('report je idempotentní a hlásí jen nové', () {
    final e = LoreEncounters();
    expect(e.report('enemy.tank'), isTrue);
    expect(e.report('enemy.tank'), isFalse);
    expect(e.takeFresh(), ['enemy.tank']);
    expect(e.takeFresh(), isEmpty, reason: 'takeFresh vyprázdní frontu');
    expect(e.seen, {'enemy.tank'});
  });

  test('pojmy z minulých runů nejsou nové', () {
    final e = LoreEncounters(seen: {'enemy.tank'});
    expect(e.reportRef(EnemyType.tank), isFalse);
    expect(e.takeFresh(), isEmpty);
  });

  test('vstupní body: nepřítel, upgrade, status, místnost', () {
    final e = LoreEncounters()
      ..reportRef(EnemyType.swarmer)
      ..reportRef(UpgradeId.histamin)
      ..reportRef(StatusEffect.opsonized)
      ..reportRef(RoomType.elite);
    expect(e.seen, {'enemy.swarmer', 'upgrade.histamin', 'status.opsonized',
        'room.elite'});
  });

  test('horečka: normální zóna se nepočítá, první febrilní hlásí i Horečku', () {
    final e = LoreEncounters()..reportFeverZone(FeverZone.normal);
    expect(e.seen, isEmpty);
    e.reportFeverZone(FeverZone.febrile);
    expect(e.seen, {'fever.febrile', 'mechanic.fever'});
  });

  test('příčina smrti', () {
    final e = LoreEncounters()
      ..reportKilledBy('fever')
      ..reportKilledBy('boss')
      ..reportKilledBy(null)
      ..reportKilledBy('neznámý');
    expect(e.seen, {'mechanic.fever', 'enemy.boss'});
  });

  test('enum bez záznamu v registru hra tiše ignoruje', () {
    final e = LoreEncounters();
    expect(e.reportRef(_Unknown.x), isFalse);
    expect(e.seen, isEmpty);
  });
}
