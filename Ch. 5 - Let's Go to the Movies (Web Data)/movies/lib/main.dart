// lib/main.dart

import 'package:flutter/material.dart' show BuildContext, ColorScheme, Colors, MaterialApp, StatelessWidget, ThemeData, Widget, runApp;
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

import 'home.dart';


Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyMovies());
}


class MyMovies extends StatelessWidget {
  const MyMovies({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const Home(),
    );
  }
}
