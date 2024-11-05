part of 'settings.dart';

/// A dialog that allows users to select a theme for the application.
class ThemeSelectionDialog extends StatelessWidget {
  static final logger = getLogger(
      'ThemeSelectionDialog'); // Logger instance for tracking events in this class
  final ThemeMode themeMode; // The currently selected theme mode
  final WidgetRef
      ref; // Reference to the Riverpod provider for state management

  /// Creates a [ThemeSelectionDialog] with the required parameters.
  const ThemeSelectionDialog({
    super.key,
    required this.themeMode,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    logger.t("Build Method Executing");
    return AlertDialog(
      title: const Text('Choose theme'), // Title of the dialog
      content: Column(
        mainAxisSize: MainAxisSize.min, // Minimize space taken by the column
        children: [
          // Theme option for system default
          ThemeOptionWidget(
            title: 'System default',
            value: ThemeMode.system,
            groupValue: themeMode, // Pass the current theme mode
            ref: ref,
          ),
          // Theme option for light theme
          ThemeOptionWidget(
            title: 'Light',
            value: ThemeMode.light,
            groupValue: themeMode, // Pass the current theme mode
            ref: ref,
          ),
          // Theme option for dark theme
          ThemeOptionWidget(
            title: 'Dark',
            value: ThemeMode.dark,
            groupValue: themeMode, // Pass the current theme mode
            ref: ref,
          ),
        ],
      ),
      actions: [
        // Close button to dismiss the dialog
        TextButton(
          child: const Text("Close"), // Text displayed on the button
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            logger.i("Theme selection dialog closed by clicking close button");
          },
        ),
      ],
    );
  }
}
