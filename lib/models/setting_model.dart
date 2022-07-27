import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'setting_model.g.dart';

@HiveType(typeId: 1)
class SettingModel extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  bool _bgm = false;

  @HiveField(1)
  bool _sfx = false;

  SettingModel({bool bgm = true, bool sfx = true}) {
    _bgm = bgm;
    _sfx = sfx;
  }

  bool get bgm => _bgm;

  set bgm(bool value) {
    _bgm = value;
    notifyListeners();
    save();
  }

  bool get sfx => _sfx;

  set sfx(bool value) {
    _sfx = value;
    notifyListeners();
    save();
  }
}
