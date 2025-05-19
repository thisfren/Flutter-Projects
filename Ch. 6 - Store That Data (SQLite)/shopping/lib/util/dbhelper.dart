// lib/util/dbhelper.dart
/*
 * This file will contain the methods to create the database, and to retrieve and write data.
 */

import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm, Database, getDatabasesPath, openDatabase;

import '../models/list_items.dart';
import '../models/shopping_list.dart';


/*
In Dart and Flutter, there is a feature called "factory constructors" that overrides the default behavior when you call the constructor of a class:
instead of creating a new instance, the factory constructor only returns an instance of the class.
*/
class DBHelper {
  static final DBHelper _dbHelper = DBHelper._internal();

  DBHelper._internal(); // First, we are creating a private constructor named _internal

  factory DBHelper() { // Then, in the factory constructor, we just return it to the outside caller
    return _dbHelper;
  }

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

    await db!.execute('INSERT INTO lists VALUES (0, "Fruit", 2)');
    await db!.execute('INSERT INTO items VALUES (0, 0, "Apples", "2 kg", "Better if they are green")');

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

  /*
  A function that retrieves the content of the lists table in our database.
  Make sure to call this function only after an await dp.open call to avoid runtime errors
  */
  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db!.query('lists');


    return List.generate(maps.length, (i) { // The return value here is a List of ShoppingList objects
        return ShoppingList(maps[i]['id'],
                            maps[i]['name'],
                            maps[i]['priority']
        );
      }
    );
  }

  /*
  A method that queries the database in the items table, passing the ID of the ShoppingList that was selected, and returns all the retrieved elements.
  */
  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps = await db!.query('items',
                                                    where: 'idList = ?',
                                                    whereArgs: [idList]
                                                  );
    
    return List.generate(maps.length, (i) {
        return ListItem(maps[i]['id'],
                        maps[i]['idList'],
                        maps[i]['name'],
                        maps[i]['quantity'],
                        maps[i]['note']
        );
      }
    );
  }

  Future<int> deleteList(ShoppingList list) async {
    int result;
    result = await db!.delete('items', // First, delete all items associated with this shopping list
                        where: 'idList = ?',
                        whereArgs: [list.id]
                      );
    result = await db!.delete('lists', // Then, delete the shopping list itself
                        where: 'id = ?',
                        whereArgs: [list.id]
                      );

    return result;
  }
}