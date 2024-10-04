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

  Future<void> _loadTasks() async {
    final tasks = await _db.getTasks();
    setState(() {
      _tasks = tasks;
    });
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
    await _db.addTask(task);
    setState(() {
      _tasks.add(task);
    });
    _showSnackBar('${task.title} added!');
  }

  //* Delete Task
  void _deleteTask(TaskModel task) async {
    _deletedTasksBackup.add(task);
    await _db.deleteTask(task.id);
    final taskIndex = _tasks.indexOf(task);
    setState(() {
      _tasks.removeAt(taskIndex);
    });

    _showSnackBar(
      'Task Deleted',
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          setState(() {
            _tasks.insert(taskIndex, task);
          });
          await _db.addTask(task);
        },
      ),
    );
  }

  //* Edit Task
  void _editTask(TaskModel editedTask) async {
    await _db.updateTask(editedTask);
    final taskIndex = _tasks.indexWhere((t) => t.id == editedTask.id);
    setState(() {
      _tasks[taskIndex] = editedTask;
    });
    _showSnackBar('Task Updated');
  }

  //* Toggle Status
  void _toggleTaskCompletion(TaskModel task) async {
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
    _deletedTasksBackup = List.from(_tasks);
    await _db.deleteTasks();
    setState(() {
      _tasks.clear();
    });

    _showSnackBar(
      'All tasks deleted',
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          setState(() {
            _tasks.addAll(_deletedTasksBackup);
          });
          for (var task in _deletedTasksBackup) {
            await _db.addTask(task);
          }
        },
      ),
    );
  }

  //* Delete completed Tasks
  void _deleteCompletedTasks() async {
    await _db.deleteTasks(completed: true);
    setState(() {
      _tasks.removeWhere((task) => task.isCompleted);
    });

    _showSnackBar(
      'Completed tasks deleted',
    );
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
        body: TabBarView(
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
    );
  }

  AppBar buildAppBar() {
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
      bottom: const TabBar(
        tabs: [
          Tab(
            child: Text('All'),
          ),
          Tab(
            child: Text('In Progress'),
          ),
          Tab(
            child: Text('Completed'),
          ),
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
            builder: (context) => const TaskInput(action: 'add'),
          ),
        );

        if (newTask != null) {
          _addTask(newTask);
        }
      },
      shape: const CircleBorder(eccentricity: 1),
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
    final inProgressTasks = _tasks.where((task) => !task.isCompleted).toList();
    final isEmpty = _tasks.isEmpty;
    final isInProgressEmpty = inProgressTasks.isEmpty;

    String imagePath = isEmpty
        ? 'assets/images/notask.png'
        : isInProgressEmpty
            ? 'assets/images/noInprogress.png'
            : 'assets/images/noCompleted.png';

    String message = isEmpty
        ? "Click on the + icon to create a new task!"
        : isInProgressEmpty
            ? "You have no tasks in progress!"
            : "You haven't completed any tasks!";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 250,
          width: 200,
          child: Image.asset(imagePath),
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
