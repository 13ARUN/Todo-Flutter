import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/providers/theme_provider.dart';

part 'theme_option_widget.dart';
part 'theme_selection_dialog.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
              onTap: () => _showThemeSelectionDialog(context, ref, themeMode),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelectionDialog(
      BuildContext context, WidgetRef ref, ThemeMode themeMode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ThemeSelectionDialog(
          themeMode: themeMode,
          ref: ref,
        );
      },
    );
  }
}
