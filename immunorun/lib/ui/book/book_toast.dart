import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';

import '../../config/balance.dart';

/// „Nová stránka v knize" — nenásilná nota při vyčištění místnosti.
/// Nejde na ni kliknout (06-sync S3), zmizí sama.
class BookToast extends StatelessWidget {
  const BookToast({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    const pal = KidPalette.mint;
    return IgnorePointer(
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 64),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: pal.dark.withValues(alpha: Balance.bookBackdropAlpha),
                borderRadius: BorderRadius.circular(Balance.bookBoxRadius),
                border: Border.all(color: pal.mid, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book, color: pal.light, size: 20),
                    const SizedBox(width: 10),
                    Text(text,
                        style: const KidThemeData(onDark: true)
                            .style(KidRole.dialog, palette: pal, size: Balance.bookToastTextSize)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
