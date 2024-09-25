import 'package:flutter/material.dart';
import 'package:todo/pages/todomain_page.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 156, 86, 237),
);

// var kDarkColorScheme = ColorScheme.fromSeed(
//   seedColor: const Color.fromARGB(255, 34, 62, 165),
// );

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryFixed,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kColorScheme.inversePrimary,
        ),
        listTileTheme: ListTileThemeData(
          iconColor: kColorScheme.surfaceBright,
          tileColor: kColorScheme.onSurface,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: kColorScheme.onSurface,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(kColorScheme.onSecondaryFixedVariant),
            foregroundColor: WidgetStatePropertyAll(kColorScheme.onPrimary),
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: const ColorScheme.light(),
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryFixed,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kColorScheme.onPrimaryFixedVariant,
        ),
        checkboxTheme: const CheckboxThemeData().copyWith(
          checkColor: WidgetStatePropertyAll(kColorScheme.onPrimary),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: kColorScheme.onPrimaryContainer,
        ),
        listTileTheme: ListTileThemeData(
            iconColor: kColorScheme.onPrimaryContainer,
            tileColor: kColorScheme.surfaceContainerHighest),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(kColorScheme.onSecondaryFixedVariant),
            foregroundColor: WidgetStatePropertyAll(kColorScheme.onPrimary),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: kColorScheme.surfaceContainerHighest,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const TodoMainPage(),
    );
  }
}
