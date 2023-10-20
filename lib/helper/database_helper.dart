import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'user.db');
    return await openDatabase(path, version: 4, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, number TEXT, email TEXT, photoUrl TEXT)',
    );
  }
}
