import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/utils/logger/logger.dart';
import 'package:todo/utils/snackbar/snackbar_service.dart';

/// A [StateNotifier] for managing the application's theme mode.
///
/// This class allows for switching between light, dark, and system default
/// themes. It stores the selected theme preference locally using
/// [SharedPreferences] and provides methods to load and set the theme.
class ThemeNotifier extends StateNotifier<ThemeMode> {
  static final logger = getLogger('ThemeNotifier');

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  static const String themePrefKey = 'theme_mode';

  /// Constructs a [ThemeNotifier] with the initial theme mode set to system
  /// default. It also loads the previously saved theme preference.
  ThemeNotifier() : super(ThemeMode.system) {
    loadThemeMode();
  }

  /// Sets the theme mode and stores the preference locally.
  ///
  /// Parameters:
  /// - [mode]: The [ThemeMode] to be set (light, dark, or system).
  void setThemeMode(ThemeMode mode) async {
    logger.t("Executing setThemeMode method");
    logger.d("Previous Theme: $state");
    state = mode; // Update the state with the new theme mode
    try {
      logger.i("Setting Theme Preference to $mode");
      await _asyncPrefs.setInt(themePrefKey, mode.index);
      logger.d("New Theme preference: $state");
      logger.i("Theme Preference stored locally");
      SnackbarService.displaySnackBar('Theme changed to $currentThemeOption');
    } catch (e) {
      logger.e("Theme Preference not set");
      SnackbarService.displaySnackBar('Failed to apply theme changes');
    }
  }

  /// Loads the theme mode from local storage and sets it as the current state.
  Future<void> loadThemeMode() async {
    logger.t("Executing _loadThemeMode method");
    try {
      logger.i("Obtaining locally stored Theme Preference");
      final themeIndex =
          await _asyncPrefs.getInt(themePrefKey) ?? ThemeMode.system.index;
      state =
          ThemeMode.values[themeIndex]; // Set state based on stored preference
      logger.i("Obtained locally stored Theme Preference: $state");
    } catch (e) {
      logger.e("Cannot obtain locally stored Theme Preference");
      state = ThemeMode.system; // Fallback to system default on error
      logger.i("Theme Preference set to default: $state");
      SnackbarService.displaySnackBar('Failed to load theme preference');
    }
  }

  /// Gets the current theme option as a string representation.
  String get currentThemeOption {
    logger.t("Executing currentThemeOption get method");
    logger.d("Returned Theme: $state");
    switch (state) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
      default:
        return 'System default';
    }
  }
}

/// A [StateNotifierProvider] for [ThemeNotifier] that exposes the current
/// [ThemeMode].
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
