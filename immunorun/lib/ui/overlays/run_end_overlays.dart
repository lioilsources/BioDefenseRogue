import 'package:flutter/material.dart';

import '../../domain/lore.dart';
import '../../domain/lore_text.dart';
import '../../domain/meta_progress.dart';
import '../../game/immuno_game.dart';
import '../book/book_theme.dart';

/// Game over — smrt hráče nebo kritická horečka.
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.game});
  final ImmunoGame game;

  @override
  Widget build(BuildContext context) {
    final waves = game.wavesCleared;
    return Center(
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
            const Text(
              'GAME OVER',
              style: TextStyle(
                color:      Colors.redAccent,
                fontSize:   36,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              waves > 0 ? 'Přežito vln: $waves' : 'Padl jsi hned.',
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
                  label:     'CO MĚ ZABILO?',
                  color:     Colors.teal.shade700,
                  onPressed: () => game.openBookAt(cause),
                ),
              ),
            _EndButton(
              label:     'ZKUSIT ZNOVU',
              color:     Colors.green.shade700,
              onPressed: game.resetGame,
            ),
            const SizedBox(height: 10),
            _EndButton(
              label:     'ZPĚT DO MENU',
              color:     Colors.blueGrey.shade700,
              onPressed: game.returnToMenu,
            ),
          ],
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
    return Center(
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
            const Text(
              'IMMUNITA DOSAŽENA',
              style: TextStyle(
                color:      Color(0xFF2ECC71),
                fontSize:   30,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Patogen zničen. Host přežil.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _MetaSummary(game: game),
            const SizedBox(height: 28),
            _EndButton(
              label:     '$bookButtonCz: ${_memory.nameCz.toUpperCase()}',
              color:     Colors.teal.shade700,
              onPressed: () => game.openBookAt(_memory),
            ),
            const SizedBox(height: 10),
            _EndButton(
              label:     'NOVÝ RUN',
              color:     Colors.green.shade700,
              onPressed: game.resetGame,
            ),
            const SizedBox(height: 10),
            _EndButton(
              label:     'ZPĚT DO MENU',
              color:     Colors.blueGrey.shade700,
              onPressed: game.returnToMenu,
            ),
          ],
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
    final earned   = game.lastRunCellsEarned;
    final killedBy = killedByLabelCz(game.meta.lastKilledByType);
    final vaccinated =
        vaccinationTarget(game.meta.lastKilledByType) != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (earned > 0)
          Text(
            '+$earned paměťových buněk',
            style: const TextStyle(
              color:    Color(0xFF5DADE2),
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        if (vaccinated && killedBy != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              renderLore('Příště: imunizace proti $killedBy '
                  '({{balance.vaccinationDamageBonus|pctDelta}} dmg)'),
              style: const TextStyle(
                color:    Color(0xFF58D68D),
                fontSize: 13,
              ),
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
