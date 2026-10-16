import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../book/model/book_model.dart';
import '../../book/parser/book_loader.dart';
import '../../config/balance.dart';
import '../../domain/lore.dart';
import '../../game/immuno_game.dart';
import '../meta_providers.dart';
import 'book_providers.dart';
import 'chapter_list.dart';
import 'chapter_reader.dart';

/// Overlay 'book': propojí hru (otevření, zavření, meta) s BookScreen.
class BookOverlay extends ConsumerWidget {
  const BookOverlay({super.key, required this.game});

  final ImmunoGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book     = ref.watch(bookProvider);
    final fontStep = ref.watch(metaProvider.select((m) => m.bookFontStep));
    final meta     = ref.watch(metaProvider);
    return book.when(
      data: (b) => BookScreen(
        book:           b,
        initialChapter: game.bookChapterRequest,
        initialAnchor:  game.bookAnchorRequest,
        seenLore:       meta.seenLore,
        lastChapter:    meta.lastChapter,
        onChapterOpened: game.setLastChapter,
        fontStep:       fontStep,
        onFontStep:     game.setBookFontStep,
        onClose:        game.closeBook,
      ),
      loading: () => const _Backdrop(child: SizedBox.expand()),
      error:   (e, _) => _Backdrop(
        child: Center(child: TextButton(
          onPressed: game.closeBook,
          child: const Text('Knihu se nepodařilo načíst. Zavřít'),
        )),
      ),
    );
  }
}

/// Kniha bez vazby na hru (testovatelná): seznam kapitol ↔ čtečka.
class BookScreen extends StatefulWidget {
  const BookScreen({
    super.key,
    required this.book,
    required this.fontStep,
    required this.onFontStep,
    required this.onClose,
    this.initialChapter,
    this.initialAnchor,
    this.seenLore = const {},
    this.lastChapter,
    this.onChapterOpened,
  });

  final Book              book;
  final int               fontStep;
  final ValueChanged<int> onFontStep;
  final VoidCallback      onClose;

  /// Deep-link: otevři rovnou kapitolu; „zpět" pak knihu zavře
  /// (návrat tam, odkud dítě přišlo).
  final String? initialChapter;

  /// Kotva v kapitole: čtečka otevře stránku, na které je.
  final String? initialAnchor;

  /// Pojmy potkané ve hře → razítko na obálce a značka u nadpisu.
  final Set<String> seenLore;
  final String?     lastChapter;
  final ValueChanged<String>? onChapterOpened;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  Chapter? _open;
  bool     _direct = false;

  @override
  void initState() {
    super.initState();
    final id = widget.initialChapter;
    _open   = id == null ? null : widget.book.chapter(id);
    _direct = _open != null;
    if (_open != null) _opened(_open!);
  }

  void _opened(Chapter c) {
    final cb = widget.onChapterOpened;
    if (cb != null) WidgetsBinding.instance.addPostFrameCallback((_) => cb(c.id));
  }

  void _openFromList(Chapter c) {
    setState(() => _open = c);
    _opened(c);
  }

  @override
  Widget build(BuildContext context) {
    final open = _open;
    return _Backdrop(
      child: SafeArea(
        child: open == null
            ? ChapterList(
                chapters: widget.book.chapters,
                onOpen:      _openFromList,
                onClose:     widget.onClose,
                seenLore:    widget.seenLore,
                lastChapter: widget.lastChapter,
              )
            : ChapterReader(
                key:        ValueKey(open.id),
                chapter:    open,
                fontStep:   widget.fontStep,
                seenLore:   widget.seenLore,
                initialPage: _direct && open.id == widget.initialChapter
                    ? pageOfAnchor(open, widget.initialAnchor)
                    : 0,
                onFontStep: widget.onFontStep,
                onBack: _direct
                    ? widget.onClose
                    : () => setState(() => _open = null),
              ),
      ),
    );
  }
}

/// Index stránky s kotvou (0, když kotva chybí nebo není zadaná).
int pageOfAnchor(Chapter c, String? anchor) {
  if (anchor == null) return 0;
  for (final (i, p) in c.pages.indexed) {
    if (p.blocks.any((b) => b is HeadingBlock && b.anchor == anchor)) return i;
  }
  return 0;
}

/// Kotvy potkaných pojmů kapitoly (značka u nadpisu).
Set<String> seenAnchors(Chapter c, Set<String> seenLore) => {
      for (final id in c.lore)
        if (seenLore.contains(id)) ?_anchorOf(id),
    };

/// Kapitola má razítko „potkáno", když hráč potkal aspoň jeden její pojem.
bool chapterSeen(Chapter c, Set<String> seenLore) =>
    c.lore.any(seenLore.contains);

String? _anchorOf(String id) {
  try {
    return lore.byId(id).anchor;
  } on ArgumentError {
    return null;
  }
}

/// Tmavé pozadí nad hrou, kid typografie na tmavém (onDark).
class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KidTheme(
      data: const KidThemeData(onDark: true),
      child: Material(
        color: Colors.black.withValues(alpha: Balance.bookBackdropAlpha),
        child: child,
      ),
    );
  }
}
