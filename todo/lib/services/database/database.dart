import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/services/logger/logger.dart';

class DataBase {
  static final DataBase _instance = DataBase._init();
  static Database? _database;
  final logger = getLogger('DataBase');

  DataBase._init();

  factory DataBase() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    logger.t("Entering database get method");
    logger.i("Initializing database");
    _database = await _initializeDB('tasks.db');
    return _database!;
  }

  Future<Database> _initializeDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    logger.i("Database initialized");
    logger.d("Initialised Database Path: $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createDB(db);
      },
    );
  }

  Future<void> _createDB(Database db) async {
    logger.i("Creating tables");
    String createTableSQL = await _loadSQLFromFile('create_tasks_table.sql');
    await db.execute(createTableSQL);
    logger.i("Tables created");
  }

  Future<String> _loadSQLFromFile(String filename) async {
    return await rootBundle.loadString('assets/database/$filename');
  }
}
