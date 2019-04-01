import 'package:my_fav/models/data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io' as io;

import 'package:my_fav/utils/enumerations.dart';

class DBHelper {
  static DBHelper _dbHelper;
  static Database _database;
  DBHelper._internal();

  factory DBHelper() {
    if (_dbHelper == null) {
      _dbHelper = DBHelper._internal();
    }
    return _dbHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  Future<Database> initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'myfav.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE image (id INTEGER PRIMARY KEY, name TEXT, path TEXT, date TEXT, alias TEXT, description TEXT)');
    await db.execute(
        'CREATE TABLE audio (id INTEGER PRIMARY KEY, name TEXT, path TEXT, date TEXT, alias TEXT, description TEXT)');
    await db.execute(
        'CREATE TABLE video (id INTEGER PRIMARY KEY, name TEXT, path TEXT, date TEXT, alias TEXT, description TEXT)');
    await db.execute(
        'CREATE TABLE document (id INTEGER PRIMARY KEY, name TEXT, path TEXT, date TEXT, alias TEXT, description TEXT)');
  }

  // Fetch operation: Get all objects from database.
  Future<List<Map<String, dynamic>>> getMapList(FileTypes type) async {
    Database db = await this.database;
    var result = db.query(_getTableName(type));
    return result;
  }

  Future<List<Map<String, dynamic>>> getMap(FileTypes type, int id) async {
    Database db = await this.database;
    var result = db.query(_getTableName(type), where: 'id = ?', whereArgs: [id]);
    return result;
  }

  //Insert operation: Insert object into the database.
  Future<int> insert(FileTypes type, Map<String, dynamic> map) async {
    Database db = await this.database;
    map['date'] = DateTime.now().toString();
    var result = db.insert(_getTableName(type), map);
    return result;
  }

  //Updateoperation: Update object and save into the database.
  Future<int> update(FileTypes type, Map<String, dynamic> map) async {
    Database db = await this.database;
    map['date'] = DateTime.now().toString();
     var result =
         db.update(_getTableName(type), map, where: 'id = ?', whereArgs: [map['id']]);
    return result;
  }

  //Delete operation: Delete object from the database.
  Future<int> delete(FileTypes type, int id) async {
    Database db = await this.database;
    var result = db.rawDelete('DELETE FROM ${_getTableName(type)} WHERE id = $id');
    return result;
  }

  //Get number of objects in database.
  Future<int> getCount(FileTypes type) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM ${_getTableName(type)}');
    var result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get the Map List and convert it to 'DataModel List'
  Future<List<DataModel>> getDataList(FileTypes type) async {
    var data = await getMapList(type);
    int count = data.length;
    List<DataModel> dataList = List<DataModel>();
    for (int i = 0; i < count; i++) {
      dataList.add(DataModel.fromMap(data[i]));
    }
    return dataList;
  }

  Future<DataModel> getData(FileTypes type, int id) async {
    var data = await getMap(type, id);
    return DataModel.fromMap(data[0]);
  }

  _getTableName(FileTypes type) {
    switch (type) {
      case FileTypes.Image:
        return 'image';
      case FileTypes.Audio:
        return 'audio';
      case FileTypes.Video:
        return 'video';
      case FileTypes.Documents:
        return 'document';
    }
  }
}
