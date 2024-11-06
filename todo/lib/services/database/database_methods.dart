import 'package:dio/dio.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/services/api/task_api_service.dart';
import 'package:todo/services/database/database.dart';

import 'package:todo/utils/logger/logger.dart';

class DatabaseMethods {
  final logger = getLogger('DatabaseMethods');
  final Dio dio = Dio();
  final TaskApiService taskApiService = TaskApiService();

  static const String _tableName = 'tasks';

  /// Fetches todos from the API and synchronizes them with the local database.
  ///
  /// This method:
  /// 1. Fetches the task list from the API via the [TaskApiService].
  /// 2. Retrieves the current task list from the local database.
  /// 3. Synchronizes the tasks by:
  ///    - Updating existing tasks that have changed.
  ///    - Adding new tasks that do not exist in the database.
  ///    - Deleting tasks from the database that are no longer present in the API.
  Future<void> fetchAndStoreTodos() async {
    try {
      logger.i("Fetching todos from API through TaskApiService");
      // Fetch the tasks from the API using the TaskApiService
      List<TaskModel> apiTaskList = await taskApiService.getTasksfromAPI();

      // Fetch existing tasks from the local database
      List<TaskModel> dbTaskList = await getTasks();

      // Synchronize tasks with the API
      for (var apiTask in apiTaskList) {
        try {
          // Try to find the task in the local database
          final dbTask = dbTaskList.firstWhere((task) => task.id == apiTask.id);
          // If the task exists but is different, update it
          if (dbTask != apiTask) {
            await updateTask(apiTask); // Update the task in the database
          }
        } catch (e) {
          // If the task doesn't exist in the database, add it
          await addTask(apiTask); // Add the new task to the database
        }
      }

      // Check for tasks in the database that are not present in the API
      for (var dbTask in dbTaskList) {
        try {
          // Try to find the task in the API response
          // ignore: unused_local_variable
          final apiTask =
              apiTaskList.firstWhere((task) => task.id == dbTask.id);
        } catch (e) {
          // If the task does not exist in the API, delete it from the database
          await deleteTask(dbTask.id); // Delete the task from the database
        }
      }

      logger.i("Fetched and synchronized tasks with the API");
    } catch (e) {
      logger.e("Error fetching todos from API: $e");
    }
  }

  /// Retrieves all tasks from the database, ordered by the specified column.
  ///
  /// Parameters:
  /// - [orderBy]: The column name to order the tasks by (default is 'id').
  Future<List<TaskModel>> getTasks({String orderBy = 'id'}) async {
    final db = await DataBase().database;
    try {
      logger.i("Fetching all tasks ordered by $orderBy");
      final result = await db.query(_tableName, orderBy: '$orderBy ASC');
      logger.i("Fetched ${result.length} tasks from table: $_tableName");
      return result.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      logger.e("Error fetching tasks: $e");
      return [];
    }
  }

  /// Adds a new task to the database.
  ///
  /// Parameters:
  /// - [task]: The task model to be added.
  Future<void> addTask(TaskModel task) async {
    final db = await DataBase().database;
    try {
      logger.i("Inserting task with ID: ${task.id}, title: ${task.title}");
      await db.insert(_tableName, task.toMap());
      logger.i("Task with ID: ${task.id}, title: ${task.title} inserted");
    } catch (e) {
      logger.e("Error inserting task: $e");
    }
  }

  /// Deletes a task from the database by its ID.
  ///
  /// Parameters:
  /// - [id]: The ID of the task to be deleted.
  Future<void> deleteTask(String id) async {
    final db = await DataBase().database;
    try {
      logger.i("Deleting task with ID $id");
      await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
      logger.i("Task with ID $id deleted");
    } catch (e) {
      logger.e("Error deleting task with ID $id: $e");
    }
  }

  /// Updates an existing task in the database.
  ///
  /// Parameters:
  /// - [task]: The task model with updated data.
  Future<void> updateTask(TaskModel task) async {
    final db = await DataBase().database;
    try {
      logger.i("Updating task with ID: ${task.id}, title: ${task.title}");
      await db.update(
        _tableName,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      logger.i("Task with ID: ${task.id}, title: ${task.title} updated");
    } catch (e) {
      logger.e("Error updating task with ID: ${task.id}: $e");
    }
  }

  /// Deletes tasks from the database, either all or only completed tasks based on the flag.
  ///
  /// Parameters:
  /// - [completed]: If true, deletes only completed tasks. If false, deletes all tasks.
  Future<void> deleteTasks({bool completed = false}) async {
    final db = await DataBase().database;
    try {
      if (completed) {
        logger.i("Deleting completed tasks");
        await db.delete(_tableName, where: 'isCompleted = ?', whereArgs: [1]);
        logger.i("Completed tasks deleted");
      } else {
        logger.i("Deleting all tasks");
        await db.delete(_tableName);
        logger.i("All tasks deleted");
      }
    } catch (e) {
      logger.e("Error deleting tasks: $e");
    }
  }

  /// Closes the database connection.
  Future<void> close() async {
    final db = await DataBase().database;
    try {
      logger.i("Closing database");
      await db.close();
      logger.i("Database closed");
    } catch (e) {
      logger.e("Error closing database: $e");
    }
  }
}
