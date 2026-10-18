// Čistý Dart — bez Flutter a Flame importů (05-kniha ADR 0001).
// Blokový model kapitoly knihy Lexikon zdraví. Parser (book/parser) ho staví
// z Markdownu v assets/book/cs/, čtečka (ui/book, K2) ho vykresluje.
// Formát popisuje Prompts/05-kniha/03-redakcni-standard.md.

/// Část knihy (01-scope §4). Každá část má jednu paletu CuteKidFonts.
enum BookPart {
  look(1, 'mint'),
  who(2, 'sky'),
  how(3, 'peach'),
  memory(4, 'lavender');

  const BookPart(this.number, this.palette);

  final int    number;
  final String palette;

  static BookPart? byNumber(int n) {
    for (final p in values) {
      if (p.number == n) return p;
    }
    return null;
  }
}

/// Druhy boxů; název enumu = tag v Markdownu (`> [!doopravdy]`).
enum BoxKind { doopravdy, vedel, zvedave, prakticky }

enum ChapterStatus { live, planned }

// ── Inline ─────────────────────────────────────────────────────────────────

sealed class Inline {
  const Inline(this.text);

  /// Zobrazený text (placeholdery {{…}} zůstávají nevyrenderované).
  final String text;
}

final class TextRun extends Inline {
  const TextRun(super.text);
}

/// Tučné slovo = heslo slovníčku. `**text|id**` nebo `**text**`.
final class TermRun extends Inline {
  const TermRun(super.text, this.termId);

  final String termId;
}

/// Kurzíva: latinské názvy a názvy knih.
final class EmphasisRun extends Inline {
  const EmphasisRun(super.text);
}

// ── Zdroje ─────────────────────────────────────────────────────────────────

/// `<!-- src: KLÍČ místo -->` nebo `<!-- TODO-FACT: KLÍČ – co ověřit -->`.
class SourceNote {
  const SourceNote({
    required this.verified,
    required this.keys,
    required this.text,
  });

  final bool         verified;
  final List<String> keys;
  final String       text;
}

// ── Bloky ──────────────────────────────────────────────────────────────────

sealed class Block {
  const Block();
}

/// `## Text {#kotva}` (level 2, začátek stránky) nebo `### Text` (level 3).
final class HeadingBlock extends Block {
  const HeadingBlock({required this.level, required this.text, this.anchor});

  final int     level;
  final String  text;
  final String? anchor;
}

final class ParagraphBlock extends Block {
  const ParagraphBlock(this.inlines, {this.sources = const []});

  final List<Inline>     inlines;
  final List<SourceNote> sources;

  String get plainText => inlines.map((i) => i.text).join();
}

final class ListBlock extends Block {
  const ListBlock(this.items, {this.sources = const []});

  final List<List<Inline>> items;
  final List<SourceNote>   sources;
}

final class ImageBlock extends Block {
  const ImageBlock({required this.file, required this.alt});

  final String file;
  final String alt;
}

final class BoxBlock extends Block {
  const BoxBlock(this.kind, this.children, {this.sources = const []});

  final BoxKind          kind;
  final List<Block>      children; // ParagraphBlock | ListBlock
  final List<SourceNote> sources;
}

// ── Kapitola ───────────────────────────────────────────────────────────────

class Page {
  const Page(this.blocks);

  final List<Block> blocks;

  HeadingBlock? get heading {
    final first = blocks.isEmpty ? null : blocks.first;
    return first is HeadingBlock && first.level == 2 ? first : null;
  }

  String? get anchor => heading?.anchor;
}

class QuizAnswer {
  const QuizAnswer(this.text, {this.correct = false});

  final String text;
  final bool   correct;
}

class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.answers,
    required this.why,
  });

  final String           question;
  final List<QuizAnswer> answers;
  final String           why;
}

class Chapter {
  const Chapter({
    required this.id,
    required this.title,
    required this.part,
    required this.palette,
    required this.hero,
    required this.lore,
    required this.quiz,
    required this.pages,
    this.status = ChapterStatus.live,
    this.audio,
  });

  final String             id;
  final String             title;
  final int                part;    // 1–4, viz BookPart
  final String             palette;
  final String             hero;
  final List<String>       lore;    // id záznamů registru (domain/lore.dart)
  final List<QuizQuestion> quiz;
  final List<Page>         pages;
  final ChapterStatus      status;
  final String?            audio;   // narace, fáze 2 (ADR 0005)

  Iterable<Block> get allBlocks sync* {
    for (final p in pages) {
      for (final b in p.blocks) {
        yield b;
        if (b is BoxBlock) yield* b.children;
      }
    }
  }

  Set<String> get anchors => {
        for (final b in allBlocks)
          if (b is HeadingBlock && b.anchor != null) b.anchor!,
      };
}

/// Heslo slovníčku (`glossary.md`: `## Název {#id}` + definice).
class GlossaryTerm {
  const GlossaryTerm({
    required this.id,
    required this.name,
    required this.definition,
    this.sources = const [],
  });

  final String           id;
  final String           name;
  final List<Inline>     definition;
  final List<SourceNote> sources;
}
