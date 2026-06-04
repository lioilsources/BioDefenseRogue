// Místnost — implementace wave spawnů a zamykání v F2.
import 'package:flame/components.dart';

enum RoomState { locked, active, cleared }

class Room extends Component {
  RoomState state = RoomState.active;
}
