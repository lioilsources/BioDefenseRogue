import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Druhy diskrétních akcí z gesture padu (a klávesnice).
enum PlayerActionKind { dash, chargeDash, juke, aoe }

/// Jednorázový povel z ovládání. `dir` je normalizovaný směr (null u AoE).
class PlayerAction {
  const PlayerAction(this.kind, [this.dir]);
  final PlayerActionKind kind;
  final Vector2? dir;
}

/// Most mezi vstupní vrstvou (Flutter overlay / klávesnice) a [Player].
///
/// Mobil: `driftDelta` = pomalý drift (0..1), `_pending` = fronta gest.
/// Desktop: klávesnice přes `keyboardVector` / `aimDirection`.
class PlayerController extends Component {
  // ── Drift (mobil): pomalé doladění pozice, magnituda 0..1 ──────────────────
  Vector2 driftDelta = Vector2.zero();

  // ── Fronta diskrétních gest (dash, combos) ─────────────────────────────────
  final List<PlayerAction> _pending = [];

  void pushAction(PlayerAction a) => _pending.add(a);

  /// Player si na začátku update() vybere a vyprázdní frontu.
  List<PlayerAction> drainActions() {
    if (_pending.isEmpty) return const [];
    final out = List<PlayerAction>.of(_pending);
    _pending.clear();
    return out;
  }

  // ── Zpětná vazba pro HUD: kolik dashů je k dispozici ───────────────────────
  final ValueNotifier<int> dashCharges = ValueNotifier<int>(0);

  // ── Desktop klávesnice: plný pohyb 360° ────────────────────────────────────
  Vector2 get keyboardVector {
    final keys = HardwareKeyboard.instance.logicalKeysPressed;
    var x = 0.0;
    var y = 0.0;

    if (keys.contains(LogicalKeyboardKey.keyW) ||
        keys.contains(LogicalKeyboardKey.arrowUp)) {
      y -= 1.0;
    }
    if (keys.contains(LogicalKeyboardKey.keyS) ||
        keys.contains(LogicalKeyboardKey.arrowDown)) {
      y += 1.0;
    }
    if (keys.contains(LogicalKeyboardKey.keyA) ||
        keys.contains(LogicalKeyboardKey.arrowLeft)) {
      x -= 1.0;
    }
    if (keys.contains(LogicalKeyboardKey.keyD) ||
        keys.contains(LogicalKeyboardKey.arrowRight)) {
      x += 1.0;
    }

    final v = Vector2(x, y);
    if (v.length > 1.0) v.normalize();
    return v;
  }

  /// Směr pro dash/AoE, když gesto neurčí vlastní směr (klávesnice → drift → nahoru).
  Vector2 get aimDirection {
    final kb = keyboardVector;
    if (kb.length2 > 0) return kb.normalized();
    if (driftDelta.length2 > 0) return driftDelta.normalized();
    return Vector2(0, -1);
  }

  @override
  void onRemove() {
    dashCharges.dispose();
    super.onRemove();
  }
}
