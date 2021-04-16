import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'portfolioData.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  // Contains information about stock symbol and whether it is used in watchscreen
  static const table = 'my_table';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnAge = 'age';

  // Contains information on stock bought and its cost
  static const tableStock = 'my_stock';

  static const stockId = '_id';
  static const stockName = 'name';
  static const stockCount = 'count';
  static const stockCost = 'cost';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge INTEGER NOT NULL
          )
          ''');
    await _onCreateStock(db, version);
  }

  Future _onCreateStock(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableStock (
            $stockId INTEGER PRIMARY KEY,
            $stockName TEXT NOT NULL,
            $stockCount INTEGER NOT NULL,
            $stockCost DECIMAL (6,2) NOT NULL
          )
          ''');
  }

  static List<portData> allData;

  //Returns all the symbols in db
  Future<List<String>> getAllData() async {
    final allRows = await queryAllRows();

    List<String> portList = [];

    for (var oneRow in allRows) {
      var a = portData.storeAll(oneRow['id'], oneRow['name'], oneRow['age']);
      portList.add(a.name);
    }
    return portList;
  }

  // find whether symbol exists
  Future<int> getOneData(String name) async {
    List<String> port = await getAllData();
    String a;
    for (a in port) {
      if (a == name) {
        return 1; // if it exists
      }
    }
    return 0; // doesnt exist
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> insertStock(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableStock, row);
  }

  //The data present in the table is returned as a List of Map, where each
  // row is of type map
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsStock() async {
    Database db = await instance.database;
    return await db.query(tableStock);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> queryRowCountStock() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableStock'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryFindStock(String name) async {
    Database db = await instance.database;
    return await db
        .rawQuery('SELECT * FROM $tableStock WHERE $stockName = ?', [name]);
  }

  Future<int> updateStock(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String name = row[stockName];
    final result = await queryFindStock(name);
    num totalCount = row[stockCount];
    num totalCost = row[stockCost] * row[stockCount];
    for (var i = 0; i < result.length; i++) {
      totalCount += result[i]['count'];
      totalCost += (result[i]['cost'] * result[i]['count']);
    }
    totalCost /= totalCount;
    return await db.rawUpdate(
        'UPDATE $tableStock SET $stockCount = ?, $stockCost = ? WHERE $stockName = ?',
        [totalCount, totalCost, name]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String name) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnName = ?', whereArgs: [name]);
  }

  // deletes all row with input symbol
  Future<int> deleteStockSym(String name) async {
    Database db = await instance.database;
    return await db
        .delete(tableStock, where: '$stockName = ?', whereArgs: [name]);
  }

  // delete all row with input id
  Future<int> deleteStockId(int id) async {
    Database db = await instance.database;
    return await db.delete(tableStock, where: '$stockId = ?', whereArgs: [id]);
  }
}
