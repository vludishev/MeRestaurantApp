import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/product_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "meRestaurant_database.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute("PRAGMA foreign_keys = ON;");
        await db.execute(
            'CREATE TABLE Products(id INTEGER PRIMARY KEY, barcode TEXT, name TEXT);');
        await db.execute("CREATE TABLE StockRecount ("
            "id INTEGER PRIMARY KEY,"
            "quantity INTEGER NOT NULL,"
            "productId INTEGER NOT NULL,"
            "FOREIGN KEY (productId)"
            "REFERENCES Products (productId));");
      },
      version: _version,
    );
  }

  static Future<int> insertProduct(ProductModel product) async {
    final db = await _getDB();
    return await db.insert(
      "Products",
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // static Future<int> updateProduct(ProductModel product) async {
  //   final db = await _getDB();
  //   return await db.update(
  //     "products",
  //     product.toJson(),
  //     where: 'id = ?',
  //     whereArgs: [product.name],
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  static Future<int> deleteProduct(ProductModel product) async {
    final db = await _getDB();
    return await db.delete(
      "Products",
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  static Future<List<ProductModel>> getAllProducts() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("products");

    // if (maps.isEmpty) {
    //   return null;
    // }

    return List.generate(
      maps.length,
      (index) => ProductModel.fromJson(
        maps[index],
      ),
    );
  }
}
