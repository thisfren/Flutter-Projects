// lib/movie_list.dart

import 'package:flutter/material.dart' show AppBar, BuildContext, Container, Scaffold, State, StatefulWidget, Text, Theme, Widget;

import './util/http_helper.dart';


class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  String result = '';
  late HttpHelper helper;

  @override
  void initState() {
    helper = HttpHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper.getUpcoming().then(
      (value) {
        setState(() {
          if (value != null) {
            result = value;
          }
        });
      }
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        child: Text(result)
      )
    );
  }
}