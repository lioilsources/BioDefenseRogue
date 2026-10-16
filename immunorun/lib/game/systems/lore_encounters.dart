// Čistý Dart — bez Flame importů.
// Setkání s pojmy (06-sync S3, ADR 0004): jediný výstup hry do knihy.
// Hra hlásí první setkání (první tank, první febrilní zóna, první upgrade…),
// kniha z toho ukazuje razítka. Nic nevede zpět do gameplay.
// report() je O(1) a idempotentní, smí běžet v game loopu.

import '../../domain/fever_zone.dart';
import '../../domain/lore.dart';
import '../../domain/meta_progress.dart';

class LoreEncounters {
  LoreEncounters({Iterable<String> seen = const [], LoreRegistry? registry})
      : _seen = {...seen},
        _registry = registry ?? lore;

  final LoreRegistry _registry;
  final Set<String>  _seen;
  final List<String> _fresh = [];

  Set<String> get seen => Set.unmodifiable(_seen);

  /// true = pojem je nový (poprvé potkaný).
  bool report(String id) {
    if (!_seen.add(id)) return false;
    _fresh.add(id);
    return true;
  }

  /// Hodnota enumu (EnemyType, UpgradeId, StatusEffect, RoomType, FeverZone…)
  /// → záznam registru. Enum bez záznamu se tiše ignoruje (úplnost hlídá
  /// lore_registry_test, ne hra za běhu).
  bool reportRef(Enum ref) {
    final LoreEntry e;
    try {
      e = _registry.byRef(ref);
    } on ArgumentError {
      return false;
    }
    return report(e.id);
  }

  /// Zóna horečky: normální teplota se nepočítá; první febrilní zóna hlásí
  /// i zastřešující pojem Horečka.
  void reportFeverZone(FeverZone zone) {
    if (zone == FeverZone.normal) return;
    reportRef(zone);
    report('mechanic.fever');
  }

  /// Příčina smrti ('swarmer' | 'tank' | 'boss' | 'fever').
  void reportKilledBy(String? killedBy) {
    final e = loreForKilledBy(killedBy, registry: _registry);
    if (e != null) report(e.id);
  }

  /// Nové pojmy od posledního volání (pro toast „Nová stránka v knize").
  List<String> takeFresh() {
    final out = List<String>.of(_fresh);
    _fresh.clear();
    return out;
  }
}
