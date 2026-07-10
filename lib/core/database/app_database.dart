import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logeria/core/domain/property.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('properties.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE properties(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        tenant TEXT NOT NULL,
        color TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertOrUpdateProperty(Property property) async {
    final db = await instance.database;
    await db.insert(
      'properties',
      property.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Property>> readAllProperties() async {
    final db = await instance.database;
    final result = await db.query('properties');

    return result.map((json) => Property.fromMap(json)).toList();
  }

  Future<int> deleteProperty(String id) async {
    final db = await instance.database;
    return await db.delete(
      'properties',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 