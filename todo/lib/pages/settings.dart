import 'package:flutter/material.dart';

enum ThemeModeOption { light, dark, system }

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ThemeModeOption _themeMode = ThemeModeOption.system;

  ThemeMode _getThemeMode() {
    switch (_themeMode) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Display'),
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text('Theme'),
              subtitle: Text(_themeMode.name.toString()[0].toUpperCase() +
                  _themeMode.name.toString().substring(1)),
              contentPadding: const EdgeInsets.all(0),
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Choose theme'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<ThemeModeOption>(
                            title: const Text('Light Theme'),
                            value: ThemeModeOption.light,
                            groupValue: _themeMode,
                            onChanged: (ThemeModeOption? value) {
                              setState(() {
                                _themeMode = value!;
                                Navigator.pop(context);
                              });
                            },
                          ),
                          // Dark theme option
                          RadioListTile<ThemeModeOption>(
                            title: const Text('Dark Theme'),
                            value: ThemeModeOption.dark,
                            groupValue: _themeMode,
                            onChanged: (ThemeModeOption? value) {
                              setState(() {
                                _themeMode = value!;
                                Navigator.pop(context);
                              });
                            },
                          ),
                          // System default option
                          RadioListTile<ThemeModeOption>(
                            title: const Text('System Default'),
                            value: ThemeModeOption.system,
                            groupValue: _themeMode,
                            onChanged: (ThemeModeOption? value) {
                              setState(() {
                                _themeMode = value!;
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
