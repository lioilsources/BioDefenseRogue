import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/lore.dart';
import '../../game/immuno_game.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/lore_l10n.dart';
import '../meta_providers.dart';
import 'screen_background.dart';

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
    final l10n = AppLocalizations.of(context);
    return ScreenBackground(
      asset: ScreenImages.menu,
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
            Text(
              l10n.menuSubtitle,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, _) {
                final meta = ref.watch(metaProvider);
                if (meta.memoryCells == 0) return const SizedBox.shrink();
                return Text(
                  l10n.menuMemoryCells(lore.byId('meta.memoryCells').name,
                      meta.memoryCells, meta.bonusStartHp),
                  style: const TextStyle(
                    color:    Color(0xFF5DADE2),
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _MenuButton(
              label:     l10n.menuStartRun,
              color:     Colors.green.shade700,
              onPressed: game.startRun,
            ),
            const SizedBox(height: 14),
            _MenuButton(
              label:     l10n.menuBook,
              color:     Colors.teal.shade700,
              onPressed: game.openBook,
            ),
            const SizedBox(height: 14),
            _MenuButton(
              label: game.audio.enabled ? l10n.menuSoundOn : l10n.menuSoundOff,
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
