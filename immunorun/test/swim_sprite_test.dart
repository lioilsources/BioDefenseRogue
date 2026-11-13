import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/game/components/swim_sprite.dart';

void main() {
  test('ikony se zmenšují s filtrováním, ne nejbližším sousedem', () async {
    final image  = await _blankImage();
    final sprite = SwimSprite(sprite: Sprite(image), size: Vector2.all(36));
    expect(sprite.paint.filterQuality, FilterQuality.medium);
  });
}

Future<Image> _blankImage() {
  final recorder = PictureRecorder();
  Canvas(recorder).drawRect(const Rect.fromLTWH(0, 0, 4, 4), Paint());
  return recorder.endRecording().toImage(4, 4);
}
