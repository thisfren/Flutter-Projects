// lib/ui/items_screen.dart
/*
 * Each time we'll get to this screen, it will be because we have selected a ShoppingList object. We will never need to call this screen independently.
 * So, it makes sense that when we create the ItemsScreen widget, we expect a ShoppingList to be passed.
 */ 
import 'package:flutter/material.dart' show AppBar, BuildContext, Icon, IconButton, Icons, ListTile, ListView, Scaffold, State, StatefulWidget, Text, Widget;

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
  List<ListItem> items = [];
  DBHelper helper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final ShoppingList shoppingList = widget.shoppingList;
    showData(shoppingList.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name)
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(items[index].name),
            subtitle: Text('Quantity: ${items[index].quantity} - Note: ${items[index].note}'),
            onTap: () {},
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            )
          );
        },
      )
    );
  }

  Future showData(int idList) async {
    await helper.openDb();

    items = await helper.getItems(idList);
    setState(() {
      items = items;
    });
  }
}