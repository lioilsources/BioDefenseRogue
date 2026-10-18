// Matice pokrytí registru pojmů v knize (06-sync S4) a render kapitol pro
// garanta. Čistý Dart nad registrem a modelem knihy; spouští tool/lore_report.dart.

import '../../domain/lore.dart';
import '../../domain/lore_text.dart';
import '../../game/systems/lore_encounters.dart';
import '../model/book_model.dart';
import '../parser/chapter_parser.dart' show parseSourceNote;

const _ok = '✓', _no = '✗', _na = '—';

/// Markdown: tabulka pojem × kapitola × kotva × honesty box × obrázek ×
/// událost × zdroj, souhrn pokrytí live záznamů, seznam lie: large
/// a plánované pojmy.
String loreReport(
  List<Chapter> chapters, {
  LoreRegistry? registry,
  Set<String>? imageFiles,
}) {
  final reg  = registry ?? lore;
  final byId = {for (final c in chapters) c.id: c};
  final out  = StringBuffer()
    ..writeln('# Pokrytí registru pojmů v knize')
    ..writeln()
    ..writeln('| pojem | stav | lež | kapitola | v lore: | kotva | box doopravdy '
        '| obrázek | setkání | zdroj |')
    ..writeln('|---|---|---|---|---|---|---|---|---|---|');

  var live = 0, liveOk = 0;
  for (final e in reg.entries) {
    final c       = e.chapter == null ? null : byId[e.chapter];
    final listed  = c != null && c.lore.contains(e.id);
    final anchor  = e.anchor == null
        ? _na
        : (c != null && c.anchors.contains(e.anchor) ? _ok : _no);
    final honesty = e.realityCz == null
        ? _na
        : (c != null && c.allBlocks.any(
                (b) => b is BoxBlock && b.kind == BoxKind.doopravdy)
            ? _ok
            : _no);
    final image = c == null || imageFiles == null
        ? _na
        : (imageFiles.contains(c.hero) ? _ok : _no);
    final source = switch (e.sourceRef) {
      null                                      => _na,
      final s when parseSourceNote(s)?.verified ?? false => _ok,
      _                                         => 'TODO-FACT',
    };
    if (e.status == LoreStatus.live) {
      live++;
      if (listed && anchor != _no && honesty != _no) liveOk++;
    }
    out.writeln('| `${e.id}` | ${e.status.name} | ${e.lie.name} '
        '| ${e.chapter ?? _na}${c == null && e.chapter != null ? ' (chybí)' : ''} '
        '| ${c == null ? _na : (listed ? _ok : _no)} | $anchor | $honesty '
        '| $image | ${hasEncounter(e) ? _ok : _na} | $source |');
  }

  final pct = live == 0 ? 100 : (liveOk * 100 / live).round();
  out
    ..writeln()
    ..writeln('**Live pojmy pokryté knihou: $liveOk / $live ($pct %)** '
        '(kapitola je uvádí v `lore:`, kotva existuje, box doopravdy tam, '
        'kde hra lže).')
    ..writeln()
    ..writeln('## Velké lži (lie: large) k rozhodnutí vlastníka')
    ..writeln();
  for (final e in reg.where(lie: LieSize.large)) {
    out.writeln('- `${e.id}` (${e.nameCz}): ${e.realityCz}');
  }
  out
    ..writeln()
    ..writeln('## Mechanika hry → kapitola → stav (plánované pojmy)')
    ..writeln();
  for (final e in reg.entries.where((e) => e.status != LoreStatus.live)) {
    out.writeln('- `${e.id}` → ${e.chapter ?? 'bez kapitoly'} → ${e.status.name}');
  }
  return out.toString();
}

/// Kapitola pro garanta: dosazená čísla a názvy, zdroje viditelně.
String renderChapterForGarant(String source) {
  var text = renderLore(source);
  text = text.replaceAllMapped(RegExp(r'<!--(.*?)-->', dotAll: true), (m) {
    final note = parseSourceNote(m.group(1)!);
    if (note == null) return '';
    return note.verified
        ? '*[zdroj: ${note.text}]*'
        : '> **OVĚŘIT:** ${note.text}';
  });
  return text;
}
