import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/scan_result.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ocr_results.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scan_results(
        id TEXT PRIMARY KEY,
        timestamp INTEGER NOT NULL,
        extractedNumbers TEXT NOT NULL,
        imagePath TEXT
      )
    ''');
  }

  Future<void> insertScanResult(ScanResult result) async {
    final db = await database;
    await db.insert(
      'scan_results',
      result.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ScanResult>> getAllScanResults() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_results',
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return ScanResult.fromMap(maps[i]);
    });
  }

  Future<ScanResult?> getScanResult(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_results',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ScanResult.fromMap(maps.first);
    }
    return null;
  }

  Future<void> deleteScanResult(String id) async {
    final db = await database;
    await db.delete(
      'scan_results',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
