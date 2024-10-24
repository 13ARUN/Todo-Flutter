import 'package:dio/dio.dart';
import 'package:todo/models/task_model.dart'; // Make sure TaskModel has the required fields and methods
import 'package:todo/services/database/database.dart';
import 'package:todo/utils/logger/logger.dart';

class DatabaseMethods {
  final logger = getLogger('DatabaseMethods');
  final Dio dio = Dio();

  static const String _tableName = 'tasks';

  Future<void> fetchAndStoreTodos() async {
    try {
      deleteTasks();
      logger.i("Fetching todos from API");
      final response = await dio.get('https://api.nstack.in/v1/todos');

      if (response.statusCode == 200) {
        List<dynamic> todos =
            response.data['items']; // Access the "items" array from response

        // Convert each item to TaskModel and store it in the database
        List<TaskModel> taskList =
            todos.map((item) => TaskModel.fromApiMap(item)).toList();

        for (var task in taskList) {
          await addTask(task); // Store each task in the database
        }

        logger.i("Fetched and stored ${taskList.length} todos");
      } else {
        logger.e("Failed to fetch todos: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error fetching todos from API: $e");
    }
  }

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

  Future<void> addTask(TaskModel task) async {
    final db = await DataBase().database;
    try {
      logger.i("Inserting task with ID: ${task.id}, title: ${task.title}");
      final result = await db.insert(_tableName, task.toMap());
      logger.i(result);
      logger.i("Task with ID: ${task.id}, title: ${task.title} inserted");
    } catch (e) {
      logger.e("Error inserting task: $e");
    }
  }

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
