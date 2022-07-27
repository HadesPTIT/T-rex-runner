import 'package:flame_audio/flame_audio.dart';
import 'package:t_rex_flame/models/setting_model.dart';

class AudioManager {
  //
  late SettingModel settings;

  AudioManager._internal();

  static final AudioManager _instance = AudioManager._internal();

  static AudioManager get instance => _instance;

  Future<void> init(List<String> files, SettingModel settings) async {
    this.settings = settings;

    // This must be called for auto-pause and resume to work properly
    FlameAudio.bgm.initialize();

    /// Loads all the [files] provided to the cache.
    await FlameAudio.audioCache.loadAll(files);
  }

  // Starts the given audio file as BGM
  void startBgm([String filename = '8BitPlatformerLoop.wav']) {
    if (settings.bgm) {
      FlameAudio.bgm.play(filename, volume: 0.5);
    }
  }

  // Pauses currently playing BGM if any.
  void pauseBgm() {
    if (settings.bgm) {
      FlameAudio.bgm.pause();
    }
  }

  // Resumes currently paused BGM if any.
  void resumeBgm() {
    if (settings.bgm) {
      FlameAudio.bgm.resume();
    }
  }

  // Stops currently playing BGM if any.
  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  // Plays the given audio file once.
  void playSfx(String fileName) {
    if (settings.sfx) {
      FlameAudio.play(fileName);
    }
  }
}
