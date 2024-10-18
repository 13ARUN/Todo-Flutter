import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/services/database/database_helper.dart';

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }

  final DatabaseHelper _db = DatabaseHelper();

  Future<void> _loadTasks() async {
    try {
      final tasks = await _db.getTasks();
      state = tasks;
    } catch (e) {
      // _showSnackBar('Failed to load tasks');
      debugPrint('Error: $e');
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _db.addTask(task);
      state = [...state, task];
    } catch (e) {
      // _showSnackBar('Unable to add the task. Please try again.');
      debugPrint('Error: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    
    final newState = state.where((task) => task.id != id).toList();
    state = newState; // Update state by removing the task.

    try {
      await _db.deleteTask(id);
    } catch (e) {
      // _showSnackBar('Unable to delete this task. Please try again.');
      debugPrint('Error: $e');
    }
  }

  Future<void> editTask(TaskModel editedTask) async {
    final taskIndex = state.indexWhere((task) => task.id == editedTask.id);
    if (taskIndex != -1) {
      state[taskIndex] = editedTask; // Update the task in the state
      try {
        await _db.updateTask(editedTask);
      } catch (e) {
        // _showSnackBar('Unable to edit this task. Please try again.');
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

    // Create a new list to trigger rebuild
    final newState = List<TaskModel>.of(state);
    final taskIndex = newState.indexWhere((t) => t.id == task.id);

    if (taskIndex != -1) {
      newState[taskIndex] =
          updatedTask; // Update the task in the new state list
      state = newState; // Assign the new list to state

      try {
        await _db.updateTask(updatedTask); // Update the task in the database
      } catch (e) {
        debugPrint('Error updating task: $e');
      }
    }
  }

  Future<void> deleteAllTasks() async {
    state = []; // Clear the state
    try {
      await _db.deleteTasks();
    } catch (e) {
      // _showSnackBar('Unable to delete tasks. Please try again.');
      debugPrint('Error: $e');
    }
  }

  Future<void> deleteCompletedTasks() async {
    state = state.where((task) => !task.isCompleted).toList(); // Update state
    try {
      await _db.deleteTasks(completed: true);
    } catch (e) {
      // _showSnackBar('Unable to delete completed tasks. Please try again.');
      debugPrint('Error: $e');
    }
  }
}

final tasksProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  return TaskNotifier();
});
