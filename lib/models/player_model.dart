import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'player_model.g.dart';

@HiveType(typeId: 0)
class PlayerModel extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;

  int _lives = 5;

  int _currentScore = 0;

  int get currentScore => _currentScore;

  int get lives => _lives;

  set currentScore(int value) {
    _currentScore = value;

    if (highScore < currentScore) {
      highScore = currentScore;
    }
    notifyListeners();

    //
    // Persists this object.
    //
    save();
  }

  set lives(int value) {
    if (value <= 5 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }
}
