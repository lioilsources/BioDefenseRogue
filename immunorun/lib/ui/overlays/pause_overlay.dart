import 'package:flutter/material.dart';

import '../../game/immuno_game.dart';
import '../book/book_theme.dart';

/// Pauza — Esc nebo tlačítko v HUD.
class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key, required this.game});

  final ImmunoGame game;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.65),
      child: Center(
        child: Container(
          padding:    const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
          decoration: BoxDecoration(
            color:        Colors.black87,
            borderRadius: BorderRadius.circular(16),
            border:       Border.all(color: Colors.blueGrey.shade400, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PAUZA',
                style: TextStyle(
                  color:      Colors.white,
                  fontSize:   30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 28),
              _PauseButton(
                label:     'POKRAČOVAT',
                color:     Colors.green.shade700,
                onPressed: game.resumeGame,
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label:     bookButtonCz,
                color:     Colors.teal.shade700,
                onPressed: game.openBook,
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label:     'RESTART RUNU',
                color:     Colors.orange.shade800,
                onPressed: game.restartRun,
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label:     'ZPĚT DO MENU',
                color:     Colors.blueGrey.shade700,
                onPressed: game.returnToMenu,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String       label;
  final Color        color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, letterSpacing: 1.5),
        ),
      ),
    );
  }
}
