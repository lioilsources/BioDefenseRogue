// Generický object pool — recykluje komponenty místo GC alokací.

import 'package:flame/components.dart';

class ObjectPool<T extends Component> {
  ObjectPool({required this.factory, this.initialSize = 16}) {
    for (var i = 0; i < initialSize; i++) {
      _pool.add(factory());
    }
  }

  final T Function() factory;
  final int           initialSize;
  final List<T>       _pool = [];

  T acquire() {
    if (_pool.isNotEmpty) return _pool.removeLast();
    return factory();
  }

  void release(T obj) => _pool.add(obj);

  int get available => _pool.length;
}
