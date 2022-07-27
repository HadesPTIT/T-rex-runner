import 'dart:developer' as developer;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:t_rex_flame/components/enemy_component.dart';
import 'package:t_rex_flame/manager/game_manager.dart';
import 'package:t_rex_flame/models/enemy_model.dart';

// This class is responsible for spawning random enemies at certain
// interval of time depending upon players current score.
class EnemyManager extends Component with HasGameRef<GameManager> {
  // A list of enemy data to hold
  final List<EnemyModel> _data = [];

  // Random generator required for randomly selecting enemy type
  final Random _random = Random();

  // Timer to decide when to spawn next enemy
  final Timer _timer = Timer(2, repeat: true);

  EnemyManager() {
    _timer.onTick = spawnRandomEnemy;
  }

  // Spawn random enemy
  void spawnRandomEnemy() {
    // Generate a random enemy using its index in the [data]
    int randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(randomIndex);
    final enemy = EnemyComponent(enemyData);

    developer.log("SPAWN ENEMY ${enemy.toString()}");

    // Initialize enemy settings & position
    enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(gameRef.size.x + 32, gameRef.size.y - 24);

    // If enemy can fly
    // its yPosition is random number times higher than Trex height
    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
      enemy.position.y -= newHeight;
    }

    // Due to the size of the viewport
    // We can use textureSize as size for the component
    enemy.size = enemyData.textureSize;

    // Add enemy to the game
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    if (isMounted) {
      removeFromParent();
    }

    // Don't fill list again  and again on every mount
    if (_data.isEmpty) {
      // Initial all enemy type & data
      _data.addAll(
        [
          EnemyModel(
            image: gameRef.images.fromCache('AngryPig/Walk (36x30).png'),
            numOfFrames: 16,
            stepTime: 0.1,
            textureSize: Vector2(36, 30),
            speedX: 80,
            canFly: false,
          ),
          EnemyModel(
            image: gameRef.images.fromCache('Bat/Flying (46x30).png'),
            numOfFrames: 7,
            stepTime: 0.1,
            textureSize: Vector2(46, 30),
            speedX: 100,
            canFly: true,
          ),
          EnemyModel(
            image: gameRef.images.fromCache('Rino/Run (52x34).png'),
            numOfFrames: 6,
            stepTime: 0.09,
            textureSize: Vector2(52, 34),
            speedX: 150,
            canFly: false,
          ),
        ],
      );
    }

    // Start timer to generate enemy
    _timer.start();

    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);

    super.update(dt);
  }

  // All of enemy is stored in Enemy class
  // Filter all type Enemy to remove its
  void removeAllEnemies() {
    final enemies = gameRef.children.whereType<EnemyComponent>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}
