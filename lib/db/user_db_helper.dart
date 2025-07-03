import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/user_model.dart';

class UserDBHelper {
  static final UserDBHelper instance = UserDBHelper._internal();
  factory UserDBHelper() => instance;
  UserDBHelper._internal();

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
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        imagePath TEXT
      )
    ''');
  }

  // Create or Insert new user (ถ้า user.id == null)
  Future<int> insertUser(UserModel user) async {
    final db = await database;

    final map = <String, dynamic>{
      'email': user.email,
      'password': user.password,
      'name': user.name,
      'imagePath': user.imagePath,
    };

    return await db.insert(
      'users',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read user by id
  Future<UserModel?> getUserByID(int id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return UserModelDBExtension.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return UserModelDBExtension.fromMap(maps.first);
    } else {
      return null;
    }
  }


  // Read all users
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users');

    if (maps.isEmpty) return [];

    return maps.map((map) => UserModelDBExtension.fromMap(map)).toList();
  }

  // Update user (user.id ต้องไม่ null)
  Future<int> updateUser(UserModel user) async {
    final db = await database;
    if (user.id == null) {
      throw Exception('Cannot update user without id');
    }

    final map = <String, dynamic>{
      'email': user.email,
      'password': user.password,
      'name': user.name,
      'imagePath': user.imagePath,
    };

    return await db.update(
      'users',
      map,
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete user by id
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete database file (for debug only)
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');
    await deleteDatabase(path);
    _database = null;
  }
}
