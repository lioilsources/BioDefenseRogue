import 'package:flame/components.dart';

import '../components/enemies/swarmer.dart';
import '../components/player/player.dart';

class SwarmerPool {
  SwarmerPool({required this.onPlayerContact});

  final void Function() onPlayerContact;
  final List<Swarmer>   _free = [];

  /// Vrátí připravenou Swarmer instanci — volající ji musí přidat do world.
  Swarmer acquire(Vector2 pos, Player player) {
    final s = _free.isNotEmpty
        ? _free.removeLast()
        : Swarmer(player: player, onPlayerContact: onPlayerContact);
    s.resetForPool(pos, player);
    s.onDeath = () => release(s);
    return s;
  }

  /// Odstraní swarmera ze světa a vrátí ho do volné fronty.
  void release(Swarmer s) {
    s.removeFromParent();
    _free.add(s);
  }

  /// Forcované uvolnění všech aktivních swarmů (přechod místnosti / reset).
  void releaseAll(World world) {
    for (final s in world.children.whereType<Swarmer>().toList()) {
      s.onDeath = null;
      s.removeFromParent();
      _free.add(s);
    }
  }

  /// Prewarm: předalokuje N instancí, aby první vlna neměla alokační špičku.
  void prewarm(int count, Player player) {
    while (_free.length < count) {
      _free.add(Swarmer(player: player, onPlayerContact: onPlayerContact));
    }
  }

  int get freeCount => _free.length;
}
