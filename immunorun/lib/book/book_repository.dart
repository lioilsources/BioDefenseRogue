// Načtení knihy z assetů (AssetManifest → assembleBook), cache v paměti.
// Parser a model jsou čistý Dart; tady je jediné místo s Flutter bundlem.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'parser/book_loader.dart';

class BookRepository {
  BookRepository({AssetBundle? bundle, this.locale = 'cs'})
      : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String      locale;

  Future<Book>? _cache;

  String get dir => 'assets/book/$locale/';

  Future<Book> load() => _cache ??= _load();

  Future<Book> _load() async {
    final manifest = await AssetManifest.loadFromAssetBundle(_bundle);
    final files = <String, String>{};
    for (final path in manifest.listAssets()) {
      if (path.startsWith(dir) && path.endsWith('.md')) {
        files[path.substring(dir.length)] = await _bundle.loadString(path);
      }
    }
    final book = assembleBook(files);
    for (final e in book.errors) {
      debugPrint('[kniha] $e');
    }
    return book;
  }
}
