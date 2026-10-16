// Čistý Dart — sestavení knihy ze sady souborů (název → obsah).
// BookRepository dodá soubory z assetů, testy přímo z disku.

import '../model/book_model.dart';
import 'chapter_parser.dart';

/// Soubory v assets/book/cs/, které nejsou kapitolou.
const String glossaryFile = 'glossary.md';
const String parentsFile  = 'parents.md';
const Set<String> nonChapterFiles = {glossaryFile, parentsFile};

class Book {
  const Book({
    required this.chapters,
    required this.glossary,
    required this.errors,
    this.parents = const [],
  });

  /// Seřazené podle id (00 → 12).
  final List<Chapter>              chapters;
  final Map<String, GlossaryTerm>  glossary;

  /// Strana pro rodiče a učitele (sekce).
  final List<BookPage>             parents;

  /// Chyby parseru ve tvaru „soubor: zpráva" (validace je zvlášť).
  final List<String>               errors;

  Chapter? chapter(String id) =>
      chapters.where((c) => c.id == id).firstOrNull;
}

Book assembleBook(Map<String, String> files) {
  final chapters = <Chapter>[];
  final errors   = <String>[];
  var   glossary = const <GlossaryTerm>[];
  var   parents  = const <BookPage>[];

  for (final MapEntry(key: name, value: text) in files.entries) {
    if (!name.endsWith('.md')) continue;
    if (name == glossaryFile) {
      final r = parseGlossary(text);
      glossary = r.terms;
      errors.addAll(r.errors.map((e) => '$name: $e'));
    } else if (name == parentsFile) {
      final r = parseParents(text);
      parents = r.sections;
      errors.addAll(r.errors.map((e) => '$name: $e'));
    } else if (!nonChapterFiles.contains(name)) {
      final r = parseChapter(text);
      if (r.chapter != null) chapters.add(r.chapter!);
      errors.addAll(r.errors.map((e) => '$name: $e'));
    }
  }
  chapters.sort((a, b) => a.id.compareTo(b.id));
  return Book(
    chapters: List.unmodifiable(chapters),
    glossary: {for (final t in glossary) t.id: t},
    errors:   List.unmodifiable(errors),
    parents:  parents,
  );
}
