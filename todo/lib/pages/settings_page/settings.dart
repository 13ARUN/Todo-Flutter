import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo/services/providers/theme_provider.dart';
import 'package:todo/utils/logger/log_output.dart';
import 'package:todo/utils/logger/logger.dart';

part 'theme_option_widget.dart';
part 'theme_selection_dialog.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  static final logger = getLogger('Settings');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t("Build Method Executing");
    final themeMode = ref.watch(themeProvider);
    logger.d("Current Theme Mode: $themeMode");

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
              onTap: () {
                logger.i("Clicked on Theme Selection option");
                _showThemeSelectionDialog(context, ref, themeMode);
              },
            ),
            const Text('Logs'),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Export Logs'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              onTap: () async {
                logger.i("Export Logs clicked");
                await _exportLogs();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelectionDialog(
      BuildContext context, WidgetRef ref, ThemeMode themeMode) {
    logger.t("Executing _showThemeSelectionDialog method");
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

  Future<void> _exportLogs() async {
    try {
      final logOutput = await FileLogOutput.create();
      final logFile = await logOutput.getLogFile();

      logger.i("Log file path: ${logFile.path}");

      if (await logFile.exists()) {
        await Share.shareXFiles([XFile(logFile.path)],
            text: 'Exported log file');
        logger.i("Logs successfully shared for export");
      } else {
        logger.w("Log file not found for export");
      }
    } catch (e) {
      logger.e("Error exporting logs: $e");
    }
  }
}
