import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/services/logger/logger.dart';
import 'package:todo/services/snackbar/snackbar_service.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static final logger = getLogger('ThemeNotifier');

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  static const String themePrefKey = 'theme_mode';

  ThemeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  void setThemeMode(ThemeMode mode) async {
    logger.t("Executing setThemeMode method");
    logger.d("Previous Theme: $state");
    state = mode;
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

  Future<void> _loadThemeMode() async {
    logger.t("Executing _loadThemeMode method");
    try {
      logger.i("Obtaining locally stored Theme Prefrence");
      final themeIndex =
          await _asyncPrefs.getInt(themePrefKey) ?? ThemeMode.system.index;
      state = ThemeMode.values[themeIndex];
      logger.i("Obtained locally stored Theme Prefrence: $state");
    } catch (e) {
      logger.e("Cannot obtain locally stored Theme Prefrence");
      state = ThemeMode.system;
      logger.i("Theme Prefrence set to default: $state");
      SnackbarService.displaySnackBar('Failed to load theme preference');
    }
  }

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

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
