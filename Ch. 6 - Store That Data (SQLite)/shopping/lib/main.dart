// lib/main.dart

import 'package:flutter/material.dart' show AppBar, BuildContext, Center, CircleAvatar, CircularProgressIndicator, ColorScheme, Colors, Dismissible, FloatingActionButton, Icon, IconButton, Icons, Key, ListTile, ListView, MaterialApp, MaterialPageRoute, Navigator, Scaffold, State, StatefulWidget, StatelessWidget, Text, ThemeData, Widget, runApp, showDialog;

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
  List<ShoppingList> _shoppingList = [];
  DBHelper helper = DBHelper();
  ShoppingListDialog dialog = ShoppingListDialog();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    showData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: _isLoading
      ? const Center( // If shoppingList is null, it means data is still loading
          child: CircularProgressIndicator(), // Show a loading spinner
        )
      : ListView.builder( // Once data is loaded, build the list (or an empty state message)
          itemCount: _shoppingList.length, // Now we know shoppingList is not null
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(_shoppingList[index].name),
              onDismissed: (direction) async {
                String strName = _shoppingList[index].name;
                await helper.deleteList(_shoppingList![index]);
                setState(() {

                });
              },
              child: ListTile(
                title: Text(_shoppingList[index].name),
                leading: CircleAvatar(
                  child: Text(_shoppingList[index].priority.toString()) 
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemsScreen(shoppingList: _shoppingList[index]))
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final updatedList = await showDialog <ShoppingList>(
                      context: context,
                      builder: (BuildContext context) => dialog.buildDialog(context, _shoppingList[index], false)
                    );
                    if (updatedList != null) {
                      setState(() {
                        showData();
                      });
                    }
                  },
                )
              ),
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
          if (newList != null && mounted) {
            setState(() {
              showData();
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

    final shoppingList = await helper.getLists();
    if (mounted) { // Check if the widget is still in the tree
      setState(() { // Call the setState() method to tell our app that the ShoppingList has changed
        _shoppingList = shoppingList;
        _isLoading = false;
      });
    }
  }
}
