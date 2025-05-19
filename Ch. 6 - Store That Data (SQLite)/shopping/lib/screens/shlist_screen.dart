// lib/screens/shlist_screen.dart

import 'package:flutter/material.dart' show AppBar, BuildContext, Center, CircleAvatar, CircularProgressIndicator, Dismissible, FloatingActionButton, Icon, IconButton, Icons, Key, ListTile, ListView, MaterialPageRoute, Navigator, Scaffold, ScaffoldMessenger, SnackBar, State, StatefulWidget, Text, Widget, showDialog;
import 'package:shopping/screens/items_screen.dart' show ItemsScreen;

import 'package:shopping/ui/shopping_list_dialog.dart' show ShoppingListDialog;
import 'package:shopping/models/shopping_list.dart' show ShoppingList;
import 'package:shopping/util/dbhelper.dart' show DBHelper;

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
              key: Key(_shoppingList[index].id.toString()),
              onDismissed: (direction) async {
                String strName = _shoppingList[index].name;
                await helper.deleteList(_shoppingList[index]);
                if (context.mounted) {
                  setState(() {
                    _shoppingList.removeAt(index);
                  });

                  ScaffoldMessenger
                    .of(context)
                    .showSnackBar(SnackBar(content: Text('$strName deleted')));
                }
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
