import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class PlayerController extends Component {
  Vector2 joystickDelta = Vector2.zero();

  Vector2 get direction {
    final v = _keyboardVector + joystickDelta;
    if (v.length > 1.0) v.normalize();
    return v;
  }

  Vector2 get _keyboardVector {
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
}
