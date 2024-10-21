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

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: (ThemeMode? selectedValue) {
        if (selectedValue != null) {
          ref.read(themeProvider.notifier).setThemeMode(selectedValue);
          Navigator.pop(context);
        }
      },
    );
  }
}
