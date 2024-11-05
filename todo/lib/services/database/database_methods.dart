import 'package:dio/dio.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/services/database/database.dart';
import 'package:todo/utils/logger/logger.dart';

class DatabaseMethods {
  final logger = getLogger('DatabaseMethods');
  final Dio dio = Dio();

  static const String _tableName = 'tasks';

  /// Fetches todos from the API and synchronizes them with the local database.
  Future<void> fetchAndStoreTodos() async {
    try {
      logger.i("Fetching todos from API");
      final response = await dio.get('https://api.nstack.in/v1/todos');

      if (response.statusCode == 200) {
        // Parse the response data
        List<dynamic> todos = response.data['items'];
        List<TaskModel> apiTaskList =
            todos.map((item) => TaskModel.fromApiMap(item)).toList();

        // Fetch existing tasks from the database
        List<TaskModel> dbTaskList = await getTasks();

        // Synchronize tasks with the API
        for (var apiTask in apiTaskList) {
          try {
            final dbTask =
                dbTaskList.firstWhere((task) => task.id == apiTask.id);
            if (dbTask != apiTask) {
              await updateTask(apiTask); // Update existing task
            }
          } catch (e) {
            await addTask(apiTask); // Add new task if it doesn't exist
          }
        }

        // Check for tasks in the database that are not in the API
        for (var dbTask in dbTaskList) {
          try {
            // If task exists in API, do nothing
            // ignore: unused_local_variable
            final apiTask =
                apiTaskList.firstWhere((task) => task.id == dbTask.id);
          } catch (e) {
            await deleteTask(
                dbTask.id); // Delete task if it does not exist in API
          }
        }

        logger.i("Fetched and synchronized tasks with the API");
      } else {
        logger.e("Failed to fetch todos: ${response.statusCode}");
      }
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
