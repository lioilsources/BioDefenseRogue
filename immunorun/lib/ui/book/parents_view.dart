import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../book/model/book_model.dart';
import '../../config/balance.dart';
import 'blocks/block_view.dart';

/// Otevře adresu mimo appku; vrací false, když to nejde.
typedef OpenUrl = Future<bool> Function(Uri url);

Future<bool> _openExternally(Uri url) =>
    launchUrl(url, mode: LaunchMode.externalApplication);

/// Strana Pro rodiče a učitele (F10). Adresy webů v textu (szu.cz…) jdou
/// ťuknout a otevřou se v prohlížeči až po potvrzení (05-kniha OQ-29).
class ParentsView extends StatelessWidget {
  const ParentsView({
    super.key,
    required this.sections,
    required this.onBack,
    this.openUrl = _openExternally,
  });

  final List<BookPage> sections;
  final VoidCallback   onBack;
  final OpenUrl        openUrl;

  Future<void> _confirmAndOpen(BuildContext context, String domain) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title:   const Text('Otevřít v prohlížeči?'),
        content: Text('Odejdeš ze hry na web $domain.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:     const Text('Zůstat'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child:     const Text('Otevřít'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final opened = await openUrl(Uri.https(domain));
    if (!opened && context.mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text('Web $domain se nepodařilo otevřít.')),
      );
    }
  }

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
                      BlockView(
                        block: b, palette: pal, scale: 1,
                        onLink: (d) => _confirmAndOpen(context, d),
                      ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
