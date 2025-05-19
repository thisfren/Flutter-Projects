// lib/main.dart

import 'package:flutter/material.dart' show AppBar, BuildContext, Center, CircleAvatar, CircularProgressIndicator, ColorScheme, Colors, FloatingActionButton, Icon, IconButton, Icons, ListTile, ListView, MaterialApp, MaterialPageRoute, Navigator, Scaffold, State, StatefulWidget, StatelessWidget, Text, ThemeData, Widget, runApp, showDialog;

import './util/dbhelper.dart';
import './models/list_items.dart';
import './models/shopping_list.dart';
import './ui/items_screen.dart';
import './ui/shopping_list_dialog.dart';

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
  ShoppingListDialog dialog = ShoppingListDialog();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: shoppingList == null 
      ? Center( // If shoppingList is null, it means data is still loading
          child: CircularProgressIndicator(), // Show a loading spinner
        )
      : ListView.builder( // Once data is loaded, build the list (or an empty state message)
          itemCount: shoppingList!.length, // Now we know shoppingList is not null
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(shoppingList![index].name),
              leading: CircleAvatar(
                child: Text(shoppingList![index].priority.toString()) 
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemsScreen(shoppingList: shoppingList![index]))
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  final updatedList = await showDialog <ShoppingList>(
                    context: context,
                    builder: (BuildContext context) => dialog.buildDialog(context, shoppingList![index], false)
                  );
                  if (updatedList != null) {
                    setState(() {
                      // Updated list item
                    });
                  }
                },
              )
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newList = await showDialog <ShoppingList>(
            context: context,
            builder: (BuildContext context) => dialog.buildDialog(context, ShoppingList(0, '', 0), true)
          );
          if (newList != null) {
            setState(() {
              // New list was added
            });
          }
        },
      ),
    );
  }

  Future showData() async {
    await helper.openDb(); // Makes sure the database has been opened before we try to insert data into it

    /* Delete all the test code
    ShoppingList list = ShoppingList(0, 'Bakery', 2);
    int listId = await helper.insertList(list);

    ListItem item = ListItem(0, listId, 'Bread', 'note', '1 kg');
    int itemId = await helper.insertItem(item);

    print('List ID: ${listId.toString()}');
    print('Item ID: ${itemId.toString()}');
    */

    shoppingList = await helper.getLists();
    setState(() { // Call the setState() method to tell our app that the ShoppingList has changed
      shoppingList = shoppingList;
    });
  }
}
