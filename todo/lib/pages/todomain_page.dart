import 'package:flutter/material.dart';

import 'package:todo/models/task_model.dart';
import 'package:todo/pages/taskinput_page.dart';
import 'package:todo/widgets/tasklist.dart';

class TodoMainPage extends StatefulWidget {
  const TodoMainPage({super.key});

  @override
  State<TodoMainPage> createState() => TodoMainPageState();
}

class TodoMainPageState extends State<TodoMainPage> {

  final List<TaskModel> _tasks = [];

  void _showSnackBar(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(text),
        action: action, // Optional action parameter
      ),
    );
  }

  void _addTask(TaskModel task) {
    setState(() {
      _tasks.add(task);
    });
    _showSnackBar('${task.title} added!');
  }

  void _removeTask(TaskModel task) {
    final taskIndex = _tasks.indexOf(task);
    setState(() {
      _tasks.remove(task);
    });
    _showSnackBar(
      'Task Deleted',
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _tasks.insert(taskIndex, task);
          });
        },
      ),
    );
  }

  void _editTask(TaskModel editedTask) {
    final taskIndex = _tasks.indexWhere((task) => task.id == editedTask.id);
    if (taskIndex >= 0) {
      setState(() {
        _tasks[taskIndex] = editedTask;
      });
      _showSnackBar('Task Updated');
    } else {
      _showSnackBar('Task not found');
    }
  }

  void _toggleTaskCompletion(TaskModel task, bool isCompleted) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          date: task.date,
          isCompleted: isCompleted, // Update completion status
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget pageContent = const Center(
      child: Text('No Tasks Found!'),
    );

    if (_tasks.isNotEmpty) {
      pageContent = TaskList(
        tasklist: _tasks,
        onDeleteTask: _removeTask,
        onEditTask: _editTask,
        onToggleCompleteTask: _toggleTaskCompletion,
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
              builder: (context) => const TaskInput(action: 'add'),
            ),
          );

          if (newTask != null) {
            _addTask(newTask);
          }
        },
        splashColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add),
      ),
      body: pageContent,
    );
  }
}
