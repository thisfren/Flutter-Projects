// lib/ui/list_item_dialog.dart
/*
 * Challenge: Create the UI that will allow the user to insert and update items.
 */

import 'package:flutter/material.dart' show AlertDialog, BorderRadius, BuildContext, Column, ElevatedButton, InputDecoration, Navigator, RoundedRectangleBorder, SingleChildScrollView, Text, TextEditingController, TextField, Widget;

import '../util/dbhelper.dart' show DBHelper;
import '../models/list_items.dart' show ListItem;

class ListItemDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew) {
    DBHelper helper = DBHelper();

    if (!isNew) {
      txtName.text = item.name;
      txtQuantity.text = item.quantity;
      txtNote.text = item.note;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      title: Text(isNew ? 'New shopping item' : 'Edit shopping item'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Shopping Item Name'
              )
            ),
            TextField(
              controller: txtQuantity,
              decoration: InputDecoration(
                hintText: 'Quantity'
              )
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(
                hintText: 'Note'
              )
            ),
            ElevatedButton(
              child: Text('Save Shopping Item'),
              onPressed: () async {
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;

                await helper.insertItem(item);
                
                if (context.mounted) {
                  Navigator.pop(context, item);
                }
              },
            )
          ]
        )
      )
    );
  }
}