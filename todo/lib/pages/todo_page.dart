import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/pages/taskinput_page.dart';
import 'package:todo/widgets/tasklist.dart';

class Todopage extends StatefulWidget {
  const Todopage({super.key});

  @override
  State<Todopage> createState() => TodopageState();
}

class TodopageState extends State<Todopage> {
  final List<TaskModel> _tasks = [];

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(text),
      ),
    );
  }

  void _addTask(TaskModel task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _removeTask(TaskModel task) {
    final taskIndex = _tasks.indexOf(task);
    setState(() {
      _tasks.remove(task);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Task Deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _tasks.insert(taskIndex, task);
            });
          },
        ),
      ),
    );
  }

  void _editTask(TaskModel editedTask) {
    final taskIndex = _tasks.indexWhere((task) => task.id == editedTask.id);
    // Check if the task exists before updating
    if (taskIndex >= 0) {
      setState(() {
        _tasks[taskIndex] = editedTask; // Update the task in the list
      });
      _showSnackBar('Task Updated');
    } else {
      // Handle case where task wasn't found
      _showSnackBar('Task not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No Tasks Found!'),
    );

    if (_tasks.isNotEmpty) {
      mainContent = TaskList(
        tasklist: _tasks,
        onDeleteTask: _removeTask, // Pass the delete handler
        onEditTask: _editTask, // Pass the edit handler
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('ToDo App'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newTask = await Navigator.push<TaskModel>(
              context,
              MaterialPageRoute(
                builder: (context) => const TaskInput(
                  action: 'add',
                ),
              ),
            );

            if (newTask != null) {
              _addTask(newTask);
              _showSnackBar('${newTask.title} added!');
            }
          },
          splashColor: Theme.of(context).colorScheme.onSecondaryFixed,
          child: const Icon(Icons.add),
        ),
        body: mainContent);
  }
}
