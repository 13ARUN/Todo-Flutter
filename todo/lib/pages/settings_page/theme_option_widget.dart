part of 'settings.dart';

class ThemeOptionWidget extends StatelessWidget {
  final String title;
  final ThemeMode value;
  final ThemeMode groupValue;
  final WidgetRef ref;

  const ThemeOptionWidget({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.ref,
  });

  static final logger = getLogger('ThemeOptionWidget');

  @override
  Widget build(BuildContext context) {
    logger.t("Build Method Executing");
    return RadioListTile<ThemeMode>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: (ThemeMode? selectedValue) {
        if (selectedValue != null) {
          logger.i("Theme option changed");
          ref.read(themeProvider.notifier).setThemeMode(selectedValue);
          Navigator.pop(context);
          logger.i("Theme selection dialog closed");
        }
      },
    );
  }
}
