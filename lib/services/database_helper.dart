import 'package:flutter_application/entities/box_entity.dart';
import 'package:flutter_application/entities/stock_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../entities/product_entity.dart';
import '../models/product_management_view_model.dart';

/// Helper для баз данных
class DatabaseHelper {
  static const idType = 'INTEGER PRIMARY KEY';
  static const textType = 'TEXT NOT NULL';
  static const intType = 'INTEGER NOT NULL';
  static const cascadeDelete = 'ON DELETE NO ACTION ON UPDATE NO ACTION';

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
    // Создание таблицы "Products"
    await db.execute(createProductTable);

    // Создание таблицы "StockRecount"
    await db.execute(createStockTable);

    // Создание таблицы "Boxes"
    await db.execute(createBoxTable);
  }

  static const String createStockTable = '''
      CREATE TABLE $tableStockRecount (
        ${StockRecountFields.id} $idType AUTOINCREMENT,
        ${StockRecountFields.quantity} $intType,
      )
      ''';

  static const String createProductTable = '''
      CREATE TABLE $tableProducts (
        ${ProductFields.id} $idType,
        ${ProductFields.name} $textType,
        ${ProductFields.quantity} $intType,
        ${ProductFields.time} $textType
      )
      ''';

  static const String createBoxTable = '''
      CREATE TABLE $tableBoxes (
        ${BoxFields.id} $idType,
        ${BoxFields.productId} $intType,
        ${BoxFields.quantity} $intType,
        FOREIGN KEY (${BoxFields.productId}) 
          REFERENCES $tableProducts (${ProductFields.id})
          $cascadeDelete
      )
      ''';

  static const String dropStockTable = '''
    DROP TABLE IF EXISTS $tableStockRecount
  ''';

  static Future<Product> createProduct(Product product) async {
    final db = await instance.database;

    final id = await db.insert(
      tableProducts,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return product.copy(id: id);
  }

  static Future<Box> createBox(Box box) async {
    final db = await instance.database;

    final id = await db.insert(
      tableBoxes,
      box.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return box.copy(id: id);
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

  static Future<int?> getCountProduct() async {
    final db = await instance.database;

    return Sqflite.firstIntValue(await db.rawQuery('''
      SELECT COUNT(*) 
      FROM $tableStockRecount
  '''));
  }

  static Future<List<ProductManagementViewModel>> getAllProducts() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT * FROM $tableProducts
      JOIN $tableBoxes ON products._id = ${BoxFields.productId}
    ''');

    return result
        .map((json) => ProductManagementViewModel.fromJson(json))
        .toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  static Future<void> recreateStockTable() async {
    final db = await instance.database;

    await db.execute(dropStockTable);

    await db.execute(createStockTable);
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
