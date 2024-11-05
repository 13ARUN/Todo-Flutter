import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/utils/export/export_methods.dart';
import 'package:todo/utils/logger/logger.dart';

part 'theme_option_widget.dart';
part 'theme_selection_dialog.dart';

/// A settings screen that allows users to configure app preferences.
class Settings extends ConsumerWidget {
  const Settings({super.key});

  /// Logger instance for tracking events in the Settings class.
  static final logger = getLogger('Settings');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t("Build Method Executing");
    final themeMode =
        ref.watch(themeProvider); // Watch for changes in the theme mode
    logger.d("Current Theme Mode: $themeMode");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // Title for the settings screen
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Display'), // Section header for display options
            ListTile(
              leading: const Icon(
                  Icons.brightness_6_outlined), // Icon for theme selection
              title: const Text('Theme'), // Title of the list tile
              subtitle: Text(ref
                  .read(themeProvider.notifier)
                  .currentThemeOption), // Displays current theme option
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              onTap: () {
                logger.i("Clicked on Theme Selection option");
                _showThemeSelectionDialog(
                    context, ref, themeMode); // Show theme selection dialog
              },
            ),
            const Text('Advanced'), // Section header for advanced options
            ListTile(
              leading: const Icon(Icons.file_download), // Icon for log export
              title: const Text('Export Logs'), // Title of the list tile
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              onTap: () async {
                logger.i("Export Logs clicked");
                await ExportMethods
                    .exportLogs(); // Trigger log export from ExportMethods
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.picture_as_pdf_sharp), // Icon for PDF export
              title: const Text('Share Todos as PDF'), // Title of the list tile
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              onTap: () async {
                logger.i("Export Todos clicked");
                await ExportMethods
                    .exportTodosAsPDF(); // Trigger export of todos as PDF from ExportMethods
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Displays a dialog for selecting the app theme.
  void _showThemeSelectionDialog(
      BuildContext context, WidgetRef ref, ThemeMode themeMode) {
    logger.t("Executing _showThemeSelectionDialog method");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ThemeSelectionDialog(
          themeMode: themeMode, // Pass the current theme mode to the dialog
          ref: ref, // Pass the widget reference for theme updates
        );
      },
    );
  }
}
