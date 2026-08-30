import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/game/rooms/room_graph.dart';

void main() {
  group('RoomGraph.generateRun', () {
    List<List<RoomNode>> allPaths(RoomNode start) {
      final paths = <List<RoomNode>>[];
      void walk(RoomNode node, List<RoomNode> prefix) {
        final path = [...prefix, node];
        if (node.children.isEmpty) {
          paths.add(path);
        } else {
          for (final c in node.children) {
            walk(c, path);
          }
        }
      }

      walk(start, []);
      return paths;
    }

    test('každá cesta končí bossem', () {
      final graph = RoomGraph.generateRun();
      for (final path in allPaths(graph.start)) {
        expect(path.last.type, RoomType.boss);
      }
    });

    test('start je combat a nabízí volbu dveří', () {
      final graph = RoomGraph.generateRun();
      expect(graph.start.type, RoomType.combat);
      expect(graph.start.children.length, greaterThanOrEqualTo(2));
    });

    test('treasure je dosažitelný aspoň jednou cestou', () {
      final graph = RoomGraph.generateRun();
      final hasTreasure = allPaths(graph.start)
          .any((p) => p.any((n) => n.type == RoomType.treasure));
      expect(hasTreasure, isTrue);
    });

    test('treasure není slepá ulička — vede dál k bossovi', () {
      final graph = RoomGraph.generateRun();
      for (final path in allPaths(graph.start)) {
        for (final node in path) {
          if (node.type == RoomType.treasure) {
            expect(node.children, isNotEmpty);
          }
        }
      }
    });
  });
}
