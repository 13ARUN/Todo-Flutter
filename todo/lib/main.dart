import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/pages/todo_main_page/todo_main_page.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/theme/theme_data.dart';
import 'package:todo/utils/snackbar/snackbar_service.dart';

/// The entry point of the application.
/// It runs the [MyApp] widget within a [ProviderScope] to enable
/// state management using Riverpod.
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// A stateless widget that represents the main application.
/// It extends [ConsumerWidget] to allow the use of Riverpod's
/// dependency injection and state management capabilities.
class MyApp extends ConsumerWidget {
  /// Creates a [MyApp] instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the theme provider to determine the current theme mode.
    final themeMode = ref.watch(themeProvider);

    // Builds the MaterialApp widget with specified properties.
    return MaterialApp(
      title: 'To-Do', // The title of the application.
      debugShowCheckedModeBanner: false, // Disables the debug banner in debug.
      darkTheme: darkTheme, // Sets the dark theme of the application.
      theme: lightTheme, // Sets the light theme of the application.
      themeMode: themeMode, // Current theme mode based on user preference.
      scaffoldMessengerKey:
          SnackbarService.scaffoldMessengerKey, // Key for displaying snackbars.
      home: const TodoMainPage(), // The default home page of the application.
    );
  }
}
