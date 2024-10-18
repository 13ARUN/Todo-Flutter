import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/theme_provider.dart';

enum ThemeModeOption { light, dark, system }

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  late ThemeModeOption _themeMode;

  @override
  void initState() {
    super.initState();
    final themeMode = ref.read(themeProvider);
    _themeMode = _getThemeModeOption(themeMode);
  }

  ThemeModeOption _getThemeModeOption(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return ThemeModeOption.light;
      case ThemeMode.dark:
        return ThemeModeOption.dark;
      case ThemeMode.system:
      default:
        return ThemeModeOption.system;
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
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
                              ref
                                  .read(themeProvider.notifier)
                                  .setThemeMode(ThemeMode.light);
                              Navigator.pop(context);
                            });
                          },
                        ),
                        RadioListTile<ThemeModeOption>(
                          title: const Text('Dark Theme'),
                          value: ThemeModeOption.dark,
                          groupValue: _themeMode,
                          onChanged: (ThemeModeOption? value) {
                            setState(() {
                              _themeMode = value!;
                              ref
                                  .read(themeProvider.notifier)
                                  .setThemeMode(ThemeMode.dark);
                              Navigator.pop(context);
                            });
                          },
                        ),
                        RadioListTile<ThemeModeOption>(
                          title: const Text('System Default'),
                          value: ThemeModeOption.system,
                          groupValue: _themeMode,
                          onChanged: (ThemeModeOption? value) {
                            setState(() {
                              _themeMode = value!;
                              ref
                                  .read(themeProvider.notifier)
                                  .setThemeMode(ThemeMode.system);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
