import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';

import '../../book/model/book_model.dart';
import '../../config/balance.dart';
import 'blocks/block_view.dart';

/// Slovníček pro čtečku: tučné heslo → bublina s definicí (F9).
class BookScope extends InheritedWidget {
  const BookScope({super.key, required this.glossary, required super.child});

  final Map<String, GlossaryTerm> glossary;

  static BookScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BookScope>();

  @override
  bool updateShouldNotify(BookScope old) => glossary != old.glossary;
}

/// Bublina s heslem; zavře se tapem mimo (barrierDismissible).
Future<void> showGlossaryBubble(
  BuildContext context,
  GlossaryTerm term,
  KidPalette palette,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Zavřít',
    barrierColor: Colors.black.withValues(alpha: Balance.bookGlossaryBarrierAlpha),
    builder: (context) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Balance.bookMaxContentWidth),
        child: Material(
          type: MaterialType.transparency,
          child: KidTheme(
            data: const KidThemeData(onDark: true),
            child: Container(
              margin:  const EdgeInsets.all(Balance.bookPagePadding),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
              decoration: BoxDecoration(
                color: palette.dark,
                borderRadius: BorderRadius.circular(Balance.bookBoxRadius),
                border: Border.all(color: palette.mid, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BubbleText(term.name,
                      role: KidRole.title, palette: palette,
                      size: Balance.bookListTitleSize, align: TextAlign.left),
                  const SizedBox(height: 8),
                  InlineText(inlines: term.definition, palette: palette,
                      scale: 1, interactive: false),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
