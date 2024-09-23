import 'package:flutter/material.dart';
import 'package:todo/pages/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 156, 58, 183)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      color: Colors.indigo,
      home: const Todopage(),
    );
  }
}


