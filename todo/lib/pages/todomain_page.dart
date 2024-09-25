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
  List<TaskModel> _deletedTasksBackup = [];

  //* Snackbar
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

  //* Add Task
  void _addTask(TaskModel task) {
    setState(() {
      _tasks.add(task);
    });
    _showSnackBar('${task.title} added!');
  }

  //* Delete Task
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

  //* Edit Task
  void _editTask(TaskModel editedTask) {
    final taskIndex = _tasks.indexWhere((t) => t.id == editedTask.id);
    if (taskIndex != -1) {
      setState(() {
        _tasks[taskIndex] = editedTask;
      });
      _showSnackBar('Task Updated');
    } else {
      _showSnackBar('Task not found');
    }
  }

  //* Toggle Status
  void _toggleTaskCompletion(TaskModel task, bool isCompleted) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          date: task.date,
          isCompleted: isCompleted,
        );
      }
    });
  }

  //* Delete all Tasks Confirmation
  Future<void> _confirmDeleteAll() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete All'),
        content: const Text(
            'Are you sure you want to delete all tasks? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false); // Cancel deletion
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true); // Confirm deletion
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      _deleteAllTasks();
    }
  }

  //* Delete all Tasks
  void _deleteAllTasks() {
    setState(() {
      _deletedTasksBackup = List.from(_tasks); // Backup tasks in case of undo
      _tasks.clear();
      Navigator.pop(context);
    });
    _showSnackBar(
      'All tasks deleted',
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _tasks.addAll(_deletedTasksBackup); // Restore tasks from backup
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget pageContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 250,
          width: 200,
          child: Image.asset('assets/images/notask.png'),
        ),
        const Center(
          child: Text(
            "Click on + icon to create a new task!",
            textScaler: TextScaler.linear(1.2),
          ),
        )
      ],
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
        title: const Text('Task Manager'),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              if (_tasks.isNotEmpty)
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete all'),
                    onTap: _tasks.isNotEmpty
                        ? () {
                            _confirmDeleteAll();
                          }
                        : null,
                  ),
                ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          )
        ],
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
        shape: const CircleBorder(eccentricity: 1),
        child: const Icon(Icons.add),
      ),
      body: pageContent,
    );
  }
}
