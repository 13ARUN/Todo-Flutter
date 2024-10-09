import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// var kColorScheme = ColorScheme.fromSeed(
//   seedColor: const Color.fromARGB(255, 108, 58, 184),
// );

final kColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 108, 58, 184),
    brightness: Brightness.light);

final kDarkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 108, 58, 184),
    brightness: Brightness.dark);

final ThemeData lightTheme = ThemeData(
  colorScheme: kColorScheme,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: kDarkColorScheme,
);

// final ThemeData lightTheme = ThemeData().copyWith(
//   textTheme: GoogleFonts.poppinsTextTheme(),
//   colorScheme: const ColorScheme.light(),
//   brightness: Brightness.light,
//   appBarTheme: const AppBarTheme().copyWith(
//     backgroundColor: kColorScheme.onPrimaryFixed,
//     foregroundColor: kColorScheme.primaryContainer,
//     toolbarHeight: 65,
//   ),
//   tabBarTheme: TabBarTheme(
//     labelColor: kColorScheme.tertiaryContainer,
//     unselectedLabelColor: Colors.white,
//     indicator: UnderlineTabIndicator(
//       borderSide: BorderSide(
//         color: kColorScheme.tertiaryContainer,
//         width: 3,
//       ),
//     ),
//   ),
//   floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
//     backgroundColor: kColorScheme.onPrimaryContainer,
//     foregroundColor: kColorScheme.primaryContainer,
//   ),
//   checkboxTheme: const CheckboxThemeData().copyWith(
//     fillColor: WidgetStatePropertyAll(kColorScheme.primaryFixedDim),
//     checkColor: WidgetStatePropertyAll(kColorScheme.onPrimaryContainer),
//     side: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2),
//   ),
//   snackBarTheme: const SnackBarThemeData().copyWith(
//     backgroundColor: kColorScheme.inverseSurface,
//     contentTextStyle: TextStyle(color: kColorScheme.onInverseSurface),
//     actionTextColor: kColorScheme.inversePrimary,
//   ),
//   listTileTheme: const ListTileThemeData().copyWith(
//     iconColor: kColorScheme.onPrimaryContainer,
//     tileColor: kColorScheme.surfaceContainerHighest,
//   ),
//   filledButtonTheme: FilledButtonThemeData(
//     style: ButtonStyle(
//       backgroundColor:
//           WidgetStatePropertyAll(kColorScheme.onSecondaryFixedVariant),
//       foregroundColor: WidgetStatePropertyAll(kColorScheme.onPrimary),
//     ),
//   ),
//   popupMenuTheme: const PopupMenuThemeData().copyWith(
//     color: kColorScheme.surfaceContainerHighest,
//   ),
//   inputDecorationTheme: const InputDecorationTheme().copyWith(
//     hintStyle: TextStyle(color: kColorScheme.onSurfaceVariant),
//     suffixIconColor: kColorScheme.onPrimaryFixedVariant,
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: kColorScheme.primaryContainer),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: kColorScheme.primary),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: kColorScheme.error),
//     ),
//     focusedErrorBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: kColorScheme.error),
//     ),
//     errorStyle: TextStyle(color: kColorScheme.error),
//     labelStyle: TextStyle(color: kColorScheme.onPrimaryContainer),
//   ),
//   textSelectionTheme: TextSelectionThemeData(
//     cursorColor: kColorScheme.onPrimaryContainer,
//     selectionColor: kColorScheme.inversePrimary,
//     selectionHandleColor: kColorScheme.onPrimaryContainer,
//   ),
//   datePickerTheme: DatePickerThemeData(
//     todayBorder: BorderSide(color: kColorScheme.error),
//     rangePickerBackgroundColor: kColorScheme.error,
//     todayBackgroundColor: WidgetStatePropertyAll(kColorScheme.primary),
//     todayForegroundColor: WidgetStatePropertyAll(kColorScheme.surfaceBright),
//     headerBackgroundColor: kColorScheme.primaryContainer,
//   ),
//   textButtonTheme: TextButtonThemeData(
//     style: ButtonStyle(
//       foregroundColor: WidgetStatePropertyAll(kColorScheme.onPrimaryContainer),
//     ),
//   ),
// );

// final ThemeData darkTheme = ThemeData.dark().copyWith(
//   textTheme: GoogleFonts.poppinsTextTheme(const TextTheme()),
//   colorScheme: const ColorScheme.dark(),
//   brightness: Brightness.dark,
//   appBarTheme: const AppBarTheme().copyWith(
//     backgroundColor: kColorScheme.onPrimaryFixed,
//     foregroundColor: kColorScheme.primaryContainer,
//   ),
//   tabBarTheme: TabBarTheme(
//       labelColor: kColorScheme.tertiaryContainer,
//       unselectedLabelColor: Colors.white,
//       indicator: UnderlineTabIndicator(
//         borderSide: BorderSide(
//           color: kColorScheme.tertiaryContainer,
//           width: 3,
//         ),
//       ),
//       dividerColor: kColorScheme.inverseSurface),
//   floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
//     backgroundColor: kColorScheme.inversePrimary,
//     foregroundColor: kColorScheme.onPrimaryContainer,
//   ),
//   listTileTheme: const ListTileThemeData().copyWith(
//     iconColor: kColorScheme.inversePrimary,
//     tileColor: kColorScheme.onSurface,
//   ),
//   checkboxTheme: const CheckboxThemeData().copyWith(
//     fillColor: WidgetStatePropertyAll(kColorScheme.primaryContainer),
//     checkColor: WidgetStatePropertyAll(kColorScheme.onPrimaryContainer),
//     side: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2),
//   ),
//   popupMenuTheme: const PopupMenuThemeData().copyWith(
//     color: kColorScheme.onSurface,
//   ),
//   inputDecorationTheme: const InputDecorationTheme().copyWith(
//     suffixIconColor: kColorScheme.primaryContainer,
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: kColorScheme.surfaceContainerHighest),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: kColorScheme.primary),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: kColorScheme.error),
//     ),
//     focusedErrorBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: kColorScheme.error),
//     ),
//     errorStyle: TextStyle(color: kColorScheme.error),
//     labelStyle: TextStyle(color: kColorScheme.surfaceContainerLow),
//   ),
//   snackBarTheme: const SnackBarThemeData().copyWith(
//     backgroundColor: kColorScheme.inverseSurface,
//     contentTextStyle: TextStyle(color: kColorScheme.onInverseSurface),
//     actionTextColor: kColorScheme.inversePrimary,
//   ),
//   filledButtonTheme: FilledButtonThemeData(
//     style: ButtonStyle(
//       backgroundColor:
//           WidgetStatePropertyAll(kColorScheme.onSecondaryFixedVariant),
//       foregroundColor: WidgetStatePropertyAll(kColorScheme.onPrimary),
//     ),
//   ),
//   textSelectionTheme: TextSelectionThemeData(
//     cursorColor: kColorScheme.primaryFixedDim,
//     selectionColor: kColorScheme.primaryContainer.withOpacity(0.5),
//     selectionHandleColor: kColorScheme.primaryContainer,
//   ),
//   datePickerTheme: DatePickerThemeData(
//     todayBackgroundColor: WidgetStatePropertyAll(kColorScheme.inversePrimary),
//     todayForegroundColor: WidgetStatePropertyAll(kColorScheme.onSurface),
//     headerBackgroundColor: kColorScheme.onPrimaryContainer,
//   ),
//   textButtonTheme: TextButtonThemeData(
//     style: ButtonStyle(
//       foregroundColor: WidgetStatePropertyAll(kColorScheme.inversePrimary),
//     ),
//   ),
// );
