// Čistý Dart — bez Flutter a Flame importů.
// Markdown kapitoly (podmnožina, 03-redakcni-standard.md §3) → blokový model.
// Parser nesoudí obsah (limity, hesla, zdroje); to dělá book/validation.
// Hlásí jen to, co nejde převést: zakázané bloky, rozbitý front matter.

import 'package:markdown/markdown.dart' as md;
import 'package:yaml/yaml.dart';

import '../model/book_model.dart';

class ChapterParseResult {
  const ChapterParseResult(this.chapter, this.errors);

  /// null, když front matter nejde přečíst vůbec.
  final Chapter?     chapter;
  final List<String> errors;
}

class GlossaryParseResult {
  const GlossaryParseResult(this.terms, this.errors);

  final List<GlossaryTerm> terms;
  final List<String>       errors;
}

ChapterParseResult parseChapter(String source) {
  final errors = <String>[];
  final split  = _splitFrontMatter(source);
  if (split == null) {
    return const ChapterParseResult(null, ['chybí front matter (--- … ---)']);
  }

  final YamlMap fm;
  try {
    final y = loadYaml(split.$1);
    if (y is! YamlMap) {
      return const ChapterParseResult(null, ['front matter není YAML mapa']);
    }
    fm = y;
  } on YamlException catch (e) {
    return ChapterParseResult(null, ['front matter: ${e.message}']);
  }

  String str(String key, {bool required = true}) {
    final v = fm[key];
    if (v == null) {
      if (required) errors.add('front matter: chybí „$key"');
      return '';
    }
    return v.toString();
  }

  final part = fm['part'];
  if (part is! int) errors.add('front matter: „part" musí být číslo 1–4');

  final status = switch (fm['status']) {
    null || 'live' => ChapterStatus.live,
    'planned'      => ChapterStatus.planned,
    final other    => () {
        errors.add('front matter: neznámý status „$other"');
        return ChapterStatus.live;
      }(),
  };

  final lore = <String>[];
  final rawLore = fm['lore'];
  if (rawLore == null) {
    errors.add('front matter: chybí „lore" (může být prázdný seznam [])');
  } else if (rawLore is YamlList) {
    lore.addAll(rawLore.map((e) => e.toString()));
  } else {
    errors.add('front matter: „lore" musí být seznam');
  }

  final body = _BodyParser(errors)..parse(split.$2);

  return ChapterParseResult(
    Chapter(
      id:      str('id'),
      title:   str('title'),
      part:    part is int ? part : 0,
      palette: str('palette'),
      hero:    str('hero'),
      audio:   fm['audio']?.toString(),
      status:  status,
      lore:    lore,
      quiz:    _parseQuiz(fm['quiz'], errors),
      pages:   body.pages,
    ),
    errors,
  );
}

GlossaryParseResult parseGlossary(String source) {
  final errors = <String>[];
  final body   = _BodyParser(errors, glossary: true)..parse(source);
  final terms  = <GlossaryTerm>[];

  for (final page in body.pages) {
    final h = page.heading;
    if (h == null) continue;
    if (h.anchor == null) {
      errors.add('heslo „${h.text}": chybí {#id}');
      continue;
    }
    final paras = page.blocks.whereType<ParagraphBlock>().toList();
    terms.add(GlossaryTerm(
      id:         h.anchor!,
      name:       h.text,
      definition: [
        for (var i = 0; i < paras.length; i++) ...[
          if (i > 0) const TextRun(' '),
          ...paras[i].inlines,
        ],
      ],
      sources: [for (final p in paras) ...p.sources],
    ));
  }
  return GlossaryParseResult(terms, errors);
}

/// Id hesla z textu: malá písmena, bez diakritiky, mezery → '-'.
String termSlug(String text) {
  final buf = StringBuffer();
  for (final ch in text.toLowerCase().trim().split('')) {
    buf.write(_fold[ch] ?? ch);
  }
  return buf
      .toString()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}

const _fold = {
  'á': 'a', 'č': 'c', 'ď': 'd', 'é': 'e', 'ě': 'e', 'í': 'i', 'ň': 'n',
  'ó': 'o', 'ř': 'r', 'š': 's', 'ť': 't', 'ú': 'u', 'ů': 'u', 'ý': 'y',
  'ž': 'z',
};

// ── Front matter ─────────────────────────────────────────────────────────

(String, String)? _splitFrontMatter(String source) {
  final lines = source.replaceAll('\r\n', '\n').split('\n');
  if (lines.isEmpty || lines.first.trim() != '---') return null;
  for (var i = 1; i < lines.length; i++) {
    if (lines[i].trim() == '---') {
      return (
        lines.sublist(1, i).join('\n'),
        lines.sublist(i + 1).join('\n'),
      );
    }
  }
  return null;
}

List<QuizQuestion> _parseQuiz(Object? raw, List<String> errors) {
  if (raw == null) {
    errors.add('front matter: chybí „quiz"');
    return const [];
  }
  if (raw is! YamlList) {
    errors.add('front matter: „quiz" musí být seznam otázek');
    return const [];
  }
  final out = <QuizQuestion>[];
  for (final (i, q) in raw.indexed) {
    final at = 'kvíz, otázka ${i + 1}';
    if (q is! YamlMap) {
      errors.add('$at: není mapa (question, answers, why)');
      continue;
    }
    final answers = <QuizAnswer>[];
    final rawAnswers = q['answers'];
    if (rawAnswers is YamlList) {
      for (final a in rawAnswers) {
        if (a is YamlMap && a['text'] != null) {
          answers.add(QuizAnswer(a['text'].toString(),
              correct: a['correct'] == true));
        } else {
          errors.add('$at: odpověď bez „text"');
        }
      }
    } else {
      errors.add('$at: chybí seznam „answers"');
    }
    out.add(QuizQuestion(
      question: q['question']?.toString() ?? '',
      answers:  answers,
      why:      q['why']?.toString() ?? '',
    ));
  }
  return out;
}

// ── Tělo ─────────────────────────────────────────────────────────────────

final _anchorRe  = RegExp(r'\s*\{#([^}]*)\}\s*$');
final _commentRe = RegExp(r'<!--(.*?)-->', dotAll: true);
final _boxTagRe  = RegExp(r'^\[!([a-z]+)\]\s*');

class _BodyParser {
  _BodyParser(this.errors, {this.glossary = false});

  final List<String> errors;

  /// Slovníček: stránky se nedělí `---`, každé `##` je nové heslo.
  final bool glossary;

  final pages = <Page>[];
  var _current = <Block>[];

  void parse(String body) {
    final doc = md.Document(
      extensionSet: md.ExtensionSet.gitHubFlavored, // ať tabulky a odkazy jdou poznat a odmítnout
      encodeHtml:   false,
    );
    for (final node in doc.parseLines(body.split('\n'))) {
      _top(node);
    }
    _flush();
  }

  void _flush() {
    if (_current.isNotEmpty) pages.add(Page(List.unmodifiable(_current)));
    _current = <Block>[];
  }

  void _top(md.Node node) {
    if (node is md.Text) {
      _html(node.text);
      return;
    }
    if (node is! md.Element) return;

    switch (node.tag) {
      case 'hr':
        _flush();
      case 'h2':
        if (glossary) _flush();
        if (_current.any((b) => b is HeadingBlock && b.level == 2)) {
          errors.add('stránka má dva nadpisy ## („${node.textContent}"); '
              'chybí oddělovač ---');
        }
        _current.add(_heading(node, 2));
      case 'h3':
        _current.add(_heading(node, 3));
      case 'p':
        _current.add(_paragraphOrImage(node));
      case 'blockquote':
        final box = _box(node);
        if (box != null) _current.add(box);
      case 'ul':
        errors.add('odrážky mimo box [!prakticky]');
      default:
        errors.add('nepovolený blok <${node.tag}> („${_short(node)}")');
    }
  }

  HeadingBlock _heading(md.Element node, int level) {
    final raw = node.textContent.trim();
    final m   = _anchorRe.firstMatch(raw);
    return HeadingBlock(
      level:  level,
      text:   raw.replaceFirst(_anchorRe, ''),
      anchor: m?.group(1),
    );
  }

  Block _paragraphOrImage(md.Element p) {
    final kids = p.children ?? const <md.Node>[];
    final imgs = kids.whereType<md.Element>().where((e) => e.tag == 'img');
    if (imgs.isNotEmpty) {
      final onlyImage = kids.every((k) =>
          (k is md.Element && k.tag == 'img') ||
          (k is md.Text && k.text.trim().isEmpty));
      if (!onlyImage || imgs.length > 1) {
        errors.add('obrázek musí stát samostatně v odstavci');
      }
      final img = imgs.first;
      return ImageBlock(
        file: img.attributes['src'] ?? '',
        alt:  img.attributes['alt'] ?? '',
      );
    }
    return ParagraphBlock(_inlines(kids));
  }

  BoxBlock? _box(md.Element quote) {
    final kids = (quote.children ?? const <md.Node>[]).toList();
    final first = kids.isEmpty ? null : kids.first;
    final firstText =
        first is md.Element && first.tag == 'p' ? first.textContent : '';
    final m = _boxTagRe.firstMatch(firstText);
    if (m == null) {
      errors.add('citace bez tagu boxu (> [!doopravdy] …): '
          '„${_short(quote)}"');
      return null;
    }
    final kind = BoxKind.values.where((k) => k.name == m.group(1)).firstOrNull;
    if (kind == null) {
      errors.add('neznámý box [!${m.group(1)}]');
      return null;
    }

    final children = <Block>[];
    // První odstavec: odříznout tag, zbytek je text boxu.
    final head = _inlines((first as md.Element).children ?? const []);
    final rest = _dropPrefix(head, m.group(0)!);
    if (rest.isNotEmpty) children.add(ParagraphBlock(rest));

    for (final k in kids.skip(1)) {
      if (k is md.Element && k.tag == 'p') {
        children.add(ParagraphBlock(_inlines(k.children ?? const [])));
      } else if (k is md.Element && k.tag == 'ul') {
        if (kind != BoxKind.prakticky) {
          errors.add('odrážky jsou povolené jen v boxu [!prakticky]');
        }
        children.add(ListBlock([
          for (final li in k.children ?? const <md.Node>[])
            if (li is md.Element) _inlines(li.children ?? const []),
        ]));
      } else if (k is md.Text) {
        // komentář uvnitř citace se nepočítá jako zdroj boxu
        errors.add('komentář uvnitř boxu: dej ho za box');
      } else if (k is md.Element) {
        errors.add('nepovolený blok <${k.tag}> v boxu');
      }
    }
    return BoxBlock(kind, children);
  }

  List<Inline> _dropPrefix(List<Inline> inlines, String prefix) {
    if (inlines.isEmpty) return inlines;
    final first = inlines.first;
    if (first is! TextRun || !first.text.startsWith(prefix.trimRight())) {
      return inlines;
    }
    final rest = first.text.substring(prefix.trimRight().length).trimLeft();
    return [if (rest.isNotEmpty) TextRun(rest), ...inlines.skip(1)];
  }

  List<Inline> _inlines(List<md.Node> nodes) {
    final out = <Inline>[];
    for (final n in nodes) {
      if (n is md.Text) {
        final t = n.text;
        if (t.contains(RegExp(r'<[a-zA-Z/!]'))) {
          errors.add('HTML v textu: „${_clip(t)}"');
        }
        out.add(TextRun(_ws(t)));
      } else if (n is md.Element) {
        switch (n.tag) {
          case 'strong':
            final raw  = n.textContent;
            final pipe = raw.indexOf('|');
            final text = pipe < 0 ? raw : raw.substring(0, pipe);
            final id   = pipe < 0 ? termSlug(raw) : raw.substring(pipe + 1);
            out.add(TermRun(_ws(text), id.trim()));
          case 'em':
            out.add(EmphasisRun(_ws(n.textContent)));
          case 'br':
            out.add(const TextRun(' '));
          default:
            errors.add('nepovolený inline prvek <${n.tag}> '
                '(„${_clip(n.textContent)}")');
            out.add(TextRun(_ws(n.textContent)));
        }
      }
    }
    return out;
  }

  /// Top-level HTML: jen komentáře. Zdroj patří k poslednímu bloku stránky.
  void _html(String raw) {
    final rest = raw.replaceAll(_commentRe, '').trim();
    if (rest.isNotEmpty) errors.add('HTML mimo komentář: „${_clip(rest)}"');

    for (final m in _commentRe.allMatches(raw)) {
      final note = parseSourceNote(m.group(1)!);
      if (note == null) continue; // obyčejný komentář autora
      final i = _current.lastIndexWhere((b) =>
          b is ParagraphBlock || b is ListBlock || b is BoxBlock);
      if (i < 0) {
        errors.add('zdroj bez odstavce: „${_clip(note.text)}"');
        continue;
      }
      _current[i] = switch (_current[i]) {
        ParagraphBlock(:final inlines, :final sources) =>
          ParagraphBlock(inlines, sources: [...sources, note]),
        ListBlock(:final items, :final sources) =>
          ListBlock(items, sources: [...sources, note]),
        BoxBlock(:final kind, :final children, :final sources) =>
          BoxBlock(kind, children, sources: [...sources, note]),
        final other => other,
      };
    }
  }

  static String _ws(String s) => s.replaceAll(RegExp(r'\s+'), ' ');
  static String _clip(String s) {
    final t = _ws(s).trim();
    return t.length > 40 ? '${t.substring(0, 40)}…' : t;
  }

  static String _short(md.Node n) => _clip(n.textContent);
}

/// `src: KLÍČ místo` / `TODO-FACT: KLÍČ – co ověřit` → SourceNote.
/// Klíče = VERZÁLKOVÁ slova na začátku každé části oddělené ';'
/// („JANEWAY / KLUGER1975 – …", „PEDIATRIE – …; HOREJSI – …").
/// Jiný komentář → null.
SourceNote? parseSourceNote(String inner) {
  final m = RegExp(r'^\s*(src|TODO-FACT):\s*(.*?)\s*$', dotAll: true)
      .firstMatch(inner);
  if (m == null) return null;
  final text = m.group(2)!;
  final keys = <String>[];
  for (final part in text.split(';')) {
    for (final tok in part.trim().split(RegExp(r'[\s,/]+'))) {
      if (!RegExp(r'^[A-Z][A-Z0-9]+$').hasMatch(tok)) break;
      keys.add(tok);
    }
  }
  return SourceNote(verified: m.group(1) == 'src', keys: keys, text: text);
}
