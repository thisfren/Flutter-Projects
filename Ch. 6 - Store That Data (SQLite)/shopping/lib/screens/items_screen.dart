// lib/screens/items_screen.dart
/*
 * Each time we'll get to this screen, it will be because we have selected a ShoppingList object. We will never need to call this screen independently.
 * So, it makes sense that when we create the ItemsScreen widget, we expect a ShoppingList to be passed.
 */ 
import 'package:flutter/material.dart' show AppBar, BuildContext, Center, CircularProgressIndicator, FloatingActionButton, Icon, IconButton, Icons, ListTile, ListView, Scaffold, State, StatefulWidget, Text, Widget, showDialog;
import 'package:shopping/ui/list_item_dialog.dart';

import '../util/dbhelper.dart' show DBHelper;
import '../models/list_items.dart' show ListItem;
import '../models/shopping_list.dart' show ShoppingList;



class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ItemsScreen({
    super.key,
    required this.shoppingList
  });

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<ListItem> _items = [];
  DBHelper helper = DBHelper();
  ListItemDialog dialog = ListItemDialog();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    showData(widget.shoppingList.id);
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingList shoppingList = widget.shoppingList;
    showData(shoppingList.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name)
      ),
      body: _isLoading
      ? const Center (
        child: CircularProgressIndicator()
        )
      : ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_items[index].name),
              subtitle: Text('Quantity: ${_items[index].quantity} - Note: ${_items[index].note}'),
              onTap: () {},
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  final updatedItem = await showDialog <ListItem>(
                    context: context,
                    builder: (BuildContext context) => dialog.buildDialog(context, _items[index], false)
                  );
                  if (updatedItem != null) {
                    setState(() {
                      showData(shoppingList.id);
                    });
                  }
                }
              )
            );
          }
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async{
            final newItem = await showDialog <ListItem>(
              context: context,
              builder: (BuildContext context) => dialog.buildDialog(context, ListItem(0, shoppingList.id, '', '', ''), true)
            );
            if (newItem != null && mounted) {
              setState(() {
                showData(shoppingList.id);
              });
            }
          }
        ),
    );
  }

  Future showData(int idList) async {
    await helper.openDb();

    final items = await helper.getItems(idList);

    if(mounted) {
      setState(() {
        _items = items;
        _isLoading = false;
      });
    }
  }
}