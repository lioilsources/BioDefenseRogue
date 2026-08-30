import 'package:flutter/material.dart';

import '../../game/immuno_game.dart';

/// Hlavní menu — overlay, ne route (viz UX doc §12).
class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay({super.key, required this.game});

  final ImmunoGame game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'IMMUNORUN',
              style: TextStyle(
                color:      Color(0xFF2ECC71),
                fontSize:   48,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Imunitní buňka vs. infekce',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 40),
            _MenuButton(
              label:     'SPUSTIT RUN',
              color:     Colors.green.shade700,
              onPressed: game.startRun,
            ),
            const SizedBox(height: 14),
            _MenuButton(
              label: game.audio.enabled ? 'ZVUK: ZAP' : 'ZVUK: VYP',
              color: Colors.blueGrey.shade700,
              onPressed: () =>
                  setState(() => game.audio.enabled = !game.audio.enabled),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String       label;
  final Color        color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, letterSpacing: 2),
      ),
    );
  }
}
