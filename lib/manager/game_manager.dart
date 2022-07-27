import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:t_rex_flame/components/components.dart';
import 'package:t_rex_flame/constant/constants.dart';
import 'package:t_rex_flame/manager/manager.dart';
import 'package:t_rex_flame/models/models.dart';
import 'package:t_rex_flame/widgets/menu.dart';

class GameManager extends FlameGame with TapDetector, HasCollisionDetection {
  late TRexComponent _trex;
  late EnemyManager _enemyManager;

  late PlayerModel player;
  late SettingModel setting;

  @override
  Future<void>? onLoad() async {
    player = await _readPlayerData();
    setting = await _readSettings();

    // Load audios resources with local settings
    await AudioManager.instance.init(AssetManager.audios, setting);
    // Start playing background music. Internally takes care
    // of checking user settings.
    AudioManager.instance.startBgm();
    // Load image resources
    await images.loadAll(AssetManager.images);

    //
    // Set a fixed viewport to avoid
    // manually scaling and handling different screen sizes.
    // Its sizes is as same as parallax
    //
    camera.viewport = FixedResolutionViewport(Vector2(384, 216));

    // Load parallax background
    final parallaxBackground = await loadParallaxComponent(
      AssetManager.background.map((e) => ParallaxImageData(e)).toList(),
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );

    add(parallaxBackground);

    return super.onLoad();
  }

  // Trigger when user click play the game
  void startGamePlay() {
    // Load main t-rex
    _trex = TRexComponent(images.fromCache('DinoSprites - tard.png'), player);
    _enemyManager = EnemyManager();

    add(_trex);
    add(_enemyManager);
  }

  @override
  void update(double dt) {
    if (player.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    // Make jump only when the game is playing
    if (overlays.isActive(Hud.id)) {
      _trex.jump();
    }

    super.onTapDown(info);
  }

  // Reset the game to the initial state
  void reset() {
    _trex.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();

    // Reset player data to inital values.
    player.currentScore = 0;
    player.lives = 5;
  }

  /// This method reads [PlayerModel] from the hive box.
  Future<PlayerModel> _readPlayerData() async {
    final playerDataBox = await Hive.openBox<PlayerModel>(kHivePlayerBox);
    final playerData = playerDataBox.get(kHivePlayerData);

    // If player data null, this means first run of the game
    if (playerData == null) {
      await playerDataBox.put(kHivePlayerData, PlayerModel());
    }
    // Now it's safe to return the stored data
    return playerDataBox.get(kHivePlayerData)!;
  }

  /// This method reads [SettingModel] from the hive box
  Future<SettingModel> _readSettings() async {
    final settingBox = await Hive.openBox<SettingModel>(kHiveSettingsBox);
    final settings = settingBox.get(kHiveSettingsData);

    if (settings == null) {
      await settingBox.put(kHiveSettingsData, SettingModel());
    }

    return settingBox.get(kHiveSettingsData)!;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // On resume, if active overlay is not PauseMenu,
        // resume the engine (lets the parallax effect play).
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        // If game is active, then remove Hud and add PauseMenu
        // before pausing the game.
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}
