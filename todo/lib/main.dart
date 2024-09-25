import 'package:flutter/material.dart';
import 'package:todo/pages/todomain_page.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 138, 113, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 34, 255, 0),
);

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
        colorScheme: kDarkColorScheme,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kDarkColorScheme.onPrimaryContainer,
          foregroundColor: kDarkColorScheme.primaryContainer,
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.onPrimary,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kColorScheme.inversePrimary,
        ),
        checkboxTheme: const CheckboxThemeData().copyWith(
          checkColor: WidgetStatePropertyAll(kColorScheme.onPrimary),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: kColorScheme.onPrimaryContainer,
          actionTextColor: kColorScheme.onPrimary,
        ),
        listTileTheme: ListTileThemeData(
            iconColor: kColorScheme.onPrimaryContainer,
            tileColor: kColorScheme.surfaceContainerHigh),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(kColorScheme.onPrimaryContainer),
            foregroundColor:
                WidgetStatePropertyAll(kColorScheme.onPrimary),
          ),
        ),
      ),
      themeMode: ThemeMode.light,
      home: const TodoMainPage(),
    );
  }
}
