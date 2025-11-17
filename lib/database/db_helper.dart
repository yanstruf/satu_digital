import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:satu_digital/model/product_model.dart';
import 'package:satu_digital/model/cart_model.dart';
import 'package:satu_digital/model/order_model.dart';
import 'package:satu_digital/model/user_model.dart';

class DbHelper {
  static Database? _database;
  static const _dbName = 'satu_digital.db';
  static const _dbVersion = 5; // versi terbaru

  static const tableUser = 'users';
  static const tableProduct = 'products';
  static const tableCart = 'cart';
  static const tableOrder = 'orders';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ==============================================================
  // CREATE TABLE
  // ==============================================================
  Future<void> _onCreate(Database db, int version) async {
    // USERS
    await db.execute('''
      CREATE TABLE $tableUser(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        email TEXT,
        noHp TEXT,
        password TEXT,
        kota TEXT,
        role TEXT,
        gender TEXT
      )
    ''');

    // PRODUCTS (SUDAH DITAMBAHKAN LOCATION & RATING)
    await db.execute('''
      CREATE TABLE $tableProduct(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        price INTEGER,
        image TEXT,
        location TEXT,
        rating REAL,
        ownerId INTEGER
      )
    ''');

    // CART
    await db.execute('''
      CREATE TABLE $tableCart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        quantity INTEGER,
        userId INTEGER
      )
    ''');

    // ORDER
    await db.execute('''
      CREATE TABLE $tableOrder(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        customerName TEXT,
        address TEXT,
        phone TEXT,
        total INTEGER,
        createdAt TEXT
      )
    ''');

    print("Database created version: $version");
  }

  // ==============================================================
  // UPGRADE DATABASE
  // ==============================================================
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrade DB $oldVersion → $newVersion");

    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $tableUser ADD COLUMN gender TEXT');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableProduct(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          price INTEGER,
          image TEXT,
          ownerId INTEGER
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableCart(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          productId INTEGER,
          quantity INTEGER,
          userId INTEGER
        )
      ''');
    }

    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableOrder(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          customerName TEXT,
          address TEXT,
          phone TEXT,
          total INTEGER,
          createdAt TEXT
        )
      ''');
    }

    // 🔥 SUDAH DITAMBAH MIGRATION LOCATION & RATING
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE $tableProduct ADD COLUMN location TEXT');
      await db.execute('ALTER TABLE $tableProduct ADD COLUMN rating REAL');
    }
  }

  // ==============================================================
  // USER CRUD
  // ==============================================================
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(tableUser, user.toMap());
  }

  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final maps = await db.query(tableUser);
    return maps.map((m) => UserModel.fromMap(m)).toList();
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(tableUser, user.toMap(),
        where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(tableUser, where: 'id = ?', whereArgs: [id]);
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final db = await database;
    final res = await db.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (res.isNotEmpty) return UserModel.fromMap(res.first);
    return null;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query(
      tableUser,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (res.isNotEmpty) return UserModel.fromMap(res.first);
    return null;
  }

  // ==============================================================
  // PRODUCT CRUD
  // ==============================================================
  Future<int> insertProduct(ProductModel p) async {
    final db = await database;
    return await db.insert(tableProduct, p.toMap());
  }

  Future<List<ProductModel>> getAllProducts() async {
    final db = await database;
    final maps = await db.query(tableProduct, orderBy: 'id DESC');
    return maps.map((m) => ProductModel.fromMap(m)).toList();
  }

  Future<ProductModel?> getProductById(int id) async {
    final db = await database;
    final maps =
        await db.query(tableProduct, where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) return ProductModel.fromMap(maps.first);
    return null;
  }

  Future<int> updateProduct(ProductModel p) async {
    final db = await database;
    return await db.update(
      tableProduct,
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      tableProduct,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==============================================================
  // CART CRUD
  // ==============================================================
  Future<int> addToCart(int productId, int userId, {int qty = 1}) async {
    final db = await database;

    final existing = await db.query(
      tableCart,
      where: 'productId = ? AND userId = ?',
      whereArgs: [productId, userId],
    );

    if (existing.isNotEmpty) {
      final currentQty = existing.first['quantity'] as int;

      return await db.update(
        tableCart,
        {'quantity': currentQty + qty},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    }

    return await db.insert(tableCart, {
      'productId': productId,
      'quantity': qty,
      'userId': userId,
    });
  }

  Future<List<CartModel>> getCartByUser(int userId) async {
    final db = await database;
    final maps = await db.query(
      tableCart,
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((m) => CartModel.fromMap(m)).toList();
  }

  Future<int> updateCartQty(int cartId, int qty) async {
    final db = await database;
    return await db.update(
      tableCart,
      {'quantity': qty},
      where: 'id = ?',
      whereArgs: [cartId],
    );
  }

  Future<int> deleteCartItem(int cartId) async {
    final db = await database;
    return await db.delete(
      tableCart,
      where: 'id = ?',
      whereArgs: [cartId],
    );
  }

  Future<int> clearCartForUser(int userId) async {
    final db = await database;
    return await db.delete(
      tableCart,
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // ==============================================================
  // ORDER CRUD
  // ==============================================================
  Future<int> createOrder(OrderModel order) async {
    final db = await database;
    return await db.insert(tableOrder, order.toMap());
  }

  Future<List<OrderModel>> getOrdersByUser(int userId) async {
    final db = await database;
    final maps = await db.query(
      tableOrder,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    return maps.map((m) => OrderModel.fromMap(m)).toList();
  }

  // ==============================================================
  // RESET DATABASE
  // ==============================================================
  Future<void> deleteDb() async {
    final path = join(await getDatabasesPath(), _dbName);
    await deleteDatabase(path);
    print("Database deleted: $path");
  }
}
