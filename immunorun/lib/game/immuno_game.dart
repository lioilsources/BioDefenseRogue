import 'dart:async' as async;
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/balance.dart';
import '../domain/enemy_archetype.dart';
import '../domain/meta_progress.dart';
import '../domain/upgrade.dart';
import '../ui/hud/hud_overlay.dart' show feverProvider, playerHpProvider, waveProvider, atpProvider;
import 'components/enemies/enemy.dart';
import 'components/enemies/mini_boss.dart';
import 'components/enemies/swarmer.dart';
import 'components/fever_overlay.dart';
import 'components/microscope_overlay.dart';
import 'components/movement_trail.dart';
import 'components/pickup.dart';
import 'components/player/player.dart';
import 'components/player/player_controller.dart';
import 'rooms/room_graph.dart';
import 'systems/audio_controller.dart';
import 'systems/fever_controller.dart';
import 'systems/object_pool.dart';
import 'systems/swarmer_pool.dart';
import 'systems/swim_controller.dart';
import 'systems/upgrade_controller.dart';
import 'systems/wave_controller.dart';
import 'world/arena.dart';
import 'world/background.dart';

class ImmunoGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  ImmunoGame({
    required this.providerContainer,
    this.initialMeta = MetaProgress.empty,
    this.onRunEnded,
  }) : meta = initialMeta;

  final ProviderContainer providerContainer;

  /// Meta-progrese — načtená při startu, aktualizovaná po konci runu.
  final MetaProgress initialMeta;
  MetaProgress meta;

  /// Voláno po konci runu (smrt/výhra) s aktualizovanou metou — uložení.
  final void Function(MetaProgress meta)? onRunEnded;

  /// Buňky získané v posledním dohraném runu (pro game-over/run-won UI).
  int lastRunCellsEarned = 0;

  late final Player           _player;
  late final PlayerController _controller;
  late final MovementTrail    _trail;
  late final FeverController  _fever;
  late final BackgroundLayer  _background;
  late final World            _activeWorld;
  late final ArenaComponent   _arena;
  late final WaveController        _waves;
  late final SwarmerPool           _swarmerPool;
  late final FeverOverlayComponent _feverOverlay;
  late final MicroscopeOverlayComponent _microscopeOverlay;
  late final CameraComponent  _cam;
  late final SwimController   _swim;
  late final double           _camBaseZoom;

  PlayerController get playerController => _controller;

  bool   _gameOver      = false;
  bool   _runWon        = false;
  bool   _transitioning = false;
  double _hitStopTimer  = 0;
  int    _wavesCleared  = 0;
  int    _roomsCleared  = 0;
  String _lastDamageSource = 'swarmer'; // poslední zdroj zásahu hráče

  // Room/run state
  late RoomGraph   _roomGraph;
  RoomNode?        _currentNode;
  int              _roomNumber = 0;
  List<RoomNode>   _pendingChoices = [];

  List<RoomNode> get pendingChoices => _pendingChoices;

  // Upgrady (receptory/cytokiny)
  final UpgradeController upgrades = UpgradeController();
  final Random _rng = Random();
  List<UpgradeDef> _pendingUpgrades = [];
  bool             _upgradePending  = false;

  List<UpgradeDef> get pendingUpgrades => _pendingUpgrades;

  // Pool na ATP pickupy
  final ObjectPool<AtpPickup> _pickupPool =
      ObjectPool<AtpPickup>(factory: AtpPickup.new, initialSize: 16);

  // Audio (SFX)
  final AudioController audio = AudioController();

  @override
  Color backgroundColor() => const Color(0xFF0D1F0D);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _activeWorld = World();
    await add(_activeWorld);

    _cam = CameraComponent.withFixedResolution(
      width:  size.x,
      height: size.y,
    );
    _cam.world = _activeWorld;
    await add(_cam);
    _camBaseZoom = _cam.viewfinder.zoom;
    _swim = SwimController();

    _background = BackgroundLayer();
    _arena      = ArenaComponent();
    await _activeWorld.add(_background);
    await _activeWorld.add(_arena);

    _controller = PlayerController();
    _player     = Player(controller: _controller);
    _player.position = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    _trail = MovementTrail(positionGetter: () => _player.position);
    await _activeWorld.add(_controller);
    await _activeWorld.add(_trail);  // pod hráče (dřív v pořadí renderu)
    await _activeWorld.add(_player);

    _cam.follow(_player);
    _fever = FeverController();

    _player.onAbilityUsed = _fever.onAbility;
    _player.feverGetter   = () => _fever.snapshot;
    _player.upgrades      = upgrades;
    _player.onFeverRise   = _fever.riseBy;
    _player.onDash        = () => audio.play(Sfx.dash);

    _swarmerPool =
        SwarmerPool(onPlayerContact: () => _onEnemyHitPlayerFrom('swarmer'));
    _swarmerPool.prewarm(Balance.maxActiveEnemies, _player);

    _waves = WaveController(
      player:          _player,
      world:           _activeWorld,
      // WaveController předává callback tankům
      onPlayerContact: () => _onEnemyHitPlayerFrom('tank'),
      swarmerPool:     _swarmerPool,
    );
    _waves.onWaveStart   = _onWaveStart;
    _waves.onWaveCleared = _onWaveCleared;

    await _activeWorld.add(_waves);
    _activeWorld.children.register<Enemy>();

    // Meta bonusy (paměťové buňky → max HP, vakcinace) na start runu
    _applyMeta();
    _player.reset();

    // Inicializuj první run
    _roomGraph   = RoomGraph.generateRun();
    _currentNode = _roomGraph.start;
    _setupRoom(_currentNode!);

    _microscopeOverlay = MicroscopeOverlayComponent();
    await add(_microscopeOverlay);

    _feverOverlay = FeverOverlayComponent();
    await add(_feverOverlay);

    await _tryLoadFluidShader();
    await _tryLoadFeverShader();
    await _tryLoadMicroscopeShader();
    await audio.preload();

    // Boot do hlavního menu — run startuje až startRun()
    overlays.add('mainMenu');
    pauseEngine();
  }

  // ─── Menu / pauza ─────────────────────────────────────────────────────────

  /// Start runu z hlavního menu.
  void startRun() {
    overlays.remove('mainMenu');
    // Gesta až po inicializaci controlleru (ochrana před LateInitializationError)
    if (!kIsWeb && !_isDesktop) overlays.add('gesture');
    overlays.add('hud');
    resumeEngine();
  }

  void pauseGame() {
    if (_gameOver || _runWon) return;
    if (overlays.isActive('pause') || overlays.isActive('mainMenu')) return;
    if (_upgradePending || _pendingChoices.isNotEmpty) return; // probíhá volba
    overlays.add('pause');
    pauseEngine();
  }

  void resumeGame() {
    overlays.remove('pause');
    resumeEngine();
  }

  /// Restart runu z pauzy.
  void restartRun() {
    overlays.remove('pause');
    resetGame();
  }

  /// Návrat do hlavního menu (z pauzy nebo game over/run won).
  void returnToMenu() {
    overlays.remove('pause');
    resetGame();
    overlays.remove('hud');
    overlays.remove('gesture');
    overlays.add('mainMenu');
    pauseEngine();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      if (overlays.isActive('pause')) {
        resumeGame();
      } else {
        pauseGame();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  static bool get _isDesktop =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  // ─── Room management ─────────────────────────────────────────────────────

  void _setupRoom(RoomNode node) {
    _waves.setRoom(node.type, difficulty: _roomNumber);
  }

  /// Stabilní callback — žádné obalování při přechodech (jinak roste řetěz closures)
  void _onWaveStart(int wave) {
    _fever.setRoomClear(false);
    if (_currentNode?.type == RoomType.boss) _spawnBoss();
  }

  void _onWaveCleared(int wave) {
    _wavesCleared = wave;
    _roomsCleared++;
    _fever.setRoomClear(true);

    if (_currentNode?.type == RoomType.treasure) {
      _player.heal(Balance.treasureHealAmount);
    }
    if (_currentNode?.children.isEmpty ?? false) {
      _triggerRunWon();
      return;
    }
    _offerUpgrades();
  }

  /// Po vyčištění místnosti nabídni výběr upgradu (1 z N).
  void _offerUpgrades() {
    final offer = upgrades.rollOffer(_rng, Balance.upgradeChoicesOffered);
    if (offer.isEmpty) return; // všechno už vlastníme
    _pendingUpgrades = offer;
    _upgradePending  = true;
    overlays.add('upgradeChoice');
    pauseEngine();
  }

  void chooseUpgrade(UpgradeDef def) {
    upgrades.acquire(def.id);
    _pendingUpgrades = [];
    _upgradePending  = false;
    overlays.remove('upgradeChoice');
    resumeEngine();
  }

  void _checkGateEntry() {
    if (_waves.phase != WavePhase.cleared) return;
    if (_transitioning) return;
    if (_pendingChoices.isNotEmpty) return;
    if (_upgradePending) return; // nejdřív vybrat upgrade
    if (_runWon || _gameOver) return;
    if (!_isPlayerAtGate()) return;

    final node = _currentNode!;
    if (node.children.isEmpty) {
      _triggerRunWon();
      return;
    }

    if (node.children.length == 1) {
      _beginTransition(node.children.first);
    } else {
      _pendingChoices = node.children;
      overlays.add('roomChoice');
      pauseEngine();
    }
  }

  bool _isPlayerAtGate() {
    final px = _player.position.x;
    final py = _player.position.y;
    final w  = Balance.arenaWidth;
    final h  = Balance.arenaHeight;
    final g  = Balance.gateSize;
    final t  = Balance.gateDetectDepth;

    if (py < t && px >= w / 2 - g / 2 && px <= w / 2 + g / 2) return true;
    if (py > h - t && px >= w / 2 - g / 2 && px <= w / 2 + g / 2) return true;
    if (px < t && py >= h / 2 - g / 2 && py <= h / 2 + g / 2) return true;
    if (px > w - t && py >= h / 2 - g / 2 && py <= h / 2 + g / 2) return true;

    return false;
  }

  void chooseDoor(RoomNode node) {
    _pendingChoices = [];
    overlays.remove('roomChoice');
    resumeEngine();
    _beginTransition(node);
  }

  void _beginTransition(RoomNode next) {
    _transitioning = true;
    overlays.add('transition');

    async.Future.delayed(
      Duration(milliseconds: (Balance.transitionFadeDuration * 1000).round()),
      () {
        _doRoomReset(next);
        async.Future.delayed(
          Duration(milliseconds: (Balance.transitionFadeDuration * 1000).round()),
          () {
            overlays.remove('transition');
            _transitioning = false;
          },
        );
      },
    );
  }

  /// Vrať poolované komponenty a odstraň zbytek (boss, projektily, částice).
  void _clearRoomEntities() {
    _swarmerPool.releaseAll(_activeWorld);
    for (final p in _activeWorld.children.whereType<AtpPickup>().toList()) {
      p.removeFromParent();
      _pickupPool.release(p);
    }
    _activeWorld.children
        .where((c) =>
            c is! Player &&
            c is! PlayerController &&
            c is! MovementTrail &&
            c is! ArenaComponent &&
            c is! BackgroundLayer &&
            c is! WaveController &&
            c is! Swarmer)
        .toList()
        .forEach((c) => c.removeFromParent());
  }

  void _doRoomReset(RoomNode next) {
    _currentNode = next;
    _roomNumber++;

    _clearRoomEntities();

    _player.position = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    _trail.clear(); // ať teleport na střed nenakreslí pruh přes arénu
    _fever.setRoomClear(false);

    _setupRoom(next);
    _waves.reset();
  }

  void _spawnBoss() {
    _activeWorld.add(
      (MiniBoss(
        player:          _player,
        feverGetter:     () => _fever.snapshot,
        onPlayerContact: () => _onEnemyHitPlayerFrom('boss'),
      )..onPhaseShift = () => audio.play(Sfx.bossPhase))
        ..position = Vector2(
          Balance.arenaWidth / 2 + Balance.bossOrbitRadius,
          Balance.arenaHeight / 2,
        ),
    );
  }

  // ─── Game events ─────────────────────────────────────────────────────────

  void _onEnemyHitPlayer() {
    _fever.onHit();
    triggerHitStop();
    audio.play(Sfx.playerHurt);
  }

  /// Zásah hráče se zdrojem — kvůli vakcinaci (meta) víme, kdo zabil.
  void _onEnemyHitPlayerFrom(String source) {
    _lastDamageSource = source;
    _onEnemyHitPlayer();
  }

  /// Aplikuj meta bonusy na začátku runu (paměťové buňky, vakcinace).
  void _applyMeta() {
    _player.maxHp        = Balance.playerMaxHp + meta.bonusStartHp;
    _player.vaccinatedVs = vaccinationTarget(meta.lastKilledByType);
  }

  /// Konec runu — připiš paměťové buňky, zaznamenej zabijáka, ulož.
  void _finishRun({required bool won, String? killedBy}) {
    lastRunCellsEarned = _roomsCleared * Balance.memoryCellsPerRoom +
        (won ? Balance.memoryCellsWinBonus : 0);
    meta = meta.copyWith(
      memoryCells:       meta.memoryCells + lastRunCellsEarned,
      totalRuns:         meta.totalRuns + 1,
      wins:              meta.wins + (won ? 1 : 0),
      lastKilledByType:  killedBy,
      clearLastKilledBy: killedBy == null,
    );
    onRunEnded?.call(meta);
  }

  /// Drop ATP pickupu na místě smrti nepřítele.
  void _spawnAtpDrop(Vector2 pos, EnemyArchetype archetype) {
    if (archetype.atpDrop <= 0) return;
    final pickup = _pickupPool.acquire();
    pickup.resetForPool(
      pos,
      archetype.atpDrop,
      _player,
      (p) {
        p.removeFromParent();
        _pickupPool.release(p);
      },
      onCollected: () => audio.play(Sfx.pickup),
    );
    _activeWorld.add(pickup);
  }

  void triggerHitStop() => _hitStopTimer = Balance.hitStopDuration;

  void _triggerGameOver() {
    if (_gameOver) return;
    _gameOver = true;
    _finishRun(
      won:      false,
      killedBy: _fever.isDead ? 'fever' : _lastDamageSource,
    );
    overlays.add('gameOver');
  }

  void _triggerRunWon() {
    if (_runWon) return;
    _runWon = true;
    _finishRun(won: true, killedBy: null);
    overlays.add('runWon');
  }

  // ─── Shader ──────────────────────────────────────────────────────────────

  Future<void> _tryLoadFluidShader() async {
    try {
      final program =
          await ui.FragmentProgram.fromAsset('assets/shaders/fluid.frag');
      _background.applyShader(program);
    } catch (e) {
      debugPrint('ImmunoGame: fluid shader nedostupný: $e');
    }
  }

  Future<void> _tryLoadFeverShader() async {
    try {
      final program =
          await ui.FragmentProgram.fromAsset('assets/shaders/fever.frag');
      _feverOverlay.applyShader(program);
    } catch (e) {
      debugPrint('ImmunoGame: fever shader nedostupný: $e');
    }
  }

  Future<void> _tryLoadMicroscopeShader() async {
    try {
      final program =
          await ui.FragmentProgram.fromAsset('assets/shaders/microscope.frag');
      _microscopeOverlay.applyShader(program);
    } catch (e) {
      debugPrint('ImmunoGame: microscope shader nedostupný: $e');
    }
  }

  // ─── Update loop ─────────────────────────────────────────────────────────

  @override
  void update(double dt) {
    if (_hitStopTimer > 0) {
      _hitStopTimer -= dt;
      return;
    }

    super.update(dt);

    // Plavání v roztoku — follow už snapnul viewfinder na hráče,
    // drift se přičítá až po něm a příští frame ho follow zase přepíše.
    _swim.update(dt);
    final swim = _swim.snapshot;
    _cam.viewfinder.position += Vector2(swim.offsetX, swim.offsetY);
    _cam.viewfinder.angle = swim.angleRad;
    _cam.viewfinder.zoom  = _camBaseZoom * swim.zoomScale;

    if (_gameOver || _runWon) return;

    _wireNewEnemies();

    _arena.phase = _waves.phase;

    final activeEnemies = _activeWorld.children.whereType<Enemy>().length;
    _fever.update(
      dt,
      activeEnemies: activeEnemies,
      extraDecay:    upgrades.feverDecayBonus,
    );

    if (_fever.snapshot.zone == FeverZone.hyper ||
        _fever.snapshot.zone == FeverZone.critical) {
      _player.takeDamage((Balance.feverHpDrainHyper * dt).round());
      if (_player.isDead) _lastDamageSource = 'fever';
    }

    if (_player.isDead || _fever.isDead) _triggerGameOver();

    _checkGateEntry();

    final snap   = _fever.snapshot;
    final hpNorm = _player.hp / _player.maxHp;
    final waveSn = _waves.snapshot;

    _feverOverlay.setFever(snap.normalized);

    Future.microtask(() {
      providerContainer.read(feverProvider.notifier).setSnapshot(snap);
      providerContainer.read(playerHpProvider.notifier).set(hpNorm);
      providerContainer.read(waveProvider.notifier).set(waveSn);
      providerContainer.read(atpProvider.notifier).set(_player.atpNorm);
    });
  }

  void _wireNewEnemies() {
    for (final e in _activeWorld.children.query<Enemy>()) {
      e.onHitCallback ??= _onEnemyDamaged;
      e.onDrop        ??= _onEnemyDied;
    }
  }

  void _onEnemyDamaged() {
    triggerHitStop();
    audio.play(Sfx.hit);
  }

  void _onEnemyDied(Vector2 pos, EnemyArchetype archetype) {
    audio.play(Sfx.death);
    _spawnAtpDrop(pos, archetype);
  }

  // ─── Public state ─────────────────────────────────────────────────────────

  int get wavesCleared => _wavesCleared;

  // ─── Reset ────────────────────────────────────────────────────────────────

  void resetGame() {
    _gameOver      = false;
    _runWon        = false;
    _transitioning = false;
    _hitStopTimer  = 0;
    _wavesCleared  = 0;
    _roomsCleared  = 0;
    _roomNumber    = 0;
    _pendingChoices  = [];
    _pendingUpgrades = [];
    _upgradePending  = false;
    upgrades.reset();
    _applyMeta(); // nová meta (vakcinace z minulé smrti) platí od teď

    overlays.remove('gameOver');
    overlays.remove('runWon');
    overlays.remove('transition');
    overlays.remove('roomChoice');
    overlays.remove('upgradeChoice');
    overlays.remove('pause');
    resumeEngine(); // game over mohl přijít během pauzy

    _clearRoomEntities();

    _player.position = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    _player.reset();
    _trail.clear();
    _fever.reset();
    _swim.reset();

    _roomGraph   = RoomGraph.generateRun();
    _currentNode = _roomGraph.start;
    _setupRoom(_currentNode!);
    _waves.reset();
  }
}
