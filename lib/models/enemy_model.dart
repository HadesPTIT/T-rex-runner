import 'package:flame/extensions.dart';

class EnemyModel {
  final Image image;
  final int numOfFrames;
  final double stepTime;
  final Vector2 textureSize;
  final double speedX;
  final bool canFly;

  EnemyModel({
    required this.image,
    required this.numOfFrames,
    required this.stepTime,
    required this.textureSize,
    required this.speedX,
    required this.canFly,
  });

  EnemyModel copyWith({
    Image? image,
    int? numOfFrames,
    double? stepTime,
    Vector2? textureSize,
    double? speedX,
    bool? canFly,
  }) {
    return EnemyModel(
      image: image ?? this.image,
      numOfFrames: numOfFrames ?? this.numOfFrames,
      stepTime: stepTime ?? this.stepTime,
      textureSize: textureSize ?? this.textureSize,
      speedX: speedX ?? this.speedX,
      canFly: canFly ?? this.canFly,
    );
  }

  @override
  String toString() {
    return 'EnemyModel(image: $image, numOfFrames: $numOfFrames, stepTime: $stepTime, textureSize: $textureSize, speedX: $speedX, canFly: $canFly)';
  }
}
