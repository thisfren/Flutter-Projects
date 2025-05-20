// lib/home.dart

import 'package:flutter/material.dart' show AppBar, BuildContext, Center, FloatingActionButton, Icon, Icons, Scaffold, StatelessWidget, Text, Theme, Widget;


class Home extends StatelessWidget {
  final String title;

  const Home({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
