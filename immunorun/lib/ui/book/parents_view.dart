import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';

import '../../book/model/book_model.dart';
import '../../config/balance.dart';
import 'blocks/block_view.dart';

/// Strana Pro rodiče a učitele (F10). Adresy webů jsou jen text; otevírání
/// v prohlížeči s potvrzením přijde s balíčkem url_launcher (05-kniha OQ-29).
class ParentsView extends StatelessWidget {
  const ParentsView({super.key, required this.sections, required this.onBack});

  final List<BookPage> sections;
  final VoidCallback   onBack;

  @override
  Widget build(BuildContext context) {
    const pal = KidPalette.sky;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
          child: Row(
            children: [
              IconButton(
                tooltip:   'Zpět',
                color:     pal.light,
                icon:      const Icon(Icons.arrow_back),
                onPressed: onBack,
              ),
              const Expanded(
                child: BubbleText('Pro rodiče a učitele',
                    role: KidRole.upper, palette: pal,
                    size: Balance.bookBarTitleSize, align: TextAlign.left),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Balance.bookMaxContentWidth),
              child: ListView(
                padding: const EdgeInsets.all(Balance.bookPagePadding),
                children: [
                  for (final s in sections)
                    for (final b in s.blocks)
                      BlockView(block: b, palette: pal, scale: 1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
