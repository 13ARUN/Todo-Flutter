import 'package:flutter/material.dart';
import 'package:todo/pages/todo_main_page.dart';
import 'package:todo/theme/theme_data.dart';

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
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: ThemeMode.system,
      home: const TodoMainPage(),
    );
  }
}
