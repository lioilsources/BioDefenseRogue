import 'dart:async' as async;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/balance.dart';
import '../ui/hud/hud_overlay.dart';
import 'components/enemies/enemy.dart';
import 'components/enemies/mini_boss.dart';
import 'components/player/player.dart';
import 'components/player/player_controller.dart';
import 'rooms/room_graph.dart';
import 'systems/fever_controller.dart';
import 'systems/wave_controller.dart';
import 'world/arena.dart';
import 'world/background.dart';

class ImmunoGame extends FlameGame with HasCollisionDetection {
  ImmunoGame({required this.providerContainer});

  final ProviderContainer providerContainer;

  late final Player           _player;
  late final PlayerController _controller;
  late final FeverController  _fever;
  late final BackgroundLayer  _background;
  late final World            _activeWorld;
  late final ArenaComponent   _arena;
  late final WaveController   _waves;

  PlayerController get playerController => _controller;

  bool   _gameOver      = false;
  bool   _runWon        = false;
  bool   _transitioning = false;
  double _hitStopTimer  = 0;
  int    _wavesCleared  = 0;

  // Room/run state
  late RoomGraph   _roomGraph;
  RoomNode?        _currentNode;
  int              _roomNumber = 0;
  List<RoomNode>   _pendingChoices = [];

  List<RoomNode> get pendingChoices => _pendingChoices;

  @override
  Color backgroundColor() => const Color(0xFF0D1F0D);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _activeWorld = World();
    await add(_activeWorld);

    final cam = CameraComponent.withFixedResolution(
      width:  size.x,
      height: size.y,
    );
    cam.world = _activeWorld;
    await add(cam);

    _background = BackgroundLayer();
    _arena      = ArenaComponent();
    await _activeWorld.add(_background);
    await _activeWorld.add(_arena);

    _controller = PlayerController();
    _player     = Player(controller: _controller);
    _player.position = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    await _activeWorld.add(_controller);
    await _activeWorld.add(_player);

    cam.follow(_player);
    _fever = FeverController();

    _waves = WaveController(
      player:          _player,
      world:           _activeWorld,
      onPlayerContact: _onEnemyHitPlayer,
    );
    _waves.onWaveStart   = (_) => _fever.setRoomClear(false);
    _waves.onWaveCleared = _onWaveCleared;

    await _activeWorld.add(_waves);
    _activeWorld.children.register<Enemy>();

    // Inicializuj první run
    _roomGraph   = RoomGraph.generateRun();
    _currentNode = _roomGraph.start;
    _setupRoom(_currentNode!);

    await _tryLoadFluidShader();
    // Joystick až po inicializaci controlleru (ochrana před LateInitializationError)
    if (!kIsWeb && !_isDesktop) overlays.add('joystick');
    overlays.add('hud');
  }

  static bool get _isDesktop =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  // ─── Room management ─────────────────────────────────────────────────────

  void _setupRoom(RoomNode node) {
    _waves.setRoom(node.type, difficulty: _roomNumber);
  }

  void _onWaveCleared(int wave) {
    _wavesCleared = wave;
    _fever.setRoomClear(true);

    if (_currentNode?.type == RoomType.treasure) {
      _player.heal(Balance.treasureHealAmount);
    }
    if (_currentNode?.children.isEmpty ?? false) {
      _triggerRunWon();
    }
  }

  void _checkGateEntry() {
    if (_waves.phase != WavePhase.cleared) return;
    if (_transitioning) return;
    if (_pendingChoices.isNotEmpty) return;
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

  void _doRoomReset(RoomNode next) {
    _currentNode = next;
    _roomNumber++;

    // Odstraň všechny nepřátele a projektily
    _activeWorld.children
        .where((c) =>
            c is! Player &&
            c is! PlayerController &&
            c is! ArenaComponent &&
            c is! BackgroundLayer &&
            c is! WaveController)
        .toList()
        .forEach((c) => c.removeFromParent());

    _player.position = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    _fever.setRoomClear(false);

    _setupRoom(next);
    _waves.reset();

    // Boss místnost — spawni MiniBoss přes onWaveStart callback
    final oldOnWaveStart = _waves.onWaveStart;
    _waves.onWaveStart = (w) {
      oldOnWaveStart?.call(w);
      if (next.type == RoomType.boss) {
        _spawnBoss();
      }
    };
  }

  void _spawnBoss() {
    _activeWorld.add(
      MiniBoss(
        player:          _player,
        feverGetter:     () => _fever.snapshot,
        onPlayerContact: _onEnemyHitPlayer,
      )..position = Vector2(
          Balance.arenaWidth / 2 + Balance.bossOrbitRadius,
          Balance.arenaHeight / 2,
        ),
    );
  }

  // ─── Game events ─────────────────────────────────────────────────────────

  void _onEnemyHitPlayer() {
    _fever.onHit();
    triggerHitStop();
  }

  void triggerHitStop() => _hitStopTimer = Balance.hitStopDuration;

  void _triggerGameOver() {
    _gameOver = true;
    overlays.add('gameOver');
  }

  void _triggerRunWon() {
    if (_runWon) return;
    _runWon = true;
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

  // ─── Update loop ─────────────────────────────────────────────────────────

  @override
  void update(double dt) {
    if (_hitStopTimer > 0) {
      _hitStopTimer -= dt;
      return;
    }

    super.update(dt);
    if (_gameOver || _runWon) return;

    _wireNewEnemies();

    _arena.phase = _waves.phase;

    final activeEnemies = _activeWorld.children.whereType<Enemy>().length;
    _fever.update(dt, activeEnemies: activeEnemies);

    if (_fever.snapshot.zone == FeverZone.hyper ||
        _fever.snapshot.zone == FeverZone.critical) {
      _player.takeDamage((Balance.feverHpDrainHyper * dt).round());
    }

    if (_player.isDead || _fever.isDead) _triggerGameOver();

    _checkGateEntry();

    final snap   = _fever.snapshot;
    final hpNorm = _player.hp / Balance.playerMaxHp;
    final waveSn = _waves.snapshot;
    Future.microtask(() {
      providerContainer.read(feverProvider.notifier).setSnapshot(snap);
      providerContainer.read(playerHpProvider.notifier).set(hpNorm);
      providerContainer.read(waveProvider.notifier).set(waveSn);
    });
  }

  void _wireNewEnemies() {
    for (final e in _activeWorld.children.query<Enemy>()) {
      e.onHitCallback ??= triggerHitStop;
    }
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
    _roomNumber    = 0;
    _pendingChoices = [];

    overlays.remove('gameOver');
    overlays.remove('runWon');
    overlays.remove('transition');
    overlays.remove('roomChoice');

    _activeWorld.children
        .where((c) =>
            c is! Player &&
            c is! PlayerController &&
            c is! ArenaComponent &&
            c is! BackgroundLayer &&
            c is! WaveController)
        .toList()
        .forEach((c) => c.removeFromParent());

    _player.position = Vector2(Balance.arenaWidth / 2, Balance.arenaHeight / 2);
    _player.reset();
    _fever.reset();

    _roomGraph   = RoomGraph.generateRun();
    _currentNode = _roomGraph.start;
    _waves.onWaveStart   = (_) => _fever.setRoomClear(false);
    _waves.onWaveCleared = _onWaveCleared;
    _setupRoom(_currentNode!);
    _waves.reset();
  }
}
