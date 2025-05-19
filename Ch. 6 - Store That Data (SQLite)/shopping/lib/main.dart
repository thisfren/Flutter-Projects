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
  List<ShoppingList>? shoppingList;
  DBHelper helper = DBHelper();

  @override
  void initState() {
    super.initState();
    showData(); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    if (shoppingList == null) { // If shoppingList is null, it means data is still loading
      return Scaffold(
        appBar: AppBar(
          title: const Text('Shopping List'),
        ),
        body: const Center(
          child: CircularProgressIndicator(), // Show a loading spinner
        ),
      );
    }

    return Scaffold( // Once data is loaded, build the list (or an empty state message)
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: shoppingList!.length, // Now we know shoppingList is not null
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text(shoppingList![index].name));
        },
      ),
    );
  }

  Future showData() async {
    await helper.openDb(); // Makes sure the database has been opened before we try to insert data into it

    ShoppingList list = ShoppingList(0, 'Bakery', 2);
    int listId = await helper.insertList(list);

    ListItem item = ListItem(0, listId, 'Bread', 'note', '1 kg');
    int itemId = await helper.insertItem(item);
    
    /* Delete all the test code
    print('List ID: ${listId.toString()}');
    print('Item ID: ${itemId.toString()}');
    */

    shoppingList = await helper.getLists();
    setState(() { // Call the setState() method to tell our app that the ShoppingList has changed
      shoppingList = shoppingList;
    });
  }
}
