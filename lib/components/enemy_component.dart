import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:t_rex_flame/manager/game_manager.dart';
import 'package:t_rex_flame/models/enemy_model.dart';

//
// This class is used to represent an enemy component
// that has sprites run in a single cyclic animation.
//
class EnemyComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<GameManager> {
  final EnemyModel enemy;

  EnemyComponent(this.enemy) {
    init();
  }

  void init() {
    animation = SpriteAnimation.fromFrameData(
      enemy.image,
      SpriteAnimationData.sequenced(
        amount: enemy.numOfFrames,
        stepTime: enemy.stepTime,
        textureSize: enemy.textureSize,
      ),
    );
  }

  @override
  void onMount() {
    // Reduce the size of enemy as they look too big compared to the trex
    size *= 0.6;

    add(
      RectangleHitbox.relative(
        Vector2.all(0.8),
        parentSize: size,
        position: Vector2(size.x * 0.2, size.y * 0.2) / 2,
      ),
    );

    super.onMount();
  }

  @override
  void update(double dt) {
    // Move the opponent closer to the left corner of the screen
    position.x = position.x - enemy.speedX * dt;

    // Remove the enemy if enemy has gone past left end of the screen
    if (position.x < -enemy.textureSize.x) {
      removeFromParent();
      gameRef.player.currentScore += 1;
    }

    super.update(dt);
  }
}
