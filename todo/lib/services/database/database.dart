import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/utils/logger/logger.dart';

class DataBase {
  static final DataBase _instance = DataBase._init();
  static Database? _database;
  final logger = getLogger('DataBase');

  static const String tableTasks = 'tasks';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnDate = 'date';
  static const String columnIsCompleted = 'isCompleted';

  DataBase._init();

  factory DataBase() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    logger.t("Entering database get method");
    logger.i("Initializing database");
    try {
      _database = await _initializeDB('tasks.db');
    } catch (e) {
      logger.e("Database initialization failed: $e");
    }
    return _database!;
  }

  Future<Database> _initializeDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    logger.i("Database initialized");
    logger.d("Initialized Database Path: $path");

    try {
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await _createDB(db);
        },
      );
    } catch (e) {
      logger.e("Failed to open database: $e");
      rethrow;
    }
  }

  Future<void> _createDB(Database db) async {
    logger.i("Creating tables");

    const String createTableSQL = '''
      CREATE TABLE $tableTasks (
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT,
        $columnDescription TEXT,
        $columnDate TEXT,
        $columnIsCompleted INTEGER
      );
    ''';

    try {
      await db.execute(createTableSQL);
      logger.i("Tables created");
    } catch (e) {
      logger.e("Failed to create tables: $e");
    }
  }
}
