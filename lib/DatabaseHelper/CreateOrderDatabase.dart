import 'package:housekeeper/model/Ordermodel.dart';
import 'package:sqflite/sqflite.dart';

class CreateOrder {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = await getDatabasesPath();
    String dbPath = path + 'sqlite.db';

    return await openDatabase(dbPath,
        version: 2,
        onCreate: _createDB,
        onUpgrade: _onUpgradeDB, onOpen: (db) async {
      List<Map<String, dynamic>> tables = await db
          .rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
      print("Tables found: $tables");

      // ถ้าคุณต้องการแสดงชื่อของแต่ละตารางอย่างชัดเจน
      for (var table in tables) {
        print("Table: ${table['name']}");
      }
    });
  }

  _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE orders ADD COLUMN userId INTEGER');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jobid INTEGER,
        fullName TEXT,
        contactNumber TEXT,
        details TEXT,
        timestamp TEXT,
        userId INTEGER  -- Added userId column
      );
    ''');
  }

  static Future<bool> createOrder(OrderData order) async {
    final db = await CreateOrder().database;

    try {
      await db.insert(
        'orders',
        order.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("Order created successfully.");
      return true;
    } catch (e) {
      print("Error creating order: $e");
      return false;
    }
  }

  static Future<List<ShowOrder>> fetchOrdersByUserId(int? userid) async {
    if (userid == null) {
      print("Error: userId is null.");
      return [];
    }

    final db = await CreateOrder().database;

    try {
      final orders = await db.query(
        'orders',
        where: 'userId = ?',
        whereArgs: [userid],
      );

      // Map the result to ShowOrder objects using ShowOrder.fromMap
      return orders.map((order) => ShowOrder.fromMap(order)).toList();
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  static Future<List<OrderData>> getAllOrders() async {
    final db = await CreateOrder().database;
    final List<Map<String, dynamic>> maps = await db.query('orders');

    return List.generate(maps.length, (i) {
      return OrderData.fromMap(maps[i]);
    });
  }

  static Future<OrderData?> getLatestOrder() async {
    final db = await CreateOrder().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return OrderData.fromMap(maps.first);
    }
    return null;
  }
}
