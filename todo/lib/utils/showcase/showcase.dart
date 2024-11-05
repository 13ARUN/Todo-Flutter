import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:todo/pages/todo_main_page/todo_main_page.dart';

Future<void> checkFirstLaunch(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    // Show the showcase view only on the first launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        TodoMainPage.addTaskKey,
        TodoMainPage.allTasksKey,
        TodoMainPage.refreshTasksKey,
        TodoMainPage.popupMenuKey,
      ]);
    });

    // Update the preference to indicate that the showcase has been shown
    await prefs.setBool('isFirstLaunch', false);
  }
}
