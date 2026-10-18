import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../book/model/book_model.dart';
import '../../book/parser/book_loader.dart';
import '../../config/balance.dart';
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
    return book.when(
      data: (b) => BookScreen(
        book:           b,
        initialChapter: game.bookChapterRequest,
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
  });

  final Book              book;
  final int               fontStep;
  final ValueChanged<int> onFontStep;
  final VoidCallback      onClose;

  /// Deep-link: otevři rovnou kapitolu; „zpět" pak knihu zavře
  /// (návrat tam, odkud dítě přišlo).
  final String? initialChapter;

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
  }

  @override
  Widget build(BuildContext context) {
    final open = _open;
    return _Backdrop(
      child: SafeArea(
        child: open == null
            ? ChapterList(
                chapters: widget.book.chapters,
                onOpen:   (c) => setState(() => _open = c),
                onClose:  widget.onClose,
              )
            : ChapterReader(
                key:        ValueKey(open.id),
                chapter:    open,
                fontStep:   widget.fontStep,
                onFontStep: widget.onFontStep,
                onBack: _direct
                    ? widget.onClose
                    : () => setState(() => _open = null),
              ),
      ),
    );
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
