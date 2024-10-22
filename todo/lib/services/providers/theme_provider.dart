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
    state = mode;
    try {
      logger.i("Setting Theme Preference to $mode");
      await _asyncPrefs.setInt(themePrefKey, mode.index);
      logger.i("Theme Preference stored locally");
      SnackbarService.showSnackBar('Theme changed to $currentThemeOption');
    } catch (e) {
      logger.e("Theme Preference not set");
      SnackbarService.showSnackBar('Failed to apply theme changes');
    }
  }

  Future<void> _loadThemeMode() async {
    try {
      final themeIndex =
          await _asyncPrefs.getInt(themePrefKey) ?? ThemeMode.system.index;
      logger.i("Obtaining locally stored Theme Prefrence");
      state = ThemeMode.values[themeIndex];
      logger.i("Obtained locally stored Theme Prefrence: $state");
    } catch (e) {
      logger.e("Cannot obtain Theme Prefrence");
      state = ThemeMode.system;
      logger.i("Theme Prefrence set to $state");
      SnackbarService.showSnackBar('Failed to load theme preference');
    }
  }

  String get currentThemeOption {
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
