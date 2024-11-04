import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/services/database/database.dart';
import 'package:todo/utils/logger/logger.dart';

class DatabaseMethods {
  final logger = getLogger('DatabaseMethods');
  final Dio dio = Dio();

  static const String _tableName = 'tasks';

  Future<void> fetchAndStoreTodos() async {
    try {
      logger.i("Fetching todos from API");
      final response = await dio.get('https://api.nstack.in/v1/todos');
      if (response.statusCode == 200) {
        List<dynamic> todos = response.data['items'];
        List<TaskModel> apiTaskList =
            todos.map((item) => TaskModel.fromApiMap(item)).toList();
        List<TaskModel> dbTaskList = await getTasks();
        for (var apiTask in apiTaskList) {
          try {
            final dbTask =
                dbTaskList.firstWhere((task) => task.id == apiTask.id);
            if (dbTask != apiTask) {
              await updateTask(apiTask);
            }
          } catch (e) {
            await addTask(apiTask);
          }
        }
        for (var dbTask in dbTaskList) {
          try {
            // ignore: unused_local_variable
            final apiTask =
                apiTaskList.firstWhere((task) => task.id == dbTask.id);
          } catch (e) {
            await deleteTask(dbTask.id);
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

  // Future<void> fetchAndStoreTodos() async {
  //   try {
  //     deleteTasks();
  //     logger.i("Fetching todos from API");
  //     final response = await dio.get('https://api.nstack.in/v1/todos');
  //     if (response.statusCode == 200) {
  //       List<dynamic> todos = response.data['items'];
  //       List<TaskModel> taskList =
  //           todos.map((item) => TaskModel.fromApiMap(item)).toList();
  //       for (var task in taskList) {
  //         await addTask(task);
  //       }
  //       logger.i("Fetched and stored ${taskList.length} todos");
  //     } else {
  //       logger.e("Failed to fetch todos: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     logger.e("Error fetching todos from API: $e");
  //   }
  // }

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

  Future<void> exportTodos() async {
    final tasks = await getTasks();
    final taskJsonList = tasks.map((task) => task.toMap()).toList();
    final jsonString = jsonEncode(taskJsonList);

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/exported_tasks.json');
      await file.writeAsString(jsonString);
      logger.i("Tasks successfully exported to ${file.path}");
    } catch (e) {
      logger.e("Error exporting tasks: $e");
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
