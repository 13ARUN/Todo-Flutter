import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 113, 58, 184),
);

final ThemeData lightTheme = ThemeData().copyWith(
  colorScheme: const ColorScheme.light(),
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.onPrimaryFixed,
    foregroundColor: kColorScheme.primaryContainer,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
    backgroundColor: kColorScheme.onPrimaryContainer,
  ),
  checkboxTheme: const CheckboxThemeData().copyWith(
    fillColor: WidgetStatePropertyAll(kColorScheme.primaryFixedDim),
    checkColor: WidgetStatePropertyAll(kColorScheme.onPrimaryContainer),
    side: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2),
  ),
  snackBarTheme: const SnackBarThemeData().copyWith(
    backgroundColor: kColorScheme.primaryFixedDim,
    contentTextStyle: TextStyle(color: kColorScheme.onPrimaryContainer),
    actionTextColor: kColorScheme.onSurface,
  ),
  listTileTheme: const ListTileThemeData().copyWith(
    iconColor: kColorScheme.onPrimaryContainer,
    tileColor: kColorScheme.surfaceContainerHighest,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          WidgetStatePropertyAll(kColorScheme.onSecondaryFixedVariant),
      foregroundColor: WidgetStatePropertyAll(kColorScheme.onPrimary),
    ),
  ),
  popupMenuTheme: const PopupMenuThemeData().copyWith(
    color: kColorScheme.surfaceContainerHighest,
  ),
  inputDecorationTheme: const InputDecorationTheme().copyWith(
    hintStyle: TextStyle(color: kColorScheme.onSurfaceVariant),
    suffixIconColor: kColorScheme.onPrimaryFixedVariant,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kColorScheme.primaryContainer),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kColorScheme.primary),
    ),
    labelStyle: TextStyle(color: kColorScheme.onPrimaryContainer),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kColorScheme.onPrimaryContainer,
    selectionColor: kColorScheme.inversePrimary,
    selectionHandleColor: kColorScheme.primaryContainer,
  ),
  datePickerTheme: DatePickerThemeData(
    todayBackgroundColor:
        WidgetStatePropertyAll(kColorScheme.onPrimaryContainer),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
        foregroundColor:
            WidgetStatePropertyAll(kColorScheme.onPrimaryContainer)),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.dark(),
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.onPrimaryFixed,
    foregroundColor: kColorScheme.primaryContainer,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
    backgroundColor: kColorScheme.inversePrimary,
  ),
  listTileTheme: const ListTileThemeData().copyWith(
    iconColor: kColorScheme.inversePrimary,
    tileColor: kColorScheme.onSurface,
  ),
  checkboxTheme: const CheckboxThemeData().copyWith(
    fillColor: WidgetStatePropertyAll(kColorScheme.primaryContainer),
    checkColor: WidgetStatePropertyAll(kColorScheme.onPrimaryContainer),
    side: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2),
  ),
  popupMenuTheme: const PopupMenuThemeData().copyWith(
    color: kColorScheme.onSurface,
  ),
  inputDecorationTheme: const InputDecorationTheme().copyWith(
    suffixIconColor: kColorScheme.primaryContainer,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kColorScheme.surfaceContainerHighest),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kColorScheme.primary),
    ),
    labelStyle: TextStyle(color: kColorScheme.surfaceContainerLow),
  ),
  snackBarTheme: const SnackBarThemeData().copyWith(
    backgroundColor: kColorScheme.onPrimaryFixedVariant,
    contentTextStyle: TextStyle(color: kColorScheme.surfaceBright),
    actionTextColor: kColorScheme.surfaceContainerLowest,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          WidgetStatePropertyAll(kColorScheme.onSecondaryFixedVariant),
      foregroundColor: WidgetStatePropertyAll(kColorScheme.onPrimary),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kColorScheme.primaryFixedDim,
    selectionColor: kColorScheme.primaryContainer.withOpacity(0.5),
    selectionHandleColor: kColorScheme.primaryContainer,
  ),
  datePickerTheme: DatePickerThemeData(
    todayBackgroundColor: WidgetStatePropertyAll(kColorScheme.inversePrimary),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(kColorScheme.inversePrimary)),
  ),
);
