// lib/main.dart

import 'package:flutter/material.dart';

import './util/dbhelper.dart';
import './models/list_items.dart';
import './models/shopping_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: ShList()
    );
  }
}


class ShList extends StatefulWidget {
  const ShList({super.key});

  @override
  State<ShList> createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  DBHelper helper = DBHelper();

  @override
  Widget build(BuildContext context) {
    showData();
    return Container();
  }

  Future showData() async {
    await helper.openDb(); // Makes sure the database has been opened before we try to insert data into it

    ShoppingList list = ShoppingList(0, 'Bakery', 2);
    int listId = await helper.insertList(list);

    ListItem item = ListItem(0, listId, 'Bread', 'note', '1 kg');
    int itemId = await helper.insertItem(item);

    print('List ID: ${listId.toString()}');
    print('Item ID: ${itemId.toString()}');
  }
}
