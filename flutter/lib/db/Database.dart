import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Product.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    return await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'product_db2.db'),
      onCreate: (db, version) {
        print("onCreate called");
        return db.execute('CREATE TABLE products_server ('
            'id INTEGER PRIMARY KEY,'
            'product_name TEXT NOT NULL,'
            'serial_number TEXT NOT NULL UNIQUE,'
            'aisle TEXT NOT NULL,'
            'price REAL NOT NULL,'
            'quantity INTEGER NOT NULL)');
      },
      version: 1,
    );
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    var res = await db.query("products_server");
    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> insertProduct(Product product) async {
    final db = await database;
    try {
      int res = await db.insert("products_server", product.toMap());
      product.id = res;

      return res;
    } catch (e) {
      return -1;
    }
  }

  Future<int> insertProductFromServer(Product product) async {
    final db = await database;
    try {
      int res = await db.insert("products_server", product.toJson());
      product.id = res;

      return res;
    } catch (e) {
      return -1;
    }
  }

  updateProduct(Product newProduct) async {
    final db = await database;
    try {
      var res = await db.update("products_server", newProduct.toMap(),
          where: "id = ?", whereArgs: [newProduct.id]);
      return res;
    } catch (e) {
      return -1;
    }
  }

  deleteProduct(Product product) async {
    final db = await database;
    db.delete("products_server", where: "id = ?", whereArgs: [product.id]);
  }
}
