import 'package:todo/models/task_model.dart';
import 'package:todo/services/database/database.dart';
import 'package:todo/services/logger/logger.dart';

class DatabaseHelper {
  final logger = getLogger('DatabaseHelper');

  static const String _tableName = 'tasks';

  Future<List<TaskModel>> getTasks({String orderBy = 'id'}) async {
    final db = await DataBase().database;
    logger.i("Fetching all tasks ordered by $orderBy");
    final result = await db.query(_tableName, orderBy: '$orderBy ASC');
    logger.i("Fetched ${result.length} tasks from table: $_tableName");
    return result.map((map) => TaskModel.fromMap(map)).toList();
  }

  Future<void> addTask(TaskModel task) async {
    final db = await DataBase().database;
    logger.i("Inserting task with ID: ${task.id}, title: ${task.title}");
    await db.insert(_tableName, task.toMap());
    logger.i("Task with ID: ${task.id}, title: ${task.title} inserted");
  }

  Future<void> deleteTask(String id) async {
    final db = await DataBase().database;
    logger.i("Deleting task with ID $id");
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    logger.i("Task with ID $id deleted");
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await DataBase().database;
    logger.i("Updating task with ID: ${task.id}, title: ${task.title}");
    await db.update(
      _tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    logger.i("Task with ID: ${task.id}, title: ${task.title} updated");
  }

  Future<void> deleteTasks({bool completed = false}) async {
    final db = await DataBase().database;
    if (completed) {
      logger.i("Deleting completed tasks");
      await db.delete(_tableName, where: 'isCompleted = ?', whereArgs: [1]);
      logger.i("Completed tasks deleted");
    } else {
      logger.i("Deleting all tasks");
      await db.delete(_tableName);
      logger.i("All tasks deleted");
    }
  }

  Future<void> close() async {
    final db = await DataBase().database;
    logger.i("Closing database");
    await db.close();
    logger.i("Database closed");
  }
}
