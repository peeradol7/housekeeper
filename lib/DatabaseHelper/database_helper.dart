import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sqlite.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(userid INTEGER PRIMARY KEY, email TEXT, password TEXT)",
        );
      },
    );
  }

  Future<Database> _initializeDb() async {
    if (_database != null) {
      return _database!;
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sqlite.db');
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE jobs (
          jobid INTEGER PRIMARY KEY,
          fullName TEXT,
          email TEXT,
          category TEXT,
          price REAL,
          contactNumber TEXT,
          details TEXT
        )
      ''');
    });
    return _database!;
  }

  Future<int> updateJob(
      int jobId, String category, double price, String details) async {
    final db = await _initializeDb();
    int result = await db.update(
      'jobs',
      {
        'category': category,
        'price': price,
        'details': details,
      },
      where: 'jobid = ?',
      whereArgs: [jobId],
    );
    return result; // คืนค่าจำนวนแถวที่ถูกอัพเดท
  }

  Future<Map<String, dynamic>?> getJob(int jobId) async {
    final db = await _initializeDb();
    // ดึงข้อมูลงานจากตาราง jobs โดยใช้ id
    List<Map<String, dynamic>> result = await db.query(
      'jobs',
      where: 'jobid = ?',
      whereArgs: [jobId],
    );
    if (result.isNotEmpty) {
      return result.first; // คืนค่าข้อมูลงานตัวแรก
    }
    return null; // ถ้าไม่พบข้อมูล
  }

  Future<int> addJob(String fullName, String email, String category,
      double price, String details) async {
    final db = await _initializeDb();

    return await db.insert(
      'jobs',
      {
        'fullName': fullName,
        'email': email,
        'category': category,
        'price': price,
        'details': details,
      },
    );
  }

  Future<int> deleteJob(int jobId) async {
    final db = await _initializeDb();
    return await db.delete(
      'jobs',
      where: 'jobid = ?',
      whereArgs: [jobId],
    );
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
