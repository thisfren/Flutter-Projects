// lib/ui/shopping_list_dialog.dart
/*
 * What we want to achieve here is showing our user a dialog window that allows them to insert or edit a ShoppingList.
 */

import 'package:flutter/material.dart' show AlertDialog, BuildContext, Column, ElevatedButton, InputDecoration, Navigator, RoundedRectangleBorder, SingleChildScrollView, Text, TextEditingController, TextField, TextInputType, Widget;
import 'package:flutter/painting.dart';

import '../util/dbhelper.dart' show DBHelper;
import '../models/shopping_list.dart' show ShoppingList;


/*
For this class, we want to show the user two textboxes, one for the title of the ShoppingList and one for the priority that the user will choose.
*/
class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    DBHelper helper = DBHelper();

    if (!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      title: Text(isNew ? 'New shopping list' : 'Edit shopping list'), // Inform whether this dialog is used to insert a new list or to update an existing one
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Shopping List Name'
              )
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Shopping List Priority (1-3)'
              )
            ),
            ElevatedButton(
              child: Text('Save Shopping List'),
              onPressed: () async {
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);

                await helper.insertList(list);
                
                if (context.mounted) {
                  Navigator.pop(context, list);
                }
              },
            )
          ],
        )
      )
    );
  }
}