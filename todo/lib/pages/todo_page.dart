import 'package:flutter/material.dart';
import 'package:todo/pages/taskinput_page.dart';
import 'package:todo/widgets/taskcard.dart';

class Todopage extends StatefulWidget {
  const Todopage({super.key});

  @override
  State<Todopage> createState() => TodopageState();
}

class TodopageState extends State<Todopage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskInput(action: 'add',),
            ),
          );
        },
        splashColor: Theme.of(context).colorScheme.onSecondaryFixed,
        child: const Icon(Icons.add),
      ),
      body: const TaskCard(),
    );
  }
}
