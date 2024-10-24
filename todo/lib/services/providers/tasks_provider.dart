import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/services/database/database_methods.dart';
import 'package:todo/utils/logger/logger.dart';
import 'package:todo/utils/snackbar/snackbar_service.dart';

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  static final logger = getLogger('TaskNotifier');

  TaskNotifier() : super([]) {
    _loadTasks();
  }

  final DatabaseMethods _db = DatabaseMethods();

  Future<void> _loadTasks() async {
    try {
      logger.i("Loading tasks from database...");
      final tasks = await _db.getTasks();
      logger.i("Tasks loaded successfully: ${tasks.length} tasks found.");
      state = tasks;
    } catch (e) {
      logger.e("Failed to load tasks from database", error: e);
      SnackbarService.displaySnackBar('Failed to load tasks');
    }
  }

  Future<void> addTask(TaskModel task) async {
    logger.i("Adding task to database: ${task.title}");
    try {
      await _db.addTask(task);
      state = [...state, task];
      logger.i("Task added successfully: $task");
      SnackbarService.displaySnackBar('Task added successfully');
    } catch (e) {
      logger.e("Unable to add the task", error: e);
      SnackbarService.displaySnackBar('Unable to add the task. Please try again.');
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
      await _db.deleteTask(id);
      logger.i("Task deleted successfully: $id");
      SnackbarService.displaySnackBar(
        'Task deleted successfully',
        actionLabel: 'Undo',
        onActionPressed: () async {
          try {
            final updatedState = List<TaskModel>.from(state)
              ..insert(taskIndex, taskBackup);
            state = updatedState;

            await _db.addTask(taskBackup);
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
      state = [...state, taskBackup]; // Restore state on failure
    }
  }

  Future<void> editTask(TaskModel editedTask) async {
    final taskIndex = state.indexWhere((task) => task.id == editedTask.id);
    if (taskIndex != -1) {
      logger.i("Editing task: $editedTask");
      state[taskIndex] = editedTask;
      try {
        await _db.updateTask(editedTask);
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

      try {
        await _db.updateTask(updatedTask);
        logger.i("Task updated successfully: $updatedTask");
        SnackbarService.displaySnackBar('Task updated successfully');
      } catch (e) {
        logger.e("Error updating task: $updatedTask", error: e);
        SnackbarService.displaySnackBar('Error updating task');
      }
    } else {
      logger.w("Task with id: ${task.id} not found for toggling completion.");
    }
  }

  Future<void> deleteAllTasks() async {
    final tasksBackup = List<TaskModel>.from(state);
    state = [];
    logger.i("Deleting all tasks...");

    try {
      await _db.deleteTasks();
      logger.i("All tasks deleted successfully.");
      SnackbarService.displaySnackBar(
        'All tasks deleted',
        actionLabel: 'Undo',
        onActionPressed: () async {
          try {
            for (var task in tasksBackup) {
              await _db.addTask(task);
            }
            state = tasksBackup;
            logger.i("Restored all deleted tasks.");
            SnackbarService.displaySnackBar('Deleted tasks restored');
          } catch (e) {
            logger.e("Error restoring tasks", error: e);
          }
        },
      );
    } catch (e) {
      logger.e("Unable to delete all tasks", error: e);
      SnackbarService.displaySnackBar(
          'Unable to delete all tasks. Please try again.');
      state = tasksBackup; // Restore state on failure
    }
  }

  Future<void> deleteCompletedTasks() async {
    final completedTasks = state.where((task) => task.isCompleted).toList();
    state = state.where((task) => !task.isCompleted).toList();

    logger.i(
        "Deleting completed tasks: ${completedTasks.length} tasks to delete.");

    try {
      await _db.deleteTasks(completed: true);
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
