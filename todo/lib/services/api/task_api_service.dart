import 'package:dio/dio.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/utils/logger/logger.dart';

/// A service class for managing tasks via a REST API.
///
/// This class provides methods to create, read, update, and delete
/// tasks in a remote API using the Dio HTTP client.
class TaskApiService {
  static final logger = getLogger('TaskApiService');
  final Dio dio = Dio();

  /// Posts a new task to the API.
  ///
  /// Parameters:
  /// - [task]: The [TaskModel] instance representing the task to be posted.
  Future<void> postTodo(TaskModel task) async {
    try {
      logger.i(
        "Posting todo with title: ${task.title}, description: ${task.description}, is_completed: ${task.isCompleted} to API",
      );
      final data = {
        'title': task.title,
        'description': task.description,
        'is_completed': task.isCompleted,
      };
      final response = await dio.post(
        'https://api.nstack.in/v1/todos',
        data: data,
      );

      if (response.statusCode == 201) {
        logger.i("Todo posted successfully: ${response.data}");
      } else {
        logger.e("Failed to post todo. Status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error posting todo: $e");
    }
  }

  /// Deletes a task by its ID from the API.
  ///
  /// Parameters:
  /// - [id]: The ID of the task to be deleted.
  Future<void> deleteTodo(String id) async {
    try {
      logger.i("Deleting task with id: $id from API...");
      final response = await dio.delete('https://api.nstack.in/v1/todos/$id');

      if (response.statusCode == 200) {
        logger.i("Task deleted successfully from the API.");
      } else {
        logger.e("Failed to delete task. Status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error deleting task: $e");
    }
  }

  /// Updates an existing task in the API.
  ///
  /// Parameters:
  /// - [task]: The [TaskModel] instance with updated information.
  Future<void> putTodo(TaskModel task) async {
    try {
      logger.i("Updating todo with id: ${task.id}");
      final data = {
        'title': task.title,
        'description': task.description,
        'is_completed': task.isCompleted,
      };
      final response = await dio.put(
        'https://api.nstack.in/v1/todos/${task.id}',
        data: data,
      );

      if (response.statusCode == 200) {
        logger.i("Todo updated successfully: ${response.data}");
      } else {
        logger.e("Failed to update todo. Status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error updating todo: $e");
    }
  }

  /// Deletes all tasks from the API.
  ///
  /// Parameters:
  /// - [tasks]: A list of [TaskModel] instances representing tasks to be deleted.
  Future<void> deleteAllTodos(List<TaskModel> tasks) async {
    try {
      logger.i("Sending request to delete all tasks from API...");
      for (var task in tasks) {
        final response =
            await dio.delete('https://api.nstack.in/v1/todos/${task.id}');
        if (response.statusCode == 200) {
          logger.i("Task deleted successfully.");
        } else {
          logger
              .e("Failed to delete task. Status code: ${response.statusCode}");
        }
      }
    } catch (e) {
      logger.e("Error deleting all tasks: $e");
    }
  }
}
