// Čistý Dart — bez Flame importů.

enum RoomType { combat, elite, treasure, boss }

class RoomNode {
  RoomNode(this.id, this.type);

  final int            id;
  final RoomType       type;
  final List<RoomNode> children = [];
}
