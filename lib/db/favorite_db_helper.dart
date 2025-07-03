import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/product.dart';

class FavoriteDBHelper {
  static final FavoriteDBHelper instance =
      FavoriteDBHelper._privateConstructor();
  static Database? _database;

  FavoriteDBHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER,
        userEmail TEXT NOT NULL,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT,
        category TEXT,
        image TEXT,
        ratingRate REAL,
        ratingCount INTEGER,
        PRIMARY KEY (id, userEmail)
      )
    ''');
  }

  Future<void> insert({
    required String userEmail,
    required Product product,
  }) async {
    final db = await database;
    final data = product.toMap()..['userEmail'] = userEmail;
    await db.insert(
      'favorites',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> remove({
    required String userEmail,
    required int productId,
  }) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ? AND userEmail = ?',
      whereArgs: [productId, userEmail],
    );
  }

  Future<List<Product>> getFavoritesByUser({required String userEmail}) async {
    final db = await database;
    final maps = await db.query(
      'favorites',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );

    if (maps.isEmpty) return [];

    return maps.map((map) => ProductDBExtension.fromMap(map)).toList();
  }

  Future<bool> isFavorite({
    required String userEmail,
    required int productId,
  }) async {
    final db = await database;
    final maps = await db.query(
      'favorites',
      where: 'id = ? AND userEmail = ?',
      whereArgs: [productId, userEmail],
    );
    return maps.isNotEmpty;
  }
}
