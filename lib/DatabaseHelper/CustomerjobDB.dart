import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabasejobHelper {
  static final DatabasejobHelper _instance = DatabasejobHelper._internal();
  static Database? _database;

  factory DatabasejobHelper() => _instance;

  DatabasejobHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'jobcustomer.db');
    print("Opening database at path: $path");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {}
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jobTable (
        jobcustomerId INTEGER PRIMARY KEY AUTOINCREMENT,
        userid TEXT NOT NULL,
        fullName TEXT NOT NULL,
        contactNumber TEXT NOT NULL,
        categories TEXT NOT NULL,
        address TEXT NOT NULL,
        details TEXT NOT NULL,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    print("Table 'jobTable' created successfully.");
  }

  Future<int> insertJob(Map<String, dynamic> jobData) async {
    final db = await database;
    return await db.insert(
      'jobTable',
      jobData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllJobs() async {
    final db = await database;
    return await db.query('jobTable');
  }

  Future<List<Map<String, dynamic>>> fetchJobsByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'jobTable',
      where: 'userid = ?',
      whereArgs: [userId],
    );
  }

  Future<int> deleteJob(int jobId) async {
    final db = await database;
    return await db.delete(
      'jobTable',
      where: 'jobcustomerId = ?',
      whereArgs: [jobId],
    );
  }
}
