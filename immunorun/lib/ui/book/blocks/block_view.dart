import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../book/model/book_model.dart';
import '../../../config/balance.dart';
import '../../../domain/lore_text.dart';
import '../book_theme.dart';
import '../glossary_popup.dart';

/// Dosadí placeholdery; když render selže (to hlídá BookSync test), ukáže
/// raději syrový text než prázdné místo.
String renderBookText(String text) {
  try {
    return renderLore(text);
  } on LoreTextException {
    return text;
  }
}

/// Jeden blok stránky jako widget.
class BlockView extends StatelessWidget {
  const BlockView({
    super.key,
    required this.block,
    required this.palette,
    required this.scale,
  });

  final Block      block;
  final KidPalette palette;
  final double     scale;

  @override
  Widget build(BuildContext context) {
    final b = block;
    return switch (b) {
      HeadingBlock(level: 2, :final text) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BubbleText(
            renderBookText(text),
            role:    KidRole.title,
            palette: palette,
            size:    Balance.bookHeadingSize * scale,
            align:   TextAlign.left,
          ),
        ),
      HeadingBlock(:final text) => Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          child: Text(
            renderBookText(text),
            style: KidTheme.of(context).style(KidRole.dialog,
                palette: palette, size: Balance.bookBodySize * scale),
          ),
        ),
      ParagraphBlock(:final inlines) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InlineText(inlines: inlines, palette: palette, scale: scale),
        ),
      ListBlock(:final items) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•  ', style: _body(context)),
                      Expanded(
                        child: InlineText(
                            inlines: item, palette: palette, scale: scale),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ImageBlock(:final file, :final alt) =>
        BookImage(file: file, alt: alt, palette: palette),
      BoxBlock(:final kind, :final children) =>
        BookBox(kind: kind, scale: scale, children: children),
    };
  }

  TextStyle _body(BuildContext context) => KidTheme.of(context)
      .style(KidRole.body, palette: palette, size: Balance.bookBodySize * scale);
}

/// Odstavec: text, hesla (tap → bublina slovníčku, F9), kurzíva pro
/// latinské názvy.
class InlineText extends StatefulWidget {
  const InlineText({
    super.key,
    required this.inlines,
    required this.palette,
    required this.scale,
    this.interactive = true,
  });

  final List<Inline> inlines;
  final KidPalette   palette;
  final double       scale;

  /// false = hesla bez tapu (uvnitř bubliny slovníčku).
  final bool interactive;

  @override
  State<InlineText> createState() => _InlineTextState();
}

class _InlineTextState extends State<InlineText> {
  final _taps = <TapGestureRecognizer>[];

  @override
  void dispose() {
    for (final t in _taps) {
      t.dispose();
    }
    super.dispose();
  }

  TapGestureRecognizer? _tapFor(TermRun term) {
    if (!widget.interactive) return null;
    final g = BookScope.maybeOf(context)?.glossary[term.termId];
    if (g == null) return null;
    final r = TapGestureRecognizer()
      ..onTap = () => showGlossaryBubble(context, g, widget.palette);
    _taps.add(r);
    return r;
  }

  @override
  Widget build(BuildContext context) {
    for (final t in _taps) {
      t.dispose();
    }
    _taps.clear();
    final inlines = widget.inlines;
    final palette = widget.palette;
    final scale   = widget.scale;
    final theme = KidTheme.of(context);
    final plain = inlines.map((i) => i.text).join();
    final body  = theme.style(KidRole.body,
        palette: palette, size: Balance.bookBodySize * scale, forText: plain);
    return Text.rich(
      TextSpan(
        style: body,
        children: [
          for (final i in inlines)
            switch (i) {
              TextRun()     => TextSpan(text: renderBookText(i.text)),
              EmphasisRun() => TextSpan(
                  text:  renderBookText(i.text),
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              TermRun()     => TextSpan(
                  text:  renderBookText(i.text),
                  recognizer: _tapFor(i),
                  semanticsLabel: '${renderBookText(i.text)}, heslo slovníčku',
                  style: TextStyle(
                    color:           palette.mid,
                    fontWeight:      FontWeight.w700,
                    decoration:      TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dotted,
                    decorationColor: palette.mid,
                  ),
                ),
            },
        ],
      ),
    );
  }
}

class BookBox extends StatelessWidget {
  const BookBox({
    super.key,
    required this.kind,
    required this.scale,
    required this.children,
  });

  final BoxKind     kind;
  final double      scale;
  final List<Block> children;

  @override
  Widget build(BuildContext context) {
    final style = boxStyle(kind);
    final pal   = style.palette;
    return Container(
      margin:  const EdgeInsets.only(top: 4, bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color:        pal.dark.withValues(alpha: Balance.bookBoxFillAlpha),
        borderRadius: BorderRadius.circular(Balance.bookBoxRadius),
        border:       Border.all(color: pal.mid, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: BubbleText(
              style.title,
              role:    KidRole.upper,
              palette: pal,
              size:    Balance.bookBoxTitleSize * scale,
              align:   TextAlign.left,
            ),
          ),
          for (final c in children)
            BlockView(block: c, palette: pal, scale: scale),
        ],
      ),
    );
  }
}

/// Obrázek z assets/book/images/; když chybí (pahýl fáze 2), plochý placeholder
/// v paletě kapitoly s popiskem.
class BookImage extends StatelessWidget {
  const BookImage({
    super.key,
    required this.file,
    required this.alt,
    required this.palette,
  });

  final String     file;
  final String     alt;
  final KidPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        image: true,
        label: alt,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Balance.bookBoxRadius),
          child: AspectRatio(
            aspectRatio: Balance.bookImageAspect,
            child: Image.asset(
              'assets/book/images/$file',
              fit:          BoxFit.cover,
              cacheWidth:   Balance.bookImageCacheWidth,
              excludeFromSemantics: true,
              errorBuilder: (context, _, _) => ImagePlaceholder(
                  text: alt, palette: palette),
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key, required this.text, required this.palette});

  final String     text;
  final KidPalette palette;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: palette.mid.withValues(alpha: Balance.bookPlaceholderAlpha),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: KidTheme.of(context).style(KidRole.body, palette: palette),
          ),
        ),
      ),
    );
  }
}
