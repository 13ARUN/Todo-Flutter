import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task_model.dart';
import 'package:logger/logger.dart';


class DataBase {
  static final DataBase _instance = DataBase._init();
  static Database? _database;
  static final Logger _logger = Logger(); // Initialize logger

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
    _logger.i("Initializing database");
    _database = await _initializeDB('tasks.db');
    return _database!;
  }

  //* Initialize DataBase
  Future<Database> _initializeDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    _logger.i("Database initialized at $path");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  //* Create DataBase
  Future _createDB(Database db, int version) async {
    _logger.i("Creating table $_tableName");
    await db.execute('''
      CREATE TABLE $_tableName(
        $_columnId TEXT PRIMARY KEY,
        $_columnTitle TEXT,
        $_columnDescription TEXT,
        $_columnDate TEXT,
        $_columnIsCompleted INTEGER
      )
    ''');
    _logger.i("Table $_tableName created");
  }

  //* Get All Tasks
  Future<List<TaskModel>> getTasks({String orderBy = _columnId}) async {
    final db = await database;
    _logger.i("Fetching all tasks ordered by $orderBy");
    final result = await db.query(_tableName, orderBy: '$orderBy ASC');
    _logger.i("Fetched ${result.length} tasks");
    return result.map((map) => TaskModel.fromMap(map)).toList();
  }

  //* Add Task to DB
  Future<void> addTask(TaskModel task) async {
    final db = await database;
    _logger.i("Inserting task with ID ${task.id}");
    await db.insert(_tableName, task.toMap());
    _logger.i("Task with ID ${task.id} inserted");
  }

  //* Delete Task from DB
  Future<void> deleteTask(String id) async {
    final db = await database;
    _logger.i("Deleting task with ID $id");
    await db.delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
    _logger.i("Task with ID $id deleted");
  }

  //* Update Task in DB
  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    _logger.i("Updating task with ID ${task.id}");
    await db.update(
      _tableName,
      task.toMap(),
      where: '$_columnId = ?',
      whereArgs: [task.id],
    );
    _logger.i("Task with ID ${task.id} updated");
  }

  //* Delete Tasks
  Future<void> deleteTasks({bool completed = false}) async {
    final db = await database;
    if (completed) {
      _logger.i("Deleting completed tasks");
      await db.delete(_tableName, where: '$_columnIsCompleted = ?', whereArgs: [1]);
      _logger.i("Completed tasks deleted");
    } else {
      _logger.i("Deleting all tasks");
      await db.delete(_tableName);
      _logger.i("All tasks deleted");
    }
  }

  //* Close DataBase
  Future<void> close() async {
    final db = await database;
    _logger.i("Closing database");
    await db.close();
    _logger.i("Database closed");
  }
}
