// Generátor runu: strom RoomNode uzlů, větvení = výběr dveří.
import '../../domain/room_type.dart';

export '../../domain/room_type.dart';

class RoomGraph {
  RoomGraph._(this.start);

  final RoomNode start;

  /// Fixní run: combat → [combat | elite] → [treasure | boss] → boss
  factory RoomGraph.generateRun() {
    final s     = RoomNode(0, RoomType.combat);
    final a     = RoomNode(1, RoomType.combat);
    final b     = RoomNode(2, RoomType.elite);
    final t1    = RoomNode(3, RoomType.treasure);
    final t2    = RoomNode(4, RoomType.treasure);
    final bossA = RoomNode(5, RoomType.boss);
    final bossB = RoomNode(6, RoomType.boss);

    s.children.addAll([a, b]);
    a.children.addAll([t1, bossA]);
    t1.children.add(bossA);
    b.children.addAll([t2, bossB]);
    t2.children.add(bossB);

    return RoomGraph._(s);
  }
}
