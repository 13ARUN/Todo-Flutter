import 'package:flutter/material.dart';
import 'package:todo/pages/taskinput_page.dart';
import 'package:todo/widgets/tasklist.dart';
import 'package:todo/models/task_model.dart';

class Todopage extends StatefulWidget {
  const Todopage({super.key});

  @override
  State<Todopage> createState() => TodopageState();
}

class TodopageState extends State<Todopage> {
  final List<TaskModel> _tasks = [
    TaskModel(
      title: 'Title',
      description: 'Description',
      date: DateTime.now(),
    ),
    TaskModel(
      title: 'Title',
      description: 'Description',
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No Tasks Found!'),
    );

    if (_tasks.isNotEmpty) {
      mainContent = TaskList(
        tasklist: _tasks,
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('ToDo App'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TaskInput(
                  action: 'add',
                ),
              ),
            );
          },
          splashColor: Theme.of(context).colorScheme.onSecondaryFixed,
          child: const Icon(Icons.add),
        ),
        body: mainContent);
  }
}
