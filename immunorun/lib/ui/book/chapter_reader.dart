import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';

import '../../book/model/book_model.dart';
import '../../config/balance.dart';
import 'blocks/block_view.dart';
import 'book_overlay.dart' show seenAnchors;
import 'book_theme.dart';

/// Čtečka kapitoly: lišta (zpět, název, velikost písma), stránky (swipe),
/// tečky. Kvíz jako poslední stránka přijde v K7.
class ChapterReader extends StatefulWidget {
  const ChapterReader({
    super.key,
    required this.chapter,
    required this.fontStep,
    required this.onFontStep,
    required this.onBack,
    this.initialPage = 0,
    this.seenLore = const {},
  });

  final Set<String>       seenLore;

  final Chapter           chapter;
  final int               fontStep;
  final ValueChanged<int> onFontStep;
  final VoidCallback      onBack;
  final int               initialPage;

  @override
  State<ChapterReader> createState() => _ChapterReaderState();
}

class _ChapterReaderState extends State<ChapterReader> {
  late final PageController _pages =
      PageController(initialPage: widget.initialPage);
  late int _page = widget.initialPage;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c     = widget.chapter;
    final pal   = paletteForPart(c.part);
    final scale = bookFontScale(widget.fontStep);

    return Column(
      children: [
        _ReaderBar(
          title:      c.title,
          palette:    pal,
          fontStep:   widget.fontStep,
          onFontStep: widget.onFontStep,
          onBack:     widget.onBack,
        ),
        Expanded(
          child: PageView.builder(
            controller:    _pages,
            itemCount:     c.pages.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder:   (context, i) => _PageView(
              page:    c.pages[i],
              palette: pal,
              scale:   scale,
              seen:    seenAnchors(c, widget.seenLore)
                  .contains(c.pages[i].anchor),
            ),
          ),
        ),
        _Dots(count: c.pages.length, current: _page, palette: pal),
      ],
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView({
    required this.page,
    required this.palette,
    required this.scale,
    this.seen = false,
  });

  /// Pojem této stránky už hráč potkal ve hře.
  final bool seen;

  final BookPage       page;
  final KidPalette palette;
  final double     scale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Balance.bookMaxContentWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Balance.bookPagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (seen)
                Align(
                  alignment: Alignment.centerRight,
                  child: Semantics(
                    label: 'Potkáno ve hře',
                    child: Icon(Icons.verified, color: KidPalette.lemon.mid,
                        size: Balance.bookBoxTitleSize * 1.6 * scale),
                  ),
                ),
              for (final b in page.blocks)
                BlockView(block: b, palette: palette, scale: scale),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReaderBar extends StatelessWidget {
  const _ReaderBar({
    required this.title,
    required this.palette,
    required this.fontStep,
    required this.onFontStep,
    required this.onBack,
  });

  final String            title;
  final KidPalette        palette;
  final int               fontStep;
  final ValueChanged<int> onFontStep;
  final VoidCallback      onBack;

  static const _minTap = BoxConstraints(
    minWidth:  Balance.bookTapTargetMin,
    minHeight: Balance.bookTapTargetMin,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            tooltip:     'Zpět',
            constraints: _minTap,
            color:       palette.light,
            icon:        const Icon(Icons.arrow_back),
            onPressed:   onBack,
          ),
          Expanded(
            child: BubbleText(
              title,
              role:     KidRole.upper,
              palette:  palette,
              size:     Balance.bookBarTitleSize,
              align:    TextAlign.left,
              maxLines: 1,
            ),
          ),
          for (var i = 0; i < Balance.bookFontScales.length; i++)
            Semantics(
              button:   true,
              selected: i == fontStep,
              label:    'Velikost písma ${i + 1}',
              child: InkResponse(
                onTap: () => onFontStep(i),
                child: ConstrainedBox(
                  constraints: _minTap,
                  child: Center(
                    child: Text(
                      'A',
                      key:   ValueKey('bookFont$i'),
                      style: KidTheme.of(context).style(
                        KidRole.dialog,
                        palette: palette,
                        size:    Balance.bookBarTitleSize *
                            Balance.bookFontScales[i],
                        color:   i == fontStep ? palette.mid : palette.light,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.count,
    required this.current,
    required this.palette,
  });

  final int        count;
  final int        current;
  final KidPalette palette;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Stránka ${current + 1} z $count',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < count; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: Balance.bookPageTurnMs),
                margin:   const EdgeInsets.symmetric(horizontal: 4),
                width:    Balance.bookDotSize * (i == current ? 2 : 1),
                height:   Balance.bookDotSize,
                decoration: BoxDecoration(
                  color: i == current ? palette.mid : palette.dark,
                  borderRadius: BorderRadius.circular(Balance.bookDotSize),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
