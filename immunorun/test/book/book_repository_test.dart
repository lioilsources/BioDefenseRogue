import 'package:flutter_test/flutter_test.dart';
import 'package:immunorun/book/book_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('BookRepository načte kapitoly a slovníček z assetů', () async {
    final repo = BookRepository();
    final book = await repo.load();
    expect(book.errors, isEmpty, reason: book.errors.join('\n'));
    expect(book.chapter('05-horecka')?.pages, hasLength(6));
    expect(book.glossary, contains('pyrogen'));
    expect(identical(await repo.load(), book), isTrue, reason: 'cache');
  });
}
