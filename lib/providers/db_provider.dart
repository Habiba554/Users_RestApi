
import 'package:sqflite/sqflite.dart';
import '../models/users_models.dart';

class DBProvider {
  static Database? _database;
  static  DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database!;

    // If database don't exists, create one
    _database = await initDB();

    return _database!;
  }

  // Create the database and the User table
  initDB() async {
    return await openDatabase('Users.db', version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Users('
              'id INTEGER PRIMARY KEY,'
              'name TEXT,'
              'email TEXT,'
              'gender TEXT,'
              'status TEXT'
              ')');
        });
  }

  // Insert employee on database
  createUsers(Users newUsers) async {
    await deleteAllUsers();
    final db = await database;
    final res = await db.insert('Users', newUsers.toJson());

    return res;
  }

  // Delete all employees
  Future<int?> deleteAllUsers() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Users');

    return res;
  }

  Future<List<Users>> getAllUsers() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Users");

    List<Users> list = res.isNotEmpty ? res.map((c) => Users.fromJson(c)).toList() : [];

    return list;
  }
}