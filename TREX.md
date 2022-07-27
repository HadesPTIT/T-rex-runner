## Flame cơ bản

### 1. File structure

- [https://docs.flame-engine.org/1.2.0/flame/structure.html](https://docs.flame-engine.org/1.2.0/flame/structure.html)

- Recommend các folder resource game nên đặt trong folder assets

~~~
    assets/audio
    assets/fonts
    assets/images
~~~

### 2. Game Widget

- Game widget là 1 Flutter widget được dùng để insert `Game` vào widget tree.

- Có 2 cách để insert game vào widget tree

~~~dart
void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}
~~~
Hoặc
~~~dart
void main() {
  runApp(GameWidget.controlled(gameFactory: MyGame.new));
}
~~~

## 3. Game loop

