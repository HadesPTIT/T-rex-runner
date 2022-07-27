import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_rex_flame/manager/manager.dart';
import 'package:t_rex_flame/models/models.dart';
import 'package:t_rex_flame/widgets/menu.dart';

class Hud extends StatelessWidget {
  static const id = 'Hud';

  final GameManager gameRef;

  const Hud(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.player,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                gameRef.overlays.remove(Hud.id);
                gameRef.overlays.add(PauseMenu.id);
                gameRef.pauseEngine();
                AudioManager.instance.pauseBgm();
              },
              child: const Icon(Icons.pause, color: Colors.white),
            ),
            Column(
              children: [
                Selector<PlayerModel, int>(
                  selector: (_, playerData) => playerData.currentScore,
                  builder: (_, score, __) {
                    return Text(
                      'Score: $score',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    );
                  },
                ),
                Selector<PlayerModel, int>(
                  selector: (_, playerData) => playerData.highScore,
                  builder: (_, highScore, __) {
                    return Text(
                      'High: $highScore',
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ],
            ),
            Selector<PlayerModel, int>(
              selector: (_, playerData) => playerData.lives,
              builder: (_, lives, __) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: List.generate(
                      5,
                      (index) {
                        if (index < lives) {
                          return const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          );
                        } else {
                          return const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
