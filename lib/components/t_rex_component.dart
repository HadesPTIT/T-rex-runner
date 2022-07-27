import 'dart:developer' as developer;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:t_rex_flame/components/enemy_component.dart';
import 'package:t_rex_flame/constant/animation_state.dart';
import 'package:t_rex_flame/constant/constants.dart';
import 'package:t_rex_flame/manager/manager.dart';
import 'package:t_rex_flame/models/player_model.dart';

class TRexComponent extends SpriteAnimationGroupComponent<TRexAnimationState>
    with CollisionCallbacks, HasGameRef<GameManager> {
  TRexComponent(Image image, this.playerData)
      : super.fromFrameData(image, AssetManager.animation);

  // The max distance from top of the screen beyond which
  // t-rex should never go. Basically the screen height - ground height
  double yMax = 0.0;

  // T-rex's current speed along y-axis
  double speedY = 0.0;

  // Control how long the hit animation will be exists
  final Timer _hitTimer = Timer(1);

  // Flag check whenever t-rex is hit enemy
  bool isHit = false;

  final PlayerModel playerData;

  static const double gravity = 800;

  @override
  void onMount() {
    _reset();
    _createHitBox();

    yMax = y;

    _hitTimer.onTick = () {
      current = TRexAnimationState.run;
      isHit = false;
    };

    super.onMount();
  }

  /// This method is called periodically by the game engine to request that your
  /// component updates itself.
  ///
  /// The time [dt] in seconds (with microseconds precision provided by Flutter)
  /// since the last update cycle.
  /// This time can vary according to hardware capacity, so make sure to update
  /// your state considering this.
  /// All components in the tree are always updated by the same amount. The time
  /// each one takes to update adds up to the next update cycle.
  @override
  void update(double dt) {
    // v = v + gravity*dt
    speedY = speedY + (gravity * dt);
    // position = position + velocity*dt
    y = y + (speedY * dt);

    // developer.log(
    //     ">>>> update() - dt : $dt - y: $y - yMax: $yMax - speedY: $speedY");

    /// This code makes sure that t-rex never goes beyond [yMax].
    if (isOnGround) {
      y = yMax;
      speedY = 0.0;
      if ((current != TRexAnimationState.hit) &&
          (current != TRexAnimationState.run)) {
        current = TRexAnimationState.run;
      }
    }

    _hitTimer.update(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is EnemyComponent && (!isHit)) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  // Makes the T-rex jump
  void jump() {
    if (isOnGround) {
      speedY = -300;
      current = TRexAnimationState.idle;
      AudioManager.instance.playSfx('jump14.wav');
    }
  }

  /// This method changes the animation to [TRexAnimationState.hit]
  /// Play the hit sound & reduces the player life by 1
  void hit() {
    isHit = true;
    AudioManager.instance.playSfx('hurt7.wav');
    current = TRexAnimationState.hit;
    _hitTimer.start();
    playerData.lives -= 1;
  }

  // Detect that T-rex is on ground
  bool get isOnGround => (y >= yMax);

  ///
  /// Create a hitbox for the T-rex
  ///
  void _createHitBox() {
    add(
      RectangleHitbox.relative(
        Vector2(0.5, 0.7),
        parentSize: size,
        position: Vector2(size.x * 0.5, size.y * 0.3) / 2,
      ),
    );
  }

  //
  // Reset all the important properties, because onMount()
  // will be called even while restarting the game
  //
  void _reset() {
    developer.log('reset()');
    if (isMounted) {
      // Remove the component from its parent in the next tick.
      removeFromParent();
    }
    anchor = Anchor.bottomLeft;
    position = Vector2(kTRexDefaultX, kTRexDefaultY);
    size = Vector2.all(24);
    current = TRexAnimationState.run;
    isHit = false;
    speedY = 0.0;
  }
}
