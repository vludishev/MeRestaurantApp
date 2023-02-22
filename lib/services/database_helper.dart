import 'package:flutter_application/models/stock_recount_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/product_model.dart';

/// Helper для баз данных
class DatabaseHelper {
  /// Instance для инициализации базы данных
  static final DatabaseHelper instance = DatabaseHelper._init();

  /// База данных
  static Database? _database;

  /// Версия БД
  static const int _version = 1;

  // Конструктор
  DatabaseHelper._init();

  // Получить БД
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('restaurant_database.db');
    return _database!;
  }

  // Инициализировать БД
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: _version, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const cascadeDelete = 'ON DELETE NO ACTION ON UPDATE NO ACTION';

    // Создание таблицы "Products"
    await db.execute('''
      CREATE TABLE $tableProducts (
        ${ProductFields.id} $idType,
        ${ProductFields.name} $textType,
        ${ProductFields.time} $textType
      )
      ''');

    // Создание таблицы "StockRecount"
    await db.execute('''
      CREATE TABLE $tableStockRecount (
        ${StockRecountFields.id} $idType AUTOINCREMENT,
        ${StockRecountFields.quantity} $intType,
        ${StockRecountFields.productId} $intType,
        FOREIGN KEY (${StockRecountFields.productId}) 
          REFERENCES $tableProducts (${ProductFields.id})
          $cascadeDelete
      )
      ''');
  }

  static Future<Product> createProduct(Product product) async {
    final db = await instance.database;

    final id = await db.insert(
      tableProducts,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return product.copy(id: id);
  }

  static Future<StockRecount> createProductInStock(StockRecount stock) async {
    final db = await instance.database;

    final id = await db.insert(
      tableStockRecount,
      stock.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return stock.copy(id: id);
  }

  static Future<bool> getStockRecountProduct(int productId) async {
    final db = await instance.database;

    final maps = await db.query(
      tableStockRecount,
      columns: StockRecountFields.values,
      where: '${StockRecountFields.productId} = ?',
      whereArgs: [productId],
    );

    if (maps.isNotEmpty) {
      return true;
    }

    return false;
  }

  static Future<int?> getCountProduct(int productId) async {
    final db = await instance.database;

    return Sqflite.firstIntValue(await db.rawQuery('''
      SELECT COUNT(${StockRecountFields.productId}) 
      FROM $tableStockRecount
      WHERE ${StockRecountFields.productId} = $productId
  '''));
  }

  static Future<List<Product>> getAllProducts() async {
    final db = await instance.database;

    final result = await db.query(tableProducts);

    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  static Future<int> update(Product product) async {
    final db = await instance.database;

    return await db.update(
      tableProducts,
      product.toJson(),
      where: '${ProductFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  static Future<int> deleteProduct(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableProducts,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );
  }
}
