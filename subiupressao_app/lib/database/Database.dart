import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subiupressao_app/database/MeasuresDataModel.dart';
import 'package:path/path.dart' as Path;

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  Future<Heart> getHeartyId(int id) async {
    final db = await database;
    var result = await db.query("Heart", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? Heart.fromMap(result.first) : Null;
  }



  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = Path.join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Heart ("
          "id INTEGER PRIMARY KEY,"
          //"dateTime STRING,"
          "heartRate INT,"
          "dateTime DATETIME"
          ")");
    });
  }

  newClient(Heart newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Client (id,heartRate)"
            " VALUES (?,?)",
        [newClient.id,newClient.heartRate]);
    return raw;
  }
  /*
  blockOrUnblock(Heart client) async {
    final db = await database;
    Heart blocked = Heart{
     id: client.id,
    heartRate: client.heartRate,
    dateTime: client.dateTime,
    var res = await db.update("Heart", blocked.toMap(),
    where: "id = ?", whereArgs: [client.id]);
    return res;
  }
  }*/
  Future<void> insertHeart(Heart heartr) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'Heart',
      heartr.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  updateClient(Heart newClient) async {
    final db = await database;
    var res = await db.update("Heart", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Heart", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Heart.fromMap(res.first) : null;
  }

  Future<List<Heart>> getBlockedClients() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db.query("Heart", where: "blocked = ? ", whereArgs: [1]);

    List<Heart> list =
    res.isNotEmpty ? res.map((c) => Heart.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Heart>> getAllClients() async {
    final db = await database;
    var res = await db.query("Heart");
    List<Heart> list =
    res.isNotEmpty ? res.map((c) => Heart.fromMap(c)).toList() : [];
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Heart", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from Heart");
  }
  }