import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:todo/pages/todo_main_page/todo_main_page.dart';

/// Checks if this is the first launch of the app, showing a showcase tutorial if true.
///
/// This function uses [SharedPreferences] to store whether the showcase has already
/// been displayed. On the first launch, it will display a showcase view tutorial
/// for guiding the user through the app's main features.
Future<void> checkFirstLaunch(BuildContext context) async {
  // Access shared preferences for persistent storage.
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the value indicating if this is the first launch.
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  // bool isFirstLaunch = true;

  if (isFirstLaunch) {
    // Show the showcase tutorial only on the first launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        TodoMainPage.addTaskKey, // Key for the 'Add Task' button
        TodoMainPage.allTasksKey, // Key for the 'All Tasks' section
        TodoMainPage.refreshTasksKey, // Key for the 'Refresh' button
        TodoMainPage.popupMenuKey, // Key for the 'Popup Menu' button
      ]);
    });

    // Update the preference to indicate that the showcase has been shown
    await prefs.setBool('isFirstLaunch', false);
  }
}
