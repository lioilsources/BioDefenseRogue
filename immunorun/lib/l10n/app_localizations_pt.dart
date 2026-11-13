// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get menuSubtitle => 'Célula imunitária contra infeção';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp PV máx.';
  }

  @override
  String get menuStartRun => 'INICIAR PARTIDA';

  @override
  String get menuBook => 'LÉXICO';

  @override
  String get menuSoundOn => 'SOM: LIGADO';

  @override
  String get menuSoundOff => 'SOM: DESLIGADO';

  @override
  String get pauseTitle => 'PAUSA';

  @override
  String get pauseResume => 'CONTINUAR';

  @override
  String get pauseRestart => 'RECOMEÇAR PARTIDA';

  @override
  String get backToMenu => 'VOLTAR AO MENU';

  @override
  String get gameOverTitle => 'FIM DO JOGO';

  @override
  String gameOverWaves(int count) {
    return 'Vagas superadas: $count';
  }

  @override
  String get gameOverInstant => 'Caíste logo.';

  @override
  String get gameOverCause => 'O QUE ME MATOU?';

  @override
  String get gameOverRetry => 'TENTAR OUTRA VEZ';

  @override
  String get runWonTitle => 'IMUNIDADE ALCANÇADA';

  @override
  String get runWonSubtitle =>
      'Agente patogénico destruído. O hospedeiro sobreviveu.';

  @override
  String get runWonNewRun => 'NOVA PARTIDA';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count células de memória',
      one: '+1 célula de memória',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Da próxima vez: imunizado contra $enemy ($bonus de dano)';
  }

  @override
  String get roomChoiceTitle => 'ESCOLHE O CAMINHO';

  @override
  String get upgradeChoiceTitle => 'ESCOLHE CITOCINA / RECETOR';

  @override
  String get upgradeInfoTooltip => 'O que é isto? (Léxico)';

  @override
  String hudStartingIn(int secs) {
    return 'COMEÇA DAQUI A $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'VAGA $wave DAQUI A $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'VAGA $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'VAGA $wave — LIMPA!';
  }

  @override
  String bookToastOne(String name) {
    return 'Nova página no livro: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Novas páginas no livro: $name e mais ($count)';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get menuSubtitle => 'Célula imune contra infecção';

  @override
  String menuMemoryCells(String name, int count, int hp) {
    return '$name: $count  ·  +$hp HP máx.';
  }

  @override
  String get menuStartRun => 'INICIAR PARTIDA';

  @override
  String get menuBook => 'LÉXICO';

  @override
  String get menuSoundOn => 'SOM: LIGADO';

  @override
  String get menuSoundOff => 'SOM: DESLIGADO';

  @override
  String get pauseTitle => 'PAUSA';

  @override
  String get pauseResume => 'CONTINUAR';

  @override
  String get pauseRestart => 'REINICIAR PARTIDA';

  @override
  String get backToMenu => 'VOLTAR AO MENU';

  @override
  String get gameOverTitle => 'FIM DE JOGO';

  @override
  String gameOverWaves(int count) {
    return 'Ondas sobrevividas: $count';
  }

  @override
  String get gameOverInstant => 'Você caiu logo de cara.';

  @override
  String get gameOverCause => 'O QUE ME MATOU?';

  @override
  String get gameOverRetry => 'TENTAR DE NOVO';

  @override
  String get runWonTitle => 'IMUNIDADE ALCANÇADA';

  @override
  String get runWonSubtitle => 'Patógeno destruído. O hospedeiro sobreviveu.';

  @override
  String get runWonNewRun => 'NOVA PARTIDA';

  @override
  String metaCellsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count células de memória',
      one: '+1 célula de memória',
    );
    return '$_temp0';
  }

  @override
  String metaVaccinationHint(String enemy, String bonus) {
    return 'Da próxima vez: imunizado contra $enemy ($bonus de dano)';
  }

  @override
  String get roomChoiceTitle => 'ESCOLHA O CAMINHO';

  @override
  String get upgradeChoiceTitle => 'ESCOLHA CITOCINA / RECEPTOR';

  @override
  String get upgradeInfoTooltip => 'O que é isso? (Léxico)';

  @override
  String hudStartingIn(int secs) {
    return 'COMEÇA EM $secs s';
  }

  @override
  String hudWaveIn(int wave, int secs) {
    return 'ONDA $wave EM $secs s';
  }

  @override
  String hudWave(int wave) {
    return 'ONDA $wave';
  }

  @override
  String hudWaveCleared(int wave) {
    return 'ONDA $wave — LIMPA!';
  }

  @override
  String bookToastOne(String name) {
    return 'Nova página no livro: $name';
  }

  @override
  String bookToastMany(String name, int count) {
    return 'Novas páginas no livro: $name e mais ($count)';
  }
}
