import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';

class DataBase {
  static final DataBase _instance = DataBase._init();
  static Database? _database;
  static final Logger logger = Logger();

  DataBase._init();

  factory DataBase() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    logger.i("Initializing database");
    _database = await _initializeDB('tasks.db');
    return _database!;
  }

  Future<Database> _initializeDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    logger.i("Database initialized at $path");
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
    return await rootBundle.loadString('lib/database/migrations/$filename');
  }
}
