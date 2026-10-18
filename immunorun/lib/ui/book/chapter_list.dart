import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';

import '../../book/model/book_model.dart';
import '../../config/balance.dart';
import 'blocks/block_view.dart';
import 'book_overlay.dart' show chapterSeen;
import 'book_theme.dart';

/// Seznam kapitol: obálka (hero, zatím placeholder) + číslo + název.
/// Nic není zamčené (05-kniha ADR 0002).
class ChapterList extends StatelessWidget {
  const ChapterList({
    super.key,
    required this.chapters,
    required this.onOpen,
    required this.onClose,
    this.seenLore = const {},
    this.lastChapter,
    this.quizDone = const {},
    this.onParents,
  });

  final Set<String>            quizDone;
  final VoidCallback?          onParents;
  final Set<String>            seenLore;
  final String?                lastChapter;
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
            itemCount: chapters.length + (onParents == null ? 0 : 1),
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, i) => i == chapters.length
                ? Center(
                    child: TextButton(
                      onPressed: onParents,
                      child: BubbleText('Pro rodiče a učitele',
                          role: KidRole.upper,
                          palette: KidTheme.of(context).palette,
                          size: Balance.bookBarTitleSize),
                    ),
                  )
                : _ChapterCard(
                  chapter: chapters[i],
                  seen:    chapterSeen(chapters[i], seenLore),
                  last:    chapters[i].id == lastChapter,
                  quiz:    quizDone.contains(chapters[i].id),
                  onTap:   () => onOpen(chapters[i]),
                ),
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

/// Razítko na obálce (jen informace, nic neodemyká – ADR 0002).
class _Stamp extends StatelessWidget {
  const _Stamp(this.text, this.palette);

  final String     text;
  final KidPalette palette;

  @override
  Widget build(BuildContext context) => Transform.rotate(
        angle: -0.08,
        child: BubbleText(text, role: KidRole.upper, palette: palette,
            size: Balance.bookStampSize),
      );
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({
    required this.chapter,
    required this.onTap,
    this.seen = false,
    this.last = false,
    this.quiz = false,
  });

  final Chapter      chapter;
  final bool         seen;
  final bool         last;
  final bool         quiz;
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
              Stack(
                children: [
                  BookImage(file: chapter.hero, alt: chapter.title, palette: pal),
                  if (seen)
                    const Positioned(top: 10, right: 10, child: _Stamp('potkáno', KidPalette.lemon)),
                  if (last)
                    Positioned(top: 10, left: 10, child: _Stamp('naposledy', pal)),
                  if (quiz)
                    const Positioned(bottom: 10, right: 10,
                        child: _Stamp('kvíz hotov', KidPalette.mint)),
                ],
              ),
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
