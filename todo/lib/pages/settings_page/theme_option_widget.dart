part of 'settings.dart';

/// A widget representing a single option for selecting a theme.
class ThemeOptionWidget extends StatelessWidget {
  final String title; // The title displayed for the theme option.
  final ThemeMode value; // The theme mode value associated with this option.
  final ThemeMode groupValue; // The currently selected theme mode.
  final WidgetRef
      ref; // Reference to the Riverpod provider for state management.

  /// Creates a [ThemeOptionWidget] with the required parameters.
  const ThemeOptionWidget({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.ref,
  });

  /// Logger instance for tracking events in the ThemeOptionWidget class.
  static final logger = getLogger('ThemeOptionWidget');

  @override
  Widget build(BuildContext context) {
    logger.t("Build Method Executing");
    return RadioListTile<ThemeMode>(
      title: Text(title), // Display the title of the theme option
      value: value, // Set the value for this radio option
      groupValue: groupValue, // Set the currently selected value
      onChanged: (ThemeMode? selectedValue) {
        if (selectedValue != null) {
          logger.i("Theme option changed");
          ref.read(themeProvider.notifier).setThemeMode(
              selectedValue); // Update the theme mode in the provider
          Navigator.pop(context); // Close the dialog after selection
          logger.i("Theme selection dialog closed");
        }
      },
    );
  }
}
