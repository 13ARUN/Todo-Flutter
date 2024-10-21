part of 'settings.dart';

class ThemeSelectionDialog extends StatelessWidget {
  final ThemeMode themeMode;
  final WidgetRef ref;

  const ThemeSelectionDialog({
    super.key,
    required this.themeMode,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThemeOptionWidget(
            title: 'System default',
            value: ThemeMode.system,
            groupValue: themeMode,
            ref: ref,
          ),
          ThemeOptionWidget(
            title: 'Light',
            value: ThemeMode.light,
            groupValue: themeMode,
            ref: ref,
          ),
          ThemeOptionWidget(
            title: 'Dark',
            value: ThemeMode.dark,
            groupValue: themeMode,
            ref: ref,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Close"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
