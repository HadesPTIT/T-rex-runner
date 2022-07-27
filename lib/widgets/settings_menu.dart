import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_rex_flame/manager/manager.dart';
import 'package:t_rex_flame/models/models.dart';
import 'package:t_rex_flame/widgets/menu.dart';

class SettingsMenu extends StatelessWidget {
  static const id = 'SettingsMenu';

  final GameManager gameRef;

  const SettingsMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.setting,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.black.withAlpha(100),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                    Selector<SettingModel, bool>(
                      selector: (_, settings) => settings.bgm,
                      builder: (context, bgm, __) {
                        return SwitchListTile(
                          title: const Text(
                            'Music',
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                          value: bgm,
                          onChanged: (bool value) {
                            Provider.of<SettingModel>(context, listen: false)
                                .bgm = value;
                            if (value) {
                              AudioManager.instance.startBgm();
                            } else {
                              AudioManager.instance.stopBgm();
                            }
                          },
                        );
                      },
                    ),
                    Selector<SettingModel, bool>(
                      selector: (_, settings) => settings.sfx,
                      builder: (context, sfx, __) {
                        return SwitchListTile(
                          title: const Text(
                            'Effects',
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                          value: sfx,
                          onChanged: (bool value) {
                            Provider.of<SettingModel>(context, listen: false)
                                .sfx = value;
                          },
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        gameRef.overlays.remove(SettingsMenu.id);
                        gameRef.overlays.add(MainMenu.id);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
