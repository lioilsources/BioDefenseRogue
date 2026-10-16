import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../book/book_repository.dart';
import '../../book/parser/book_loader.dart';

/// Kniha se načte jednou za běh appky (BookRepository má vlastní cache).
final bookRepositoryProvider = Provider<BookRepository>((_) => BookRepository());

final bookProvider = FutureProvider<Book>(
  (ref) => ref.watch(bookRepositoryProvider).load(),
);
