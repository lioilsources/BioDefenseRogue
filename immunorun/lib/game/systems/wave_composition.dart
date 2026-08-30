// Čistý Dart — složení vlny podle typu místnosti a obtížnosti.

import '../../config/balance.dart';
import '../../domain/room_type.dart';

typedef WaveComposition = ({int swarmers, int tanks});

WaveComposition composeWave({
  required RoomType roomType,
  required int difficulty,
}) {
  // Boss a treasure vlny nespawní řadové nepřátele
  if (roomType == RoomType.boss || roomType == RoomType.treasure) {
    return (swarmers: 0, tanks: 0);
  }

  final elite = roomType == RoomType.elite;
  final base  = Balance.waveBaseEnemies + difficulty * Balance.waveEnemiesPerWave;
  final total = (base * (elite ? Balance.eliteEnemyMultiplier : 1.0))
      .round()
      .clamp(1, Balance.maxActiveEnemies);

  var tanks = 0;
  if (difficulty >= Balance.tankStartDifficulty) {
    tanks = (difficulty - Balance.tankStartDifficulty + 1 + (elite ? 1 : 0))
        .clamp(0, Balance.tankMaxPerWave);
  }

  // Tank "váží" víc swarmer slotů — celková síla vlny zůstává srovnatelná
  final swarmers = (total - tanks * Balance.tankSwarmerWeight)
      .clamp(1, Balance.maxActiveEnemies);

  return (swarmers: swarmers, tanks: tanks);
}
