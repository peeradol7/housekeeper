import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/jobModel.dart';

class JobsDatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    print("Initializing database...");
    _database = await _initializeDb();
    print("Database initialized successfully");
    return _database!;
  }

  Future<Database> _initializeDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sqlite.db'); // Ensure consistent naming here

    print("Opening database at path: $path");

    return await openDatabase(
      path,
      version: 2, // Ensure the schema version is updated
      onCreate: (db, version) async {
        print("Creating tables...");
        await db.execute('''
      CREATE TABLE IF NOT EXISTS jobs (
      jobid INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      fullName TEXT,
      email TEXT,
      category TEXT,
      price REAL,
      contactNumber TEXT,
      details TEXT
    );
  ''');

        print("Jobs table created successfully.");
      },
      onOpen: (db) async {
        var tables = await db.query('sqlite_master',
            where: 'type = ? AND name = ?', whereArgs: ['table', 'jobs']);
        print("Tables found: $tables");
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        print("Upgrading database from version $oldVersion to $newVersion...");
        if (oldVersion < 2) {
          await db.execute('''
          CREATE TABLE IF NOT EXISTS jobs(
            jobid INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            fullName TEXT,
            email TEXT,
            category TEXT,
            price REAL,
            contactNumber TEXT,
            details TEXT
          )
        ''');
          print("Jobs table created or upgraded.");
        }
      },
    );
  }

  Future<bool> checkTableExists(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT name FROM sqlite_master WHERE type="table" AND name=?',
      [tableName],
    );
    return result.isNotEmpty;
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

  Future<int> updateUser(int id, String fullName, String email) async {
    try {
      final db = await database;

      // ตรวจสอบว่าตาราง users มีอยู่ในฐานข้อมูลหรือไม่
      bool tableExists = await checkTableExists('users');
      if (!tableExists) {
        throw 'Users table does not exist';
      }

      if (fullName.trim().isEmpty || email.trim().isEmpty) {
        throw 'Full Name and Email cannot be empty';
      }

      final userExists = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (userExists.isEmpty) {
        throw 'User not found';
      }

      final result = await db.update(
        'users',
        {
          'fullName': fullName.trim(),
          'email': email.trim(),
        },
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );

      if (result == 0) {
        throw 'Update failed';
      }

      return result;
    } catch (e) {
      throw 'Failed to update user: ${e.toString()}';
    }
  }

  Future<List<Map<String, dynamic>>> getJobsByCategory(String category) async {
    final db = await database;
    return await db.query(
      'jobs',
      columns: ['fullName', 'category', 'price', 'contactNumber', 'details'],
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<Map<String, dynamic>?> getJobById(int id) async {
    final db = await database;
    final result = await db.query(
      'jobs',
      where: 'jobid = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      print("Job loaded: ${result.first}");
      return result.first;
    } else {
      print("Job with id $id not found.");
      return null;
    }
  }

  Future<bool> updateJob(
      int jobid, String category, double price, String details) async {
    try {
      final db = await database;
      final result = await db.update(
        'jobs',
        {
          'category': category,
          'price': price,
          'details': details,
        },
        where: 'id = ?',
        whereArgs: [jobid],
      );
      return result > 0; // Returns true if update was successful
    } catch (e) {
      print('Error updating job: $e');
      return false;
    }
  }

  Future<void> saveJob(JobData job) async {
    final db = await database;
    print('Attempting to save job: ${job.toMap()}');

    try {
      var tables = await db.query('sqlite_master',
          where: 'type = ? AND name = ?', whereArgs: ['table', 'jobs']);

      if (tables.isEmpty) {
        throw Exception("Table 'jobs' does not exist!");
      }

      int id = await db.insert(
        'jobs',
        job.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Job saved successfully with ID: $id');
    } catch (e) {
      print('Error saving job: $e');
      throw e;
    }
  }

  Future<void> checkDatabase() async {
    final db = await database;
    try {
      var tables = await db.query('sqlite_master',
          where: 'type = ? AND name = ?', whereArgs: ['table', 'jobs']);
      print("Existing tables: $tables");

      if (tables.isEmpty) {
        print("Table 'jobs' not found, creating...");
        await db.execute('''
          CREATE TABLE IF NOT EXISTS jobs(
            jobid INTEGER PRIMARY KEY AUTOINCREMENT,
            userid INTEGER,
            fullName TEXT,
            email TEXT,
            category TEXT,
            price REAL,
            contactNumber TEXT,
            details TEXT
          )
        ''');
        print("Jobs table created");
      }
    } catch (e) {
      print("Error checking database: $e");
    }
  }

  void checkTables(Database db) async {
    final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='jobs'");
    if (result.isNotEmpty) {
      print("Jobs table exists.");
    } else {
      print("Jobs table does not exist.");
    }
  }
}
