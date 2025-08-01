import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user_model.dart';
import 'auth_session.dart';

class UserDBHelper {
  UserDBHelper._internal();
  static final UserDBHelper instance = UserDBHelper._internal();
  factory UserDBHelper() => instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        imagePath TEXT
      )
    ''');
  }

  /// Insert or update user (UPSERT logic)
  Future<int> saveUser(UserModel user) async {
    final db = await database;
    final map = _userToMap(user);

    if (user.id == null) {
      return await db.insert(
        'users',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      return await db.update(
        'users',
        map,
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }
  }

  Future<int> update(UserModel user) async {
    if (user.id == null) throw Exception('User ID is null');
    final db = await database;
    return await db.update(
      'users',
      _userToMap(user),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<UserModel?> getUserByID(int id) async {
    return _getSingleUser(where: 'id = ?', whereArgs: [id]);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    return _getSingleUser(where: 'email = ?', whereArgs: [email]);
  }

  /// Get current logged-in user from AuthSession
  Future<UserModel?> getUser() async {
    final email = await AuthSession.getLoggedInEmail();
    if (email == null) return null;
    return await getUserByEmail(email);
  }

  Future<UserModel?> _getSingleUser({
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );

    if (result.isEmpty) return null;
    return UserModelDBExtension.fromMap(result.first);
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');

    return result.map(UserModelDBExtension.fromMap).toList();
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');
    await deleteDatabase(path);
    _database = null;
  }

  Map<String, dynamic> _userToMap(UserModel user) {
    return {
      if (user.id != null) 'id': user.id,
      'email': user.email,
      'password': user.password,
      'name': user.name,
      'imagePath': user.imagePath,
    };
  }
}
