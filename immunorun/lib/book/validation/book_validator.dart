// Validace obsahu knihy nad blokovým modelem (05-kniha 02-plan K1).
// Každé pravidlo odpovídá bodu označenému [test] v
// Prompts/05-kniha/03-redakcni-standard.md a má negativní fixturu
// v test/book/book_validator_test.dart.

import '../../config/balance.dart';
import '../../domain/lore.dart';
import '../model/book_model.dart';

enum IssueLevel { error, warning }

class BookIssue {
  const BookIssue(this.level, this.where, this.message);

  final IssueLevel level;
  final String     where;
  final String     message;

  bool get isError => level == IssueLevel.error;

  @override
  String toString() => '$where: $message';
}

/// Redakční limity; výchozí hodnoty z `Balance` (sekce Kniha).
class BookLimits {
  const BookLimits({
    this.wordsPerPageMax      = Balance.bookWordsPerPageMax,
    this.chapterWordsMin      = Balance.bookChapterWordsMin,
    this.chapterWordsMax      = Balance.bookChapterWordsMax,
    this.boxWordsMax          = Balance.bookBoxWordsMax,
    this.pagesMin             = Balance.bookPagesMin,
    this.pagesMax             = Balance.bookPagesMax,
    this.sentenceWordsMax     = Balance.bookSentenceWordsMax,
    this.paragraphsPerPageMax = Balance.bookParagraphsPerPageMax,
    this.titleCharsMax        = Balance.bookTitleCharsMax,
    this.quizQuestions        = Balance.bookQuizQuestions,
    this.quizAnswers          = Balance.bookQuizAnswers,
    this.quizWhyWordsMax      = Balance.bookQuizWhyWordsMax,
    this.zvedaveMax           = Balance.bookZvedaveMax,
  });

  final int wordsPerPageMax;
  final int chapterWordsMin;
  final int chapterWordsMax;
  final int boxWordsMax;
  final int pagesMin;
  final int pagesMax;
  final int sentenceWordsMax;
  final int paragraphsPerPageMax;
  final int titleCharsMax;
  final int quizQuestions;
  final int quizAnswers;
  final int quizWhyWordsMax;
  final int zvedaveMax;
}

class BookContext {
  const BookContext({
    required this.glossaryIds,
    required this.sourceKeys,
    this.imageFiles,
    this.knownChapters = BookChapter.known,
    this.release       = false,
    this.limits        = const BookLimits(),
  });

  final Set<String>      glossaryIds;
  final Set<String>      sourceKeys;
  final Iterable<String> knownChapters;

  /// Soubory v assets/book/images/. null = existence obrázků se nekontroluje
  /// (do K4, OQ-19); v release je kontrola povinná vždy.
  final Set<String>? imageFiles;

  /// `--dart-define=BOOK_RELEASE=true`: žádný TODO-FACT, obrázky musí existovat.
  final bool release;

  final BookLimits limits;
}

/// Kapitoly, které vysvětlují mechanismus a musí mít schéma (01-scope F7).
const Set<String> chaptersRequiringSchema = {
  BookChapter.fagocytoza,
  BookChapter.horecka,
  BookChapter.cytokiny,
  BookChapter.protilatky,
  BookChapter.uzlina,
  BookChapter.pamet,
};

final _kebab = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');

int countWords(String s) {
  final t = s.trim();
  return t.isEmpty ? 0 : t.split(RegExp(r'\s+')).length;
}

String inlineText(List<Inline> inlines) => inlines.map((i) => i.text).join();

/// Text boxu (odstavce i odrážky).
String boxText(BoxBlock box) => [
      for (final c in box.children)
        switch (c) {
          ParagraphBlock() => c.plainText,
          ListBlock()      => c.items.map(inlineText).join(' '),
          _                => '',
        },
    ].join(' ');

/// Hlavní text stránky: odstavce a ### mimo boxy.
String mainText(BookPage page) => [
      for (final b in page.blocks)
        if (b is ParagraphBlock)
          b.plainText
        else if (b is HeadingBlock && b.level == 3)
          b.text,
    ].join(' ');

List<BookIssue> validateChapter(
  Chapter c,
  BookContext ctx, {
  String? fileName,
}) {
  final issues = <BookIssue>[];
  final lim    = ctx.limits;
  final id     = c.id.isEmpty ? (fileName ?? '?') : c.id;
  void err(String m, [String? at]) =>
      issues.add(BookIssue(IssueLevel.error, at ?? id, m));
  void warn(String m, [String? at]) =>
      issues.add(BookIssue(IssueLevel.warning, at ?? id, m));

  // ── Front matter ──
  if (fileName != null && fileName != '${c.id}.md') {
    err('id „${c.id}" neodpovídá souboru $fileName');
  }
  if (!ctx.knownChapters.contains(c.id)) {
    err('id „${c.id}" není v BookChapter.all');
  }
  if (c.title.trim().isEmpty) err('prázdný title');
  if (c.title.length > lim.titleCharsMax) {
    err('title má ${c.title.length} znaků (max ${lim.titleCharsMax})');
  }
  final part = BookPart.byNumber(c.part);
  if (part == null) {
    err('part ${c.part} není 1–4');
  } else if (c.palette != part.palette) {
    err('palette „${c.palette}" neodpovídá části ${c.part} '
        '(má být „${part.palette}")');
  }
  if (c.hero != '${c.id}-hero.webp') {
    err('hero „${c.hero}" neodpovídá jménu ${c.id}-hero.webp');
  }
  // ── Kvíz a obálka (pahýl planned kapitoly nemá kvíz ani obrázek, čtečka ho skrývá) ──
  final live = c.status == ChapterStatus.live;
  if (live) _checkImageExists(c.hero, ctx, err);
  if (live && c.quiz.length != lim.quizQuestions) {
    err('kvíz má ${c.quiz.length} otázek (má mít ${lim.quizQuestions})');
  }
  for (final (i, q) in c.quiz.indexed) {
    final at = '$id/kvíz ${i + 1}';
    if (q.question.trim().isEmpty) err('prázdná otázka', at);
    if (q.answers.length != lim.quizAnswers) {
      err('${q.answers.length} odpovědi (má mít ${lim.quizAnswers})', at);
    }
    final correct = q.answers.where((a) => a.correct).length;
    if (correct != 1) err('$correct správných odpovědí (má být právě 1)', at);
    if (q.why.trim().isEmpty) err('chybí „why"', at);
    final whyWords = countWords(q.why);
    if (whyWords > lim.quizWhyWordsMax) {
      err('why má $whyWords slov (max ${lim.quizWhyWordsMax})', at);
    }
  }

  // ── Stránky ──
  if (live && (c.pages.length < lim.pagesMin || c.pages.length > lim.pagesMax)) {
    err('${c.pages.length} stránek (má být ${lim.pagesMin}–${lim.pagesMax})');
  }

  final anchors     = <String>{};
  final terms       = <String, int>{};
  final boxCount    = {for (final k in BoxKind.values) k: 0};
  var   chapterWords = 0;
  var   images       = 0;

  for (final (pi, page) in c.pages.indexed) {
    final at = '$id/str. ${pi + 1}';
    final h  = page.heading;
    if (h == null) {
      err('stránka nezačíná nadpisem ##', at);
    } else if (h.anchor == null) {
      err('nadpis „${h.text}" nemá kotvu {#…}', at);
    }

    var h3 = 0, paragraphs = 0, boxes = 0;
    for (final b in page.blocks) {
      switch (b) {
        case HeadingBlock(:final level, :final anchor, :final text):
          if (level == 3) h3++;
          if (anchor != null) {
            if (!_kebab.hasMatch(anchor)) {
              err('kotva „$anchor" není kebab-case bez diakritiky', at);
            }
            if (!anchors.add(anchor)) err('duplicitní kotva „$anchor"', at);
          }
          if (level == 3 && anchor != null) {
            err('### „$text" nemá mít kotvu', at);
          }
        case ParagraphBlock():
          paragraphs++;
          _checkSources(b.sources, ctx, at, err);
        case ListBlock():
          err('odrážky mimo box [!prakticky]', at);
        case ImageBlock(:final file, :final alt):
          images++;
          if (!RegExp('^${RegExp.escape(c.id)}-schema-[0-9]+\\.webp\$')
              .hasMatch(file)) {
            err('obrázek „$file" neodpovídá jménu ${c.id}-schema-<n>.webp', at);
          }
          if (alt.trim().isEmpty) err('obrázek „$file" bez popisku', at);
          _checkImageExists(file, ctx, (m) => err(m, at));
        case BoxBlock(:final kind, :final children, :final sources):
          boxes++;
          boxCount[kind] = boxCount[kind]! + 1;
          final w = countWords(boxText(b));
          if (w > lim.boxWordsMax) {
            err('box [!${kind.name}] má $w slov (max ${lim.boxWordsMax})', at);
          }
          if (children.isEmpty) err('prázdný box [!${kind.name}]', at);
          for (final ch in children) {
            if (ch is ListBlock && kind != BoxKind.prakticky) {
              err('odrážky v boxu [!${kind.name}]', at);
            }
            if (ch is ListBlock) _checkSources(ch.sources, ctx, at, err);
          }
          _checkSources(sources, ctx, at, err);
      }
    }

    if (h3 > 1) err('$h3 mezititulky ### (max 1)', at);
    if (boxes > 1) err('$boxes boxy na stránce (max 1)', at);
    if (live && (paragraphs < 1 || paragraphs > lim.paragraphsPerPageMax)) {
      err('$paragraphs odstavců (má být 1–${lim.paragraphsPerPageMax})', at);
    }

    final text  = mainText(page);
    final words = countWords(text);
    chapterWords += words;
    if (words > lim.wordsPerPageMax) {
      err('$words slov na stránce (max ${lim.wordsPerPageMax})', at);
    }
    for (final s in text.split(RegExp(r'(?<=[.!?…])\s+'))) {
      final sw = countWords(s);
      if (sw > lim.sentenceWordsMax) {
        warn('věta má $sw slov (max ${lim.sentenceWordsMax}): '
            '„${s.length > 50 ? '${s.substring(0, 50)}…' : s}"', at);
      }
    }
  }

  // Hesla: v celé kapitole včetně boxů.
  for (final b in c.allBlocks) {
    final inlines = switch (b) {
      ParagraphBlock(:final inlines) => inlines,
      ListBlock(:final items)        => [for (final i in items) ...i],
      _                              => const <Inline>[],
    };
    for (final t in inlines.whereType<TermRun>()) {
      terms[t.termId] = (terms[t.termId] ?? 0) + 1;
      if (!ctx.glossaryIds.contains(t.termId)) {
        err('heslo „${t.termId}" („${t.text}") chybí v glossary.md');
      }
    }
  }
  terms.forEach((t, n) {
    if (n > 1) err('heslo „$t" je tučně $n× (jen první výskyt)');
  });

  // ── Obsahová úplnost (jen live kapitola) ──
  if (live) {
    if (chapterWords < lim.chapterWordsMin ||
        chapterWords > lim.chapterWordsMax) {
      err('$chapterWords slov hlavního textu '
          '(má být ${lim.chapterWordsMin}–${lim.chapterWordsMax})');
    }
    if (boxCount[BoxKind.doopravdy]! < 1) {
      err('chybí box [!doopravdy] (ADR 0003)');
    }
    if (boxCount[BoxKind.vedel] != 1) {
      err('${boxCount[BoxKind.vedel]} boxů [!vedel] (má být právě 1)');
    }
    if (chaptersRequiringSchema.contains(c.id) && images == 0) {
      err('kapitola vysvětluje mechanismus a nemá schéma (F7)');
    }
  }
  if (boxCount[BoxKind.zvedave]! > lim.zvedaveMax) {
    err('${boxCount[BoxKind.zvedave]} boxů [!zvedave] (max ${lim.zvedaveMax})');
  }
  if (boxCount[BoxKind.prakticky]! > 1) {
    err('${boxCount[BoxKind.prakticky]} boxů [!prakticky] (max 1)');
  }

  return issues;
}

List<BookIssue> validateGlossary(List<GlossaryTerm> terms, BookContext ctx) {
  final issues = <BookIssue>[];
  final ids    = <String>{};
  for (final t in terms) {
    final at = 'glossary/${t.id}';
    void err(String m) => issues.add(BookIssue(IssueLevel.error, at, m));
    if (!ids.add(t.id)) err('duplicitní heslo');
    if (!_kebab.hasMatch(t.id)) err('id není kebab-case bez diakritiky');
    if (countWords(inlineText(t.definition)) == 0) err('heslo bez definice');
    _checkSources(t.sources, ctx, at, (m, [_]) => err(m));
  }
  return issues;
}

/// Klíče zdrojů ze `Prompts/05-kniha/sources.md` (řádky tabulky „| `KLÍČ` |").
Set<String> parseSourceKeys(String sourcesMd) => {
      for (final m in RegExp(r'^\|\s*`([A-Z][A-Z0-9]+)`\s*\|', multiLine: true)
          .allMatches(sourcesMd))
        m.group(1)!,
    };

void _checkSources(
  List<SourceNote> notes,
  BookContext ctx,
  String at,
  void Function(String, [String?]) err,
) {
  for (final n in notes) {
    if (n.keys.isEmpty) {
      err('zdroj bez klíče: „${n.text}"', at);
    }
    for (final k in n.keys) {
      if (!ctx.sourceKeys.contains(k)) err('neznámý klíč zdroje „$k"', at);
    }
    if (ctx.release && !n.verified) {
      err('TODO-FACT v release: „${n.text}"', at);
    }
  }
}

void _checkImageExists(
  String file,
  BookContext ctx,
  void Function(String) err,
) {
  final files = ctx.imageFiles;
  if (files == null && !ctx.release) return;
  if (!(files ?? const {}).contains(file)) {
    err('obrázek „$file" neexistuje v assets/book/images/');
  }
}
