import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/domain/enemy_archetype.dart';
import 'package:immunorun/domain/lore.dart';
import 'package:immunorun/domain/lore_text.dart';
import 'package:immunorun/domain/meta_progress.dart';
import 'package:immunorun/domain/room_type.dart';
import 'package:immunorun/domain/status_effects.dart';
import 'package:immunorun/domain/upgrade.dart';

// Fiktivní hodnota enumu — simuluje „přibyl EnemyType.x bez záznamu".
enum _NewEnemy { x }

// Minimální validní záznam pro negativní fixtury.
const _ok = LoreEntry(
  id:       'mechanic.fixture',
  kind:     LoreKind.mechanic,
  nameCz:   'Fixture',
  inGameCz: 'Věta ve hře.',
  chapter:  BookChapter.horecka,
);

LoreEntry _with({
  String? id,
  LoreKind? kind,
  LoreStatus? status,
  String? nameCz,
  String? inGameCz,
  String? realityCz,
  LieSize? lie,
  String? chapter,
  bool noChapter = false,
  Enum? ref,
  String? sourceRef,
}) =>
    LoreEntry(
      id:        id ?? _ok.id,
      kind:      kind ?? _ok.kind,
      status:    status ?? _ok.status,
      nameCz:    nameCz ?? _ok.nameCz,
      inGameCz:  inGameCz ?? _ok.inGameCz,
      realityCz: realityCz,
      lie:       lie ?? LieSize.none,
      chapter:   noChapter ? null : (chapter ?? _ok.chapter),
      ref:       ref,
      sourceRef: sourceRef,
    );

/// Validace fixtury bez požadavku na úplnost nad enumy.
List<String> _check(List<LoreEntry> entries) =>
    validateLore(entries, requiredRefs: const []);

Matcher _hasError(String fragment) =>
    contains(predicate<String>((e) => e.contains(fragment), '„$fragment"'));

void main() {
  group('Registr pojmů — reálná data', () {
    test('registr projde všemi pravidly', () {
      final errors = validateLore(allLore);
      expect(errors, isEmpty, reason: errors.join('\n'));
    });

    test('každý upgrade, nepřítel, místnost a status jde dohledat přes ref', () {
      for (final ref in loreRequiredRefs) {
        expect(lore.byRef(ref).ref, ref);
      }
    });

    test('karty upgradů čtou název a popis z registru', () {
      for (final u in allUpgrades) {
        final e = lore.byRef(u.id);
        expect(u.nameCz, e.nameCz);
        expect(u.descCz, e.inGameText);
      }
      expect(allUpgrades.map((u) => u.id), UpgradeId.values);
    });

    test('každá příčina smrti má popisek ve 3. pádě', () {
      for (final k in ['swarmer', 'tank', 'boss', 'fever']) {
        expect(killedByLabelCz(k), isNotNull, reason: k);
      }
      expect(killedByLabelCz(null), isNull);
      expect(killedByLabelCz('neznámý'), isNull);
    });

    test('místnosti mají název pro dveře', () {
      for (final t in RoomType.values) {
        expect(lore.byRef(t).nameCz.toUpperCase(), isNotEmpty);
      }
    });

    test('neznámé id / ref je chyba, ne tiché null', () {
      expect(() => lore.byId('upgrade.neexistuje'), throwsArgumentError);
    });
  });

  group('Registr pojmů — negativní fixtury (každé pravidlo musí shodit)', () {
    test('fixture sama je validní', () {
      expect(_check([_ok]), isEmpty);
    });

    test('nová hodnota enumu bez záznamu', () {
      final errors = validateLore(
        allLore,
        requiredRefs: [...loreRequiredRefs, _NewEnemy.x],
      );
      expect(errors, _hasError('_NewEnemy.x: chybí záznam'));
    });

    test('chybějící záznam pro existující EnemyType', () {
      final without =
          allLore.where((e) => e.ref != EnemyType.tank).toList();
      expect(validateLore(without), _hasError('EnemyType.tank: chybí záznam'));
    });

    test('dva záznamy se stejným ref', () {
      final errors = validateLore(
        [_with(id: 'mechanic.a', nameCz: 'A', ref: _NewEnemy.x),
         _with(id: 'mechanic.b', nameCz: 'B', ref: _NewEnemy.x)],
        requiredRefs: [_NewEnemy.x],
        isPlannedRef: (_) => false,
      );
      expect(errors, _hasError('2 záznamů'));
    });

    test('duplicitní id', () {
      expect(_check([_ok, _with(nameCz: 'Jiný')]), _hasError('duplicitní id'));
    });

    test('duplicitní nameCz', () {
      expect(_check([_ok, _with(id: 'mechanic.jiny')]),
          _hasError('duplicitní nameCz'));
    });

    test('id neodpovídá druhu', () {
      expect(_check([_with(kind: LoreKind.upgrade)]),
          _hasError('id nezačíná „upgrade."'));
    });

    test('prázdný název nebo věta', () {
      expect(_check([_with(nameCz: ' ')]), _hasError('prázdné nameCz'));
      expect(_check([_with(inGameCz: '')]), _hasError('prázdné inGameCz'));
    });

    test('live záznam bez kapitoly', () {
      expect(_check([_with(noChapter: true)]), _hasError('bez kapitoly'));
    });

    test('planned záznam bez kapitoly je povolen', () {
      expect(_check([_with(noChapter: true, status: LoreStatus.planned)]),
          isEmpty);
    });

    test('neznámá kapitola', () {
      expect(_check([_with(chapter: '99-neexistuje')]),
          _hasError('neznámá kapitola'));
    });

    test('realityCz bez zdroje', () {
      expect(_check([_with(realityCz: 'Doopravdy…', lie: LieSize.small)]),
          _hasError('realityCz bez sourceRef'));
    });

    test('realityCz s lie: none', () {
      expect(_check([_with(realityCz: 'Doopravdy…', sourceRef: 'X')]),
          _hasError('realityCz s lie: none'));
    });

    test('lie bez realityCz', () {
      expect(_check([_with(lie: LieSize.large)]),
          _hasError('lie: large bez realityCz'));
    });

    test('status bez gameplay vedený jako live', () {
      final errors = _check([
        _with(id: 'status.x', kind: LoreKind.status,
            ref: StatusEffect.stunned),
      ]);
      expect(errors, _hasError('má být planned'));
    });

    test('číslo natvrdo v inGameCz', () {
      expect(_check([_with(inGameCz: 'Bere +25 % poškození.')]),
          _hasError('číslo natvrdo'));
    });

    test('placeholder na neexistující konstantu nebo pojem', () {
      expect(_check([_with(inGameCz: 'Bere {{balance.neniTam|pct}}.')]),
          _hasError('neznámá konstanta Balance.neniTam'));
      expect(_check([_with(inGameCz: 'Viz {{lore.upgrade.neni}}.')]),
          _hasError('neznámý pojem upgrade.neni'));
      expect(_check([_with(realityCz: 'Doopravdy {{balance.x|zzz}}.',
              lie: LieSize.small, sourceRef: 'X')]),
          _hasError('neznámá konstanta Balance.x'));
    });

    test('planned záznam s ref, který už v kódu má gameplay (přechod S5)', () {
      final errors = _check([
        _with(id: 'enemy.x', kind: LoreKind.enemy,
            status: LoreStatus.planned, ref: EnemyType.tank),
      ]);
      expect(errors, _hasError('má být live'));
    });

    test('nový EnemyType bez přepnutí planned záznamu shodí úplnost', () {
      // Simulace: přibyla hodnota enumu, planned záznam zůstal bez ref.
      final errors = validateLore(
        allLore,
        requiredRefs: [...loreRequiredRefs, _NewEnemy.x],
      );
      expect(errors, _hasError('_NewEnemy.x: chybí záznam'));
    });

    test('id postavy a biomu má prefix podle druhu', () {
      expect(_check([_with(id: 'hero.x', kind: LoreKind.biome)]),
          _hasError('id nezačíná „biome."'));
    });

    test('status s gameplay vedený jako planned', () {
      final errors = _check([
        _with(id: 'status.x', kind: LoreKind.status,
            status: LoreStatus.planned, ref: StatusEffect.opsonized),
      ]);
      expect(errors, _hasError('má být live'));
    });
  });
}
