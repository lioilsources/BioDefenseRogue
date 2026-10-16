// BookSync: obousměrná kontrola kniha ↔ registr pojmů ↔ balance
// (06-sync 02-plan S2, ADR 0003). Čistý Dart nad modelem z K1.
//
// Pravidla:
// - každé id v `lore:` kapitoly existuje a patří do této kapitoly,
// - každý live záznam má kapitolu, která ho uvádí v `lore:`, a kotvu, která
//   v ní existuje,
// - záznam s realityCz → kapitola má box [!doopravdy],
// - všechny placeholdery v kapitole jdou vyrenderovat,
// - název karty upgradu se v kapitole nepíše natvrdo, jen {{lore.<id>}}
//   (jen názvy se závorkou, např. „Pyrogen (IL-6)"; jednoslovné názvy jako
//   „Histamin" jsou zároveň běžná slova textu),
// - planned kapitola (pahýl fáze 2) smí uvádět jen planned záznamy,
// - release: žádná chybějící live kapitola (planned pahýly čtečka skrývá).
// Kapitola, která ještě neexistuje (K3), se mimo release jen přeskočí.

import '../../config/balance_map.g.dart';
import '../../domain/lore.dart';
import '../../domain/lore_text.dart';
import '../model/book_model.dart';
import '../parser/chapter_parser.dart' show parseSourceNote;
import 'book_validator.dart';

List<BookIssue> validateBookSync(
  List<Chapter> chapters, {
  LoreRegistry?    registry,
  Map<String, num> lookup        = balanceLookup,
  bool             release       = false,
  Iterable<String> knownChapters = BookChapter.all,
}) {
  final reg    = registry ?? lore;
  final issues = <BookIssue>[];
  void err(String where, String m) =>
      issues.add(BookIssue(IssueLevel.error, where, m));

  final byId = {for (final c in chapters) c.id: c};

  // ── Kapitola → registr ──
  for (final c in chapters) {
    final hasHonesty =
        c.allBlocks.any((b) => b is BoxBlock && b.kind == BoxKind.doopravdy);

    for (final id in c.lore) {
      final LoreEntry e;
      try {
        e = reg.byId(id);
      } on ArgumentError {
        err(c.id, 'lore: „$id" není v registru');
        continue;
      }
      if (e.chapter != c.id) {
        err(c.id, 'lore: „$id" patří do kapitoly „${e.chapter}"');
      }
      if (c.status == ChapterStatus.planned && e.status == LoreStatus.live) {
        err(c.id, 'lore: live záznam „$id" v planned kapitole');
      }
      if (e.realityCz != null && !hasHonesty) {
        err(c.id, 'lore: „$id" má realityCz, kapitole chybí box [!doopravdy]');
      }
    }

    for (final text in _texts(c)) {
      for (final m in checkLoreText(text, lookup: lookup, registry: reg)) {
        err(c.id, 'placeholder: $m');
      }
      final plain = text.replaceAll(loreTextPlaceholder, '');
      for (final u in reg.where(kind: LoreKind.upgrade)) {
        if (u.nameCz.contains('(') && plain.contains(u.nameCz)) {
          err(c.id, 'název „${u.nameCz}" natvrdo, použij {{lore.${u.id}}}');
        }
      }
    }
  }

  // ── Registr → kapitola ──
  for (final e in reg.entries) {
    if (e.status != LoreStatus.live || e.chapter == null) continue;
    final c = byId[e.chapter];
    if (c == null) {
      if (release) err(e.id, 'kapitola „${e.chapter}" neexistuje');
      continue;
    }
    if (!c.lore.contains(e.id)) {
      err(e.id, 'kapitola ${c.id} ho neuvádí v lore:');
    }
    if (e.anchor != null && !c.anchors.contains(e.anchor)) {
      err(e.id, 'kotva #${e.anchor} v kapitole ${c.id} neexistuje');
    }
  }

  if (release) {
    for (final id in knownChapters) {
      if (!byId.containsKey(id)) err(id, 'kapitola chybí');
    }
  }
  return issues;
}

/// sourceRef registru musí mít klíč ze `sources.md` (06-sync S4).
List<String> loreSourceErrors(Iterable<LoreEntry> entries, Set<String> keys) {
  final errors = <String>[];
  for (final e in entries) {
    final ref = e.sourceRef;
    if (ref == null) continue;
    final note = parseSourceNote(ref);
    if (note == null || note.keys.isEmpty) {
      errors.add('${e.id}: sourceRef bez klíče zdroje „$ref"');
      continue;
    }
    for (final k in note.keys) {
      if (!keys.contains(k)) errors.add('${e.id}: neznámý klíč zdroje „$k"');
    }
  }
  return errors;
}

/// Všechny texty kapitoly, které čtenář uvidí (bez komentářů se zdroji).
Iterable<String> _texts(Chapter c) sync* {
  yield c.title;
  for (final b in c.allBlocks) {
    switch (b) {
      case HeadingBlock(:final text):
        yield text;
      case ParagraphBlock():
        yield b.plainText;
      case ListBlock(:final items):
        yield* items.map(inlineText);
      case ImageBlock(:final alt):
        yield alt;
      case BoxBlock():
        break; // děti boxu projde allBlocks
    }
  }
  for (final q in c.quiz) {
    yield q.question;
    yield q.why;
    yield* q.answers.map((a) => a.text);
  }
}
