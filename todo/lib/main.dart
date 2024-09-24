import 'package:flutter/material.dart';
import 'package:todo/pages/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'To-Do',
      debugShowCheckedModeBanner: false,
      color: Colors.indigo,
      home: Todopage(),
    );
  }
}
