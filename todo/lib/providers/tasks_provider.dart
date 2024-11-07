import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/services/api/task_api_service.dart';
import 'package:todo/services/database/database_methods.dart';
import 'package:todo/utils/logger/logger.dart';
import 'package:todo/utils/snackbar/snackbar_service.dart';

/// A [StateNotifier] for managing a list of tasks.
///
/// This class handles all operations related to tasks, including
/// loading tasks from an API, adding, deleting, editing tasks,
/// and managing task completion status. It also interacts with
/// local storage via [DatabaseMethods] and remote storage via
/// [TaskApiService].
class TaskNotifier extends StateNotifier<List<TaskModel>> {
  static final logger = getLogger('TaskNotifier');
  final TaskApiService _apiService = TaskApiService();
  final Dio dio = Dio();
  bool isLoading = true;

  /// Constructs a [TaskNotifier] and initializes the task list
  /// by loading tasks from the API.
  TaskNotifier() : super([]) {
    loadTasksfromAPI();
  }

  final DatabaseMethods _db = DatabaseMethods();

  /// Loads tasks from the API and stores them in the local database.
  Future<void> loadTasksfromAPI() async {
    await _db.fetchAndStoreTodos(); // Fetch and store tasks
    await _loadTasksfromDB(); // Load tasks from local DB
  }

  /// Loads tasks from the local database and updates the state.
  Future<void> _loadTasksfromDB() async {
    isLoading = true;
    try {
      logger.i("Loading tasks from database...");
      final tasks = await _db.getTasks(); // Get tasks from DB
      logger.i("Tasks loaded successfully: ${tasks.length} tasks found.");
      state = tasks; // Update state with the loaded tasks
    } catch (e) {
      logger.e("Failed to load tasks from database", error: e);
      SnackbarService.displaySnackBar('Failed to load tasks');
    } finally {
      isLoading = false; // Loading finished
    }
  }

  /// Adds a new task to the database and updates the state.
  ///
  /// Parameters:
  /// - [task]: The [TaskModel] instance representing the task to be added.
  Future<void> addTask(TaskModel task) async {
    logger.i("Adding task to database: ${task.title}");
    try {
      await _apiService.postTodo(task); // Post task to API
      loadTasksfromAPI(); // Reload tasks
      state = [...state, task]; // Add task to state
      logger.i("Task added successfully: $task");
      SnackbarService.displaySnackBar('Task added successfully');
    } catch (e) {
      logger.e("Unable to add the task", error: e);
      SnackbarService.displaySnackBar(
          'Unable to add the task. Please try again.');
    }
  }

  /// Deletes a task by its ID and updates the state.
  ///
  /// Parameters:
  /// - [id]: The ID of the task to be deleted.
  Future<void> deleteTask(String id) async {
    final taskIndex = state.indexWhere((task) => task.id == id);
    if (taskIndex == -1) {
      logger.w("Task with id: $id not found for deletion.");
      return;
    }

    final taskBackup = state[taskIndex]; // Backup the task for undo
    final newState = List<TaskModel>.from(state)..removeAt(taskIndex);
    state = newState; // Update state

    logger.i("Deleting task with id: $id");
    try {
      await _apiService.deleteTodo(id); // Delete task from API
      loadTasksfromAPI(); // Reload tasks
      logger.i("Task deleted successfully: $id");
      SnackbarService.displaySnackBar(
        'Task deleted successfully',
        actionLabel: 'Undo',
        onActionPressed: () async {
          try {
            final updatedState = List<TaskModel>.from(state)
              ..insert(taskIndex, taskBackup); // Restore the task
            state = updatedState;
            await _apiService.postTodo(taskBackup); // Post restored task
            loadTasksfromAPI(); // Reload tasks
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
      state = [...state, taskBackup]; // Restore task in state
    }
  }

  /// Edits an existing task in the state and updates the database.
  ///
  /// Parameters:
  /// - [editedTask]: The [TaskModel] instance with updated information.
  Future<void> editTask(TaskModel editedTask) async {
    final taskIndex = state.indexWhere((task) => task.id == editedTask.id);
    if (taskIndex != -1) {
      logger.i("Editing task: $editedTask");
      state[taskIndex] = editedTask; // Update the task in state
      try {
        await _apiService.putTodo(editedTask); // Update task in API
        loadTasksfromAPI(); // Reload tasks
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

  /// Toggles the completion status of a task and updates the database.
  ///
  /// Parameters:
  /// - [task]: The [TaskModel] instance whose completion status is to be toggled.
  Future<void> toggleTaskCompletion(TaskModel task) async {
    final updatedTask = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      isCompleted: !task.isCompleted, // Toggle completion status
    );

    final newState = List<TaskModel>.of(state);
    final taskIndex = newState.indexWhere((t) => t.id == task.id);

    if (taskIndex != -1) {
      logger.i("Toggling completion for task: $updatedTask");
      newState[taskIndex] = updatedTask; // Update state
      state = newState;

      isLoading = true;
      try {
        await _apiService.putTodo(updatedTask); // Update task in API
        loadTasksfromAPI(); // Reload tasks
        logger.i("Task updated successfully: $updatedTask");
      } catch (e) {
        logger.e("Error updating task: $updatedTask", error: e);
        SnackbarService.displaySnackBar('Error updating task');
      } finally {
        isLoading = false; // Loading finished
      }
    } else {
      logger.w("Task with id: ${task.id} not found for toggling completion.");
    }
  }

  /// Deletes all tasks and provides an option to undo the action.
  Future<void> deleteAllTasks() async {
    final tasksBackup = List<TaskModel>.from(state); // Backup tasks
    state = []; // Clear state
    logger.i("Deleting all tasks...");
    isLoading = true;
    try {
      await _apiService
          .deleteAllTodos(tasksBackup); // Delete all tasks from API
      loadTasksfromAPI(); // Reload tasks
      logger.i("All tasks deleted successfully.");
      SnackbarService.displaySnackBar(
        'All tasks deleted',
        actionLabel: 'Undo',
        onActionPressed: () async {
          isLoading = true;
          try {
            for (var task in tasksBackup) {
              await _apiService.postTodo(task); // Restore tasks in API
            }
            loadTasksfromAPI(); // Reload tasks
            state = tasksBackup; // Restore state
            logger.i("Restored all deleted tasks.");
            SnackbarService.displaySnackBar('Deleted tasks restored');
          } catch (e) {
            logger.e("Error restoring tasks", error: e);
          } finally {
            isLoading = false; // Loading finished
          }
        },
      );
    } catch (e) {
      logger.e("Unable to delete all tasks", error: e);
      SnackbarService.displaySnackBar(
          'Unable to delete all tasks. Please try again.');
      state = tasksBackup; // Restore state on error
    } finally {
      isLoading = false; // Loading finished
    }
  }

  /// Deletes all completed tasks from the state and the database.
  Future<void> deleteCompletedTasks() async {
    final completedTasks = state.where((task) => task.isCompleted).toList();
    state = state.where((task) => !task.isCompleted).toList(); // Update state

    logger.i(
        "Deleting completed tasks: ${completedTasks.length} tasks to delete.");
    try {
      await _apiService
          .deleteAllTodos(completedTasks); // Delete completed tasks from API
      loadTasksfromAPI(); // Reload tasks
      logger.i("Completed tasks deleted successfully.");
      SnackbarService.displaySnackBar('Completed tasks deleted');
    } catch (e) {
      logger.e("Unable to delete completed tasks", error: e);
      SnackbarService.displaySnackBar(
          'Unable to delete completed tasks. Please try again.');
    }
  }
}

/// A [StateNotifierProvider] for [TaskNotifier] that exposes the
/// current list of [TaskModel].
final tasksProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  return TaskNotifier();
});
