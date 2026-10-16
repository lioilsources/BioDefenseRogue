import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';

import '../../book/model/book_model.dart';
import '../../config/balance.dart';
import 'blocks/block_view.dart';
import 'book_theme.dart';

/// Seznam kapitol: obálka (hero, zatím placeholder) + číslo + název.
/// Nic není zamčené (05-kniha ADR 0002).
class ChapterList extends StatelessWidget {
  const ChapterList({
    super.key,
    required this.chapters,
    required this.onOpen,
    required this.onClose,
  });

  final List<Chapter>          chapters;
  final ValueChanged<Chapter>  onOpen;
  final VoidCallback           onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Bar(onClose: onClose),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(Balance.bookPagePadding),
            itemCount: chapters.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, i) =>
                _ChapterCard(chapter: chapters[i], onTap: () => onOpen(chapters[i])),
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final pal = KidTheme.of(context).palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Balance.bookPagePadding, 8, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: BubbleText(
              bookTitleCz,
              role:    KidRole.title,
              palette: pal,
              size:    Balance.bookCoverTitleSize,
              align:   TextAlign.left,
            ),
          ),
          IconButton(
            tooltip:     'Zavřít',
            iconSize:    28,
            constraints: const BoxConstraints(
              minWidth:  Balance.bookTapTargetMin,
              minHeight: Balance.bookTapTargetMin,
            ),
            color:     pal.light,
            icon:      const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({required this.chapter, required this.onTap});

  final Chapter      chapter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pal    = paletteForPart(chapter.part);
    final number = int.tryParse(chapter.id.split('-').first);
    return Semantics(
      button: true,
      label:  chapter.title,
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(Balance.bookBoxRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Balance.bookBoxRadius),
            border:       Border.all(color: pal.mid, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BookImage(file: chapter.hero, alt: chapter.title, palette: pal),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Row(
                  children: [
                    if (number != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: BubbleText('$number',
                            role: KidRole.number, palette: pal,
                            size: Balance.bookListTitleSize),
                      ),
                    Expanded(
                      child: BubbleText(
                        chapter.title,
                        role:    KidRole.title,
                        palette: pal,
                        size:    Balance.bookListTitleSize,
                        align:   TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
