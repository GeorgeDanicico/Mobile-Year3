import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Entity.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<void> createTables(Database db) async {
    await db.execute('CREATE TABLE Genres ('
        'id INTEGER PRIMARY KEY,'
        'name TEXT NOT NULL)');

    await db.execute('CREATE TABLE Entity ('
        'id INTEGER PRIMARY KEY,'
        'name TEXT NOT NULL,'
        'description TEXT NOT NULL,'
        'genre TEXT NOT NULL,'
        'director TEXT NOT NULL,'
        'year INTEGER NOT NULL)');
  }

  initDB() async {
    return await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'exam11.db'),
      onCreate: (db, version) async {
        log("onCreate called");
        await createTables(db);
      },
      version: 1,
    );
  }

  Future<int> insertGenre(String genre) async {
    final db = await database;
    try {
      Map<String, dynamic> map = {'name': genre};
      int res = await db.insert("Genres", map);

      return res;
    } catch (e) {
      Fluttertoast.showToast(msg: "DataBase Error has occured");
      return -1;
    }
  }

  Future<List<String>> getAllGenres() async {
    final db = await database;
    var res = await db.query("Genres");
    List<String> list =
        res.isNotEmpty ? res.map((c) => c["name"].toString()).toList() : [];

    log('Genres are: ${res.toString()}');
    return list;
  }

  Future<List<Entity>> getAllItemsFromGenre(String? genre) async {
    final db = await database;
    var res = await db.query(
      "Entity",
      where: 'genre = ?',
      whereArgs: [genre],
    );

    List<Entity> list =
        res.isNotEmpty ? res.map((c) => Entity.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> insertEntity(Entity entity) async {
    final db = await database;
    try {
      int res = await db.insert("Entity", entity.toMap());

      return res;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "DataBase Error has occured while inserting.");
      return -1;
    }
  }

  deleteEntity(Entity entity) async {
    final db = await database;
    db.delete("Entity", where: "id = ?", whereArgs: [entity.id]);
  }
}
