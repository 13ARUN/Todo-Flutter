import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/services/database/database_helper.dart';
import 'package:todo/services/snackbar/snackbar_service.dart';

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }

  final DatabaseHelper _db = DatabaseHelper();

  Future<void> _loadTasks() async {
    try {
      final tasks = await _db.getTasks();
      state = tasks;
      SnackbarService.showSnackBar('Tasks loaded successfully');
    } catch (e) {
      SnackbarService.showSnackBar('Failed to load tasks');
      debugPrint('Error: $e');
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _db.addTask(task);
      state = [...state, task];
      SnackbarService.showSnackBar('Task added successfully');
    } catch (e) {
      SnackbarService.showSnackBar('Unable to add the task. Please try again.');
      debugPrint('Error: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    final taskIndex = state.indexWhere((task) => task.id == id);
    if (taskIndex == -1) return;

    final taskBackup = state[taskIndex];
    final newState = List<TaskModel>.from(state)..removeAt(taskIndex);
    state = newState;

    try {
      await _db.deleteTask(id);
      SnackbarService.showSnackBar(
        'Task deleted successfully',
        actionLabel: 'Undo',
        onActionPressed: () async {
          try {
            final updatedState = List<TaskModel>.from(state)
              ..insert(taskIndex, taskBackup);
            state = updatedState;

            await _db.addTask(taskBackup);
            SnackbarService.showSnackBar('Deleted task restored');
          } catch (e) {
            debugPrint('Error: $e');
          }
        },
      );
    } catch (e) {
      SnackbarService.showSnackBar(
          'Unable to delete this task. Please try again.');
      debugPrint('Error: $e');
      state = [...state, taskBackup];
    }
  }

  Future<void> editTask(TaskModel editedTask) async {
    final taskIndex = state.indexWhere((task) => task.id == editedTask.id);
    if (taskIndex != -1) {
      state[taskIndex] = editedTask;
      try {
        await _db.updateTask(editedTask);
        SnackbarService.showSnackBar('Task edited successfully');
      } catch (e) {
        SnackbarService.showSnackBar(
            'Unable to edit this task. Please try again.');
        debugPrint('Error: $e');
      }
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
      newState[taskIndex] = updatedTask;
      state = newState;

      try {
        await _db.updateTask(updatedTask);
        SnackbarService.showSnackBar('Task updated successfully');
      } catch (e) {
        SnackbarService.showSnackBar('Error updating task');
        debugPrint('Error updating task: $e');
      }
    }
  }

  Future<void> deleteAllTasks() async {
    final tasksBackup = List<TaskModel>.from(state);
    state = [];

    try {
      await _db.deleteTasks();
      SnackbarService.showSnackBar(
        'All tasks deleted',
        actionLabel: 'Undo',
        onActionPressed: () async {
          try {
            for (var task in tasksBackup) {
              await _db.addTask(task);
            }
            state = tasksBackup;
            SnackbarService.showSnackBar('Deleted tasks restored');
          } catch (e) {
            debugPrint('Error restoring tasks: $e');
          }
        },
      );
    } catch (e) {
      SnackbarService.showSnackBar(
          'Unable to delete all tasks. Please try again.');
      debugPrint('Error: $e');
      state = tasksBackup;
    }
  }

  Future<void> deleteCompletedTasks() async {
    state = state.where((task) => !task.isCompleted).toList();

    try {
      await _db.deleteTasks(completed: true);
      SnackbarService.showSnackBar('Completed tasks deleted');
    } catch (e) {
      SnackbarService.showSnackBar(
          'Unable to delete completed tasks. Please try again.');
      debugPrint('Error: $e');
    }
  }
}

final tasksProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  return TaskNotifier();
});
