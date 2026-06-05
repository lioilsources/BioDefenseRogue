// Generátor runu: strom RoomNode uzlů, větvení = výběr dveří.
import '../../domain/room_type.dart';

export '../../domain/room_type.dart';

class RoomGraph {
  RoomGraph._(this.start);

  final RoomNode start;

  /// Fixní run: combat → [combat | elite] → boss
  factory RoomGraph.generateRun() {
    final s    = RoomNode(0, RoomType.combat);
    final a    = RoomNode(1, RoomType.combat);
    final b    = RoomNode(2, RoomType.elite);
    final bossA = RoomNode(3, RoomType.boss);
    final bossB = RoomNode(4, RoomType.boss);

    s.children.addAll([a, b]);
    a.children.add(bossA);
    b.children.add(bossB);

    return RoomGraph._(s);
  }
}
