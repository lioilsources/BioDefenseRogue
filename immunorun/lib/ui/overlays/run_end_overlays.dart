import 'package:flutter/material.dart';

import '../../config/balance.dart';
import '../../domain/lore.dart';
import '../../domain/lore_text.dart';
import '../../domain/meta_progress.dart';
import '../../game/immuno_game.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/lore_l10n.dart';
import 'screen_background.dart';

/// Game over — smrt hráče nebo kritická horečka.
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.game});
  final ImmunoGame game;

  @override
  Widget build(BuildContext context) {
    final waves = game.wavesCleared;
    final l10n  = AppLocalizations.of(context);
    return ScreenBackground(
      asset: ScreenImages.gameOver,
      child: Center(
        child: Container(
          padding:    const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
          decoration: BoxDecoration(
            color:        Colors.black87,
            borderRadius: BorderRadius.circular(16),
            border:       Border.all(color: Colors.red.shade700, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.gameOverTitle,
                style: const TextStyle(
                  color:      Colors.redAccent,
                  fontSize:   36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                waves > 0 ? l10n.gameOverWaves(waves) : l10n.gameOverInstant,
                style: const TextStyle(
                  color:    Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _MetaSummary(game: game),
              const SizedBox(height: 28),
              if (loreForKilledBy(game.meta.lastKilledByType) case final cause?)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _EndButton(
                    label:     l10n.gameOverCause,
                    color:     Colors.teal.shade700,
                    onPressed: () => game.openBookAt(cause),
                  ),
                ),
              _EndButton(
                label:     l10n.gameOverRetry,
                color:     Colors.green.shade700,
                onPressed: game.playAgain,
              ),
              const SizedBox(height: 10),
              _EndButton(
                label:     l10n.backToMenu,
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

/// Výhra runu — boss poražen.
class RunWonOverlay extends StatelessWidget {
  const RunWonOverlay({super.key, required this.game});
  final ImmunoGame game;

  static LoreEntry get _memory => lore.byId('meta.memoryCells');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScreenBackground(
      asset: ScreenImages.runWon,
      child: Center(
        child: Container(
          padding:    const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
          decoration: BoxDecoration(
            color:        Colors.black87,
            borderRadius: BorderRadius.circular(16),
            border:       Border.all(color: Colors.green.shade400, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.runWonTitle,
                style: const TextStyle(
                  color:      Color(0xFF2ECC71),
                  fontSize:   30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.runWonSubtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _MetaSummary(game: game),
              const SizedBox(height: 28),
              _EndButton(
                label:     '${l10n.menuBook}: ${_memory.name.toUpperCase()}',
                color:     Colors.teal.shade700,
                onPressed: () => game.openBookAt(_memory),
              ),
              const SizedBox(height: 10),
              _EndButton(
                label:     l10n.runWonNewRun,
                color:     Colors.green.shade700,
                onPressed: game.playAgain,
              ),
              const SizedBox(height: 10),
              _EndButton(
                label:     l10n.backToMenu,
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

/// Souhrn mety po runu: získané buňky + vakcinační hint (smrt = informace).
class _MetaSummary extends StatelessWidget {
  const _MetaSummary({required this.game});
  final ImmunoGame game;

  @override
  Widget build(BuildContext context) {
    final l10n     = AppLocalizations.of(context);
    final earned   = game.lastRunCellsEarned;
    final killedBy = loreForKilledBy(game.meta.lastKilledByType)?.vaccinationTarget;
    final vaccinated =
        vaccinationTarget(game.meta.lastKilledByType) != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (earned > 0)
          Text(
            l10n.metaCellsEarned(earned),
            style: const TextStyle(
              color:    Color(0xFF5DADE2),
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        if (vaccinated && killedBy != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  ScreenImages.vaccination,
                  width:  Balance.metaIconSize,
                  height: Balance.metaIconSize,
                  excludeFromSemantics: true,
                  errorBuilder: (context, _, _) =>
                      const SizedBox.square(dimension: Balance.metaIconSize),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.metaVaccinationHint(
                      killedBy,
                      renderLore('{{balance.vaccinationDamageBonus|pctDelta}}',
                          locale: loreLocale),
                    ),
                    style: const TextStyle(
                      color:    Color(0xFF58D68D),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _EndButton extends StatelessWidget {
  const _EndButton({
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
      width: 260,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, letterSpacing: 2),
        ),
      ),
    );
  }
}
