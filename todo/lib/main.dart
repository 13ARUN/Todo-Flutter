import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/pages/todo_main_page/todo_main_page.dart';
import 'package:todo/theme/theme_data.dart';
import 'package:todo/services/providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'To-Do',
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: themeMode,
      home: const TodoMainPage(),
    );
  }
}
