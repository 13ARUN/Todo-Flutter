import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/pages/taskinput_page.dart';
import 'package:todo/services/database.dart';
import 'package:todo/widgets/tasklist.dart';

class TodoMainPage extends StatefulWidget {
  const TodoMainPage({super.key});

  @override
  State<TodoMainPage> createState() => _TodoMainPageState();
}

class _TodoMainPageState extends State<TodoMainPage> {
  final DataBase _db = DataBase();
  List<TaskModel> _tasks = [];
  List<TaskModel> _deletedTasksBackup = [];
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _db.getTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (e) {
      _showSnackBar('Failed to load tasks');
      debugPrint('Error: $e');
    }
  }

  //* Snackbar
  void _showSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(message),
        action: action,
      ),
    );
  }

  //* Add Task
  void _addTask(TaskModel task) async {
    try {
      await _db.addTask(task);
      await _loadTasks();
      _showSnackBar('${task.title} added!');
    } catch (e) {
      _showSnackBar('Failed to add task');
      debugPrint('Error: $e');
    }
  }

  //* Delete Task
  void _deleteTask(TaskModel task) async {
    try {
      await _db.deleteTask(task.id);
      await _loadTasks();

      _showSnackBar(
        'Task Deleted',
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            try {
              await _db.addTask(task);
              _loadTasks();
            } catch (e) {
              _showSnackBar('Failed to undo task deletion');
              debugPrint('Error: $e');
            }
          },
        ),
      );
    } catch (e) {
      _showSnackBar('Failed to delete task');
      debugPrint('Error: $e');
    }
  }

  //* Edit Task
  void _editTask(TaskModel editedTask) async {
    try {
      await _db.updateTask(editedTask);
      await _loadTasks();
      _showSnackBar('Task Updated');
    } catch (e) {
      _showSnackBar('Failed to update task');
      debugPrint('Error: $e');
    }
  }

  //* Toggle Status
  void _toggleTaskCompletion(TaskModel task) async {
    try {
      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        date: task.date,
        isCompleted: !task.isCompleted,
      );

      await _db.updateTask(updatedTask);

      setState(() {
        final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
        if (taskIndex != -1) {
          _tasks[taskIndex] = updatedTask;
        }
      });
    } catch (e) {
      _showSnackBar('Failed to update task status');
      debugPrint('Error: $e');
    }
  }

  //* Delete all Tasks Confirmation
  Future<void> _confirmDelete(String action) async {
    final bool isDeleteAll = (action == "all");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            isDeleteAll ? "Confirm Delete All" : "Confirm Delete Completed"),
        content: Text(isDeleteAll
            ? "Are you sure you want to delete all tasks?"
            : "Are you sure you want to delete all completed tasks? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              isDeleteAll ? _deleteAllTasks() : _deleteCompletedTasks();
              Navigator.pop(ctx);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  //* Delete all Tasks
  void _deleteAllTasks() async {
    try {
      _deletedTasksBackup = List.from(_tasks);
      await _db.deleteTasks();
      await _loadTasks();

      _showSnackBar(
        'All tasks deleted',
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            try {
              for (var task in _deletedTasksBackup) {
                await _db.addTask(task);
              }
              await _loadTasks();
              _showSnackBar('Tasks restored');
            } catch (e) {
              _showSnackBar('Failed to restore tasks');
              debugPrint('Error: $e');
            }
          },
        ),
      );
    } catch (e) {
      _showSnackBar('Failed to delete all tasks');
      debugPrint('Error: $e');
    }
  }

  //* Delete completed Tasks
  void _deleteCompletedTasks() async {
    try {
      await _db.deleteTasks(completed: true);
      await _loadTasks();
      _showSnackBar('Completed tasks deleted');
    } catch (e) {
      _showSnackBar('Failed to delete completed tasks');
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final inProgressTasks = _tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = _tasks.where((task) => task.isCompleted).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: buildAppBar(),
        floatingActionButton: buildFloatingButton(context),
        body: SafeArea(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              _tasks.isNotEmpty ? tasksView(_tasks) : noTasksView(),
              inProgressTasks.isNotEmpty
                  ? tasksView(inProgressTasks)
                  : noTasksView(),
              completedTasks.isNotEmpty
                  ? tasksView(completedTasks)
                  : noTasksView(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    final width = MediaQuery.of(context).size.width;

    return AppBar(
      title: const Text('Task Manager'),
      titleSpacing: 25,
      actions: [
        PopupMenuButton(
          position: PopupMenuPosition.under,
          itemBuilder: (context) => <PopupMenuItem>[
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
            ),
            if (_tasks.isNotEmpty)
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete all'),
                  onTap: () {
                    _confirmDelete('all');
                  },
                ),
              ),
            if (_tasks.any((task) => task.isCompleted))
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.delete_sweep_rounded),
                  title: const Text('Delete completed'),
                  onTap: () {
                    _confirmDelete('completed');
                  },
                ),
              ),
          ],
        ),
      ],
      bottom: TabBar(
        tabs: [
          Tab(
              icon: width < 600 ? const Icon(Icons.list) : null,
              text: 'All Tasks'),
          Tab(
              icon: width < 600 ? const Icon(Icons.watch_later_outlined) : null,
              text: 'In Progress'),
          Tab(
              icon: width < 600 ? const Icon(Icons.done_all) : null,
              text: 'Completed'),
        ],
      ),
    );
  }

  FloatingActionButton buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
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
        }
      },
      child: const Icon(Icons.add),
    );
  }

  Widget tasksView(List<TaskModel> tasks) {
    return TaskList(
      tasklist: tasks,
      onDeleteTask: _deleteTask,
      onEditTask: _editTask,
      onToggleCompleteTask: _toggleTaskCompletion,
    );
  }

  Widget noTasksView() {
    final isEmpty = _tasks.isEmpty;
    final inProgressTasks = _tasks.where((task) => !task.isCompleted).toList();
    final isInProgressEmpty = inProgressTasks.isEmpty;

    String imageName;
    String message;

    if (isEmpty) {
      imageName = 'notask';
      message = "Click on the + icon to create a new task!";
    } else if (isInProgressEmpty) {
      imageName = 'noInprogress';
      message = "You have no tasks in progress!";
    } else {
      imageName = 'noCompleted';
      message = "You haven't completed any tasks!";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: Image.asset('assets/images/$imageName.png'),
        ),
        Center(
          child: Text(
            message,
            textScaler: const TextScaler.linear(1.2),
          ),
        ),
      ],
    );
  }
}
