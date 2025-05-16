// lib/util/dbhelper.dart
/*
 * This file will contain the methods to create the database, and to retrieve and write data.
 */

import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm, Database, getDatabasesPath, openDatabase;

import '../models/list_items.dart';
import '../models/shopping_list.dart';


class DBHelper {
  final int version = 2; // Version of the database, beginning at 1
  Database? db;

  /*
  Create a method that will open the database if it exists, or create it if it doesn't.
  Database operations may take some time to execute, especially when they involve dealing with a large quantity of data, they are asynchronous.
  Therefore, the function will be asynchronous and return a Future type.
  */
  Future<Database> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
      onCreate: (database, version) { // The onCreate parameter will only be called if the database at the path specified is not found, or the version is different
        database.execute(
          'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)'
        );
        database.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER, name TEXT, quantity TEXT, note TEXT, '
          + 
          'FOREIGN KEY(idList) REFERENCES lists(id))'
        );
      },version: version
    );
    return db!;
  }

  Future testDb() async {
    db = await openDb(); // The first time you call this method, the database is created

    await db?.execute('INSERT INTO lists VALUES (0, "Fruit", 2)');
    await db?.execute('INSERT INTO items VALUES (0, 0, "Apples", "2 kg", "Better if they are green")');

    List lists = await db!.rawQuery('SELECT * FROM lists');
    List items = await db!.rawQuery('SELECT * FROM items');

    print(lists[0].toString());
    print(items[0].toString());
  }

  Future<int> insertList(ShoppingList list) async {
    int id = await db!.insert(
      'lists',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    return id;
  }

  Future<int> insertItem(ListItem item) async {
    int id = await db!.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    return id;
  }
}