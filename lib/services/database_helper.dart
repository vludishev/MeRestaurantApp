import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/product_mode.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "MeRestaurantApp.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => await db.execute(
          "CREATE TABLE Barcode(id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL);"),
      version: _version,
    );
  }

  static Future<int> addProduct(ProductModel product) async {
    final db = await _getDB();
    return await db.insert(
      "Barcode",
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> updateProduct(ProductModel product) async {
    final db = await _getDB();
    return await db.update(
      "Barcode",
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.barcode],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deleteProduct(ProductModel product) async {
    final db = await _getDB();
    return await db.delete(
      "Barcode",
      where: 'id = ?',
      whereArgs: [product.barcode],
    );
  }

  static Future<List<ProductModel>?> getAllProducts() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Products");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => ProductModel.fromJson(
        maps[index],
      ),
    );
  }
}
