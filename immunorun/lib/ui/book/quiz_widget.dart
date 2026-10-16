import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';

import '../../book/model/book_model.dart';
import '../../config/balance.dart';
import 'blocks/block_view.dart' show renderBookText;

/// Kvíz na konci kapitoly (F6): 3 otázky, výběr, okamžitá odpověď s jednou
/// větou vysvětlení. Bez skóre a bez vlivu na hru (ADR 0002, OQ-5);
/// po zodpovězení všech otázek jen razítko „kvíz hotov".
class QuizView extends StatefulWidget {
  const QuizView({
    super.key,
    required this.questions,
    required this.palette,
    required this.scale,
    this.done = false,
    this.onDone,
  });

  final List<QuizQuestion> questions;
  final KidPalette         palette;
  final double             scale;
  final bool               done;
  final VoidCallback?      onDone;

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late final List<int?> _chosen = List.filled(widget.questions.length, null);
  var _reported = false;

  void _choose(int q, int a) {
    if (_chosen[q] != null) return; // první volba platí
    setState(() => _chosen[q] = a);
    if (!_reported && _chosen.every((c) => c != null)) {
      _reported = true;
      widget.onDone?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = KidTheme.of(context);
    final pal   = widget.palette;
    final size  = Balance.bookBodySize * widget.scale;
    final finished = widget.done || _chosen.every((c) => c != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BubbleText('Kvíz', role: KidRole.title, palette: pal,
              size: Balance.bookHeadingSize * widget.scale,
              align: TextAlign.left),
        ),
        for (final (qi, q) in widget.questions.indexed) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: Text('${qi + 1}. ${renderBookText(q.question)}',
                style: theme.style(KidRole.dialog, palette: pal, size: size)),
          ),
          for (final (ai, a) in q.answers.indexed)
            _Answer(
              text:    renderBookText(a.text),
              palette: pal,
              size:    size,
              state:   _chosen[qi] == null
                  ? _AnswerState.open
                  : a.correct
                      ? _AnswerState.correct
                      : (_chosen[qi] == ai ? _AnswerState.wrong : _AnswerState.idle),
              onTap: () => _choose(qi, ai),
            ),
          if (_chosen[qi] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                '${q.answers[_chosen[qi]!].correct ? 'Správně!' : 'Ne tak docela.'} '
                '${renderBookText(q.why)}',
                style: theme.style(KidRole.body, palette: pal, size: size),
              ),
            ),
        ],
        if (finished)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Center(
              child: Transform.rotate(
                angle: -0.08,
                child: BubbleText('kvíz hotov', role: KidRole.upper,
                    palette: KidPalette.lemon,
                    size: Balance.bookBoxTitleSize * 1.4 * widget.scale),
              ),
            ),
          ),
      ],
    );
  }
}

enum _AnswerState { open, correct, wrong, idle }

class _Answer extends StatelessWidget {
  const _Answer({
    required this.text,
    required this.palette,
    required this.size,
    required this.state,
    required this.onTap,
  });

  final String       text;
  final KidPalette   palette;
  final double       size;
  final _AnswerState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (border, icon, label) = switch (state) {
      _AnswerState.correct => (KidPalette.mint.mid, Icons.check_circle, 'správná odpověď'),
      _AnswerState.wrong   => (KidPalette.peach.dark, Icons.cancel, 'špatná odpověď'),
      _AnswerState.open    => (palette.mid, null, null),
      _AnswerState.idle    => (palette.dark, null, null),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        button: state == _AnswerState.open,
        label:  label == null ? text : '$text, $label',
        excludeSemantics: true,
        child: InkWell(
          onTap: state == _AnswerState.open ? onTap : null,
          borderRadius: BorderRadius.circular(Balance.bookQuizAnswerRadius),
          child: Container(
            constraints: const BoxConstraints(minHeight: Balance.bookTapTargetMin),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: border.withValues(alpha: Balance.bookQuizAnswerFillAlpha),
              borderRadius: BorderRadius.circular(Balance.bookQuizAnswerRadius),
              border: Border.all(color: border, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(text, style: KidTheme.of(context)
                      .style(KidRole.body, palette: palette, size: size)),
                ),
                if (icon != null) Icon(icon, color: border),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
