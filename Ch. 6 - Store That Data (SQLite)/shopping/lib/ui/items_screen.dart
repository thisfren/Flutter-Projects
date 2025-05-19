// lib/ui/items_screen.dart
/*
 * Each time we'll get to this screen, it will be because we have selected a ShoppingList object. We will never need to call this screen independently.
 * So, it makes sense that when we create the ItemsScreen widget, we expect a ShoppingList to be passed.
 */ 
import 'package:flutter/material.dart' show AppBar, BuildContext, Container, Scaffold, State, StatefulWidget, Text, Widget;

import '../models/list_items.dart' show ListItem;
import '../models/shopping_list.dart' show ShoppingList;
import '../util/dbhelper.dart' show DBHelper;


class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ItemsScreen({
    super.key,
    required this.shoppingList
  });

  @override
  State<ItemsScreen> createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;

  _ItemsScreenState(
    this.shoppingList
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name)
      ),
      body: Container()
    );
  }
}