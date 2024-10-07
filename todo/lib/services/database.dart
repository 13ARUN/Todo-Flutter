import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task_model.dart';

class DataBase {
  static final DataBase _instance = DataBase._init();
  static Database? _database;

  static const String _tableName = 'tasks';
  static const String _columnId = 'id';
  static const String _columnTitle = 'title';
  static const String _columnDescription = 'description';
  static const String _columnDate = 'date';
  static const String _columnIsCompleted = 'isCompleted';

  DataBase._init();

  factory DataBase() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB('tasks.db');
    return _database!;
  }

  //* Initialize DataBase
  Future<Database> _initializeDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  //* Create DataBase
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        $_columnId TEXT PRIMARY KEY,
        $_columnTitle TEXT,
        $_columnDescription TEXT,
        $_columnDate TEXT,
        $_columnIsCompleted INTEGER
      )
    ''');
  }

  //* Get All Tasks
  Future<List<TaskModel>> getTasks({String orderBy = _columnId}) async {
    final db = await database;
    final result = await db.query(_tableName, orderBy: '$orderBy ASC');
    return result.map((json) => TaskModel.fromMap(json)).toList();
  }

  

  //* Add Task to DB
  Future<void> addTask(TaskModel task) async {
    final db = await database;
    await db.insert(_tableName, task.toMap());
  }

  //* Delete Task from DB
  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  //* Update Task in DB
  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    await db.update(_tableName, task.toMap(),
        where: '$_columnId = ?', whereArgs: [task.id]);
  }

  //* Delete Tasks
  Future<void> deleteTasks({bool completed = false}) async {
    final db = await database;
    if (completed) {
      await db
          .delete(_tableName, where: '$_columnIsCompleted = ?', whereArgs: [1]);
    } else {
      await db.delete(_tableName);
    }
  }

  //* Close DataBase
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
