import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/providers/theme_provider.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

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
              subtitle:
                  Text(ref.read(themeProvider.notifier).currentThemeOption),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Choose theme'),
                    actions: [
                      TextButton(
                        child: const Text("Close"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<ThemeMode>(
                          title: const Text('System default'),
                          value: ThemeMode.system,
                          groupValue: themeMode,
                          onChanged: (ThemeMode? value) {
                            ref
                                .read(themeProvider.notifier)
                                .setThemeMode(ThemeMode.system);
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: const Text('Light'),
                          value: ThemeMode.light,
                          groupValue: themeMode,
                          onChanged: (ThemeMode? value) {
                            ref
                                .read(themeProvider.notifier)
                                .setThemeMode(ThemeMode.light);
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: const Text('Dark'),
                          value: ThemeMode.dark,
                          groupValue: themeMode,
                          onChanged: (ThemeMode? value) {
                            ref
                                .read(themeProvider.notifier)
                                .setThemeMode(ThemeMode.dark);
                            Navigator.pop(context);
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
