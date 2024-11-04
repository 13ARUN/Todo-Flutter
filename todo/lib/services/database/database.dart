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

  // static const String columnNew = 'newColumn';

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
        // onUpgrade: (db, oldVersion, newVersion) async {
        //   await _upgradeDB(db, oldVersion, newVersion);
        // },
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

  // onUpgrade Function
  // Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  //   logger.i("Upgrading database from version $oldVersion to $newVersion");
  //   if (oldVersion < 2) {
  //     try {
  //       await db.execute('ALTER TABLE $tableTasks ADD COLUMN $columnNew TEXT');
  //       logger.i("Database upgraded to version $newVersion with $columnNew");
  //     } catch (e) {
  //       logger.e("Failed to upgrade database to version $newVersion: $e");
  //     }
  //   }
  // }
}
