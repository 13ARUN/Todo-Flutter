import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/services/api/task_api_service.dart';
import 'package:todo/services/database/database_methods.dart';
import 'package:todo/utils/logger/logger.dart';
import 'package:todo/utils/snackbar/snackbar_service.dart';

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  static final logger = getLogger('TaskNotifier');
  final TaskApiService _apiService = TaskApiService();
  final Dio dio = Dio();
  bool isLoading = true;

  TaskNotifier() : super([]) {
    loadTasksfromAPI();
  }

  final DatabaseMethods _db = DatabaseMethods();

  Future<void> loadTasksfromAPI() async {
    await _db.fetchAndStoreTodos();
    await _loadTasksfromDB();
  }

  Future<void> _loadTasksfromDB() async {
    isLoading = true;
    try {
      logger.i("Loading tasks from database...");
      final tasks = await _db.getTasks();
      logger.i("Tasks loaded successfully: ${tasks.length} tasks found.");
      state = tasks;
    } catch (e) {
      logger.e("Failed to load tasks from database", error: e);
      SnackbarService.displaySnackBar('Failed to load tasks');
    } finally {
      isLoading = false;
    }
  }

  Future<void> addTask(TaskModel task) async {
    logger.i("Adding task to database: ${task.title}");
    try {
      await _apiService.postTodo(task);
      loadTasksfromAPI();
      state = [...state, task];
      logger.i("Task added successfully: $task");
      SnackbarService.displaySnackBar('Task added successfully');
    } catch (e) {
      logger.e("Unable to add the task", error: e);
      SnackbarService.displaySnackBar(
          'Unable to add the task. Please try again.');
    }
  }

  Future<void> deleteTask(String id) async {
    final taskIndex = state.indexWhere((task) => task.id == id);
    if (taskIndex == -1) {
      logger.w("Task with id: $id not found for deletion.");
      return;
    }

    final taskBackup = state[taskIndex];
    final newState = List<TaskModel>.from(state)..removeAt(taskIndex);
    state = newState;

    logger.i("Deleting task with id: $id");
    try {
      await _apiService.deleteTodo(id);
      loadTasksfromAPI();
      logger.i("Task deleted successfully: $id");
      SnackbarService.displaySnackBar(
        'Task deleted successfully',
        actionLabel: 'Undo',
        onActionPressed: () async {
          try {
            final updatedState = List<TaskModel>.from(state)
              ..insert(taskIndex, taskBackup);
            state = updatedState;
            await _apiService.postTodo(taskBackup);
            loadTasksfromAPI();
            logger.i("Restored deleted task: $taskBackup");
            SnackbarService.displaySnackBar('Deleted task restored');
          } catch (e) {
            logger.e("Failed to restore deleted task", error: e);
          }
        },
      );
    } catch (e) {
      logger.e("Unable to delete task with id: $id", error: e);
      SnackbarService.displaySnackBar(
          'Unable to delete this task. Please try again.');
      state = [...state, taskBackup];
    }
  }

  Future<void> editTask(TaskModel editedTask) async {
    final taskIndex = state.indexWhere((task) => task.id == editedTask.id);
    if (taskIndex != -1) {
      logger.i("Editing task: $editedTask");
      state[taskIndex] = editedTask;
      try {
        await _apiService.putTodo(editedTask);
        loadTasksfromAPI();
        logger.i("Task edited successfully: $editedTask");
        SnackbarService.displaySnackBar('Task edited successfully');
      } catch (e) {
        logger.e("Unable to edit task: $editedTask", error: e);
        SnackbarService.displaySnackBar(
            'Unable to edit this task. Please try again.');
      }
    } else {
      logger.w("Task with id: ${editedTask.id} not found for editing.");
    }
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    final updatedTask = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      isCompleted: !task.isCompleted,
    );

    final newState = List<TaskModel>.of(state);
    final taskIndex = newState.indexWhere((t) => t.id == task.id);

    if (taskIndex != -1) {
      logger.i("Toggling completion for task: $updatedTask");
      newState[taskIndex] = updatedTask;
      state = newState;

      isLoading = true;
      try {
        await _apiService.putTodo(updatedTask);
        loadTasksfromAPI();
        logger.i("Task updated successfully: $updatedTask");
      } catch (e) {
        logger.e("Error updating task: $updatedTask", error: e);
        SnackbarService.displaySnackBar('Error updating task');
      } finally {
        isLoading = false;
      }
    } else {
      logger.w("Task with id: ${task.id} not found for toggling completion.");
    }
  }

  Future<void> deleteAllTasks() async {
    final tasksBackup = List<TaskModel>.from(state);
    state = [];
    logger.i("Deleting all tasks...");
    isLoading = true;
    try {
      await _apiService.deleteAllTodos(tasksBackup);
      loadTasksfromAPI();
      logger.i("All tasks deleted successfully.");
      SnackbarService.displaySnackBar(
        'All tasks deleted',
        actionLabel: 'Undo',
        onActionPressed: () async {
          isLoading = true;
          try {
            for (var task in tasksBackup) {
              await _apiService.postTodo(task);
            }
            loadTasksfromAPI();
            state = tasksBackup;
            logger.i("Restored all deleted tasks.");
            SnackbarService.displaySnackBar('Deleted tasks restored');
          } catch (e) {
            logger.e("Error restoring tasks", error: e);
          } finally {
            isLoading = false;
          }
        },
      );
    } catch (e) {
      logger.e("Unable to delete all tasks", error: e);
      SnackbarService.displaySnackBar(
          'Unable to delete all tasks. Please try again.');
      state = tasksBackup;
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteCompletedTasks() async {
    final completedTasks = state.where((task) => task.isCompleted).toList();
    state = state.where((task) => !task.isCompleted).toList();

    logger.i(
        "Deleting completed tasks: ${completedTasks.length} tasks to delete.");
    try {
      await _apiService.deleteAllTodos(completedTasks);
      loadTasksfromAPI();
      logger.i("Completed tasks deleted successfully.");
      SnackbarService.displaySnackBar('Completed tasks deleted');
    } catch (e) {
      logger.e("Unable to delete completed tasks", error: e);
      SnackbarService.displaySnackBar(
          'Unable to delete completed tasks. Please try again.');
    }
  }
}

final tasksProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  return TaskNotifier();
});