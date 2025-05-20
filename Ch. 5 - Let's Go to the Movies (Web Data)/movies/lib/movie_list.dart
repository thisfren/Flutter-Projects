// lib/movie_list.dart

import 'package:flutter/material.dart' show AppBar, BuildContext, Card, Center, Colors, EdgeInsets, ListTile, ListView, Padding, Scaffold, State, StatefulWidget, Text, Theme, Widget;

import './util/http_helper.dart';


class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List movies = [];
  int moviesCount = 0;
  late HttpHelper helper;

  @override
  void initState() {
    super.initState(); // It's conventional to call super.initState() first.
    helper = HttpHelper();
    _fetchMovies(); // Fetch movies when the state is initialized
  }

  Future<void> _fetchMovies() async {
    try {
      final List? moviesData = await helper.getUpcoming();
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          if (moviesData != null && moviesData.isNotEmpty) {
            movies = moviesData;
            moviesCount = movies.length;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          print('error fetching movies');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Data fetching is now done in _fetchMovies, called from initState.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'), // Use const for better performance
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center( // Center the content
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add some padding
          child: ListView.builder(
            itemCount: moviesCount,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.white,
                elevation: 2,
                child: ListTile(
                  title: Text(movies[index].title),
                  subtitle: Text('Released: ${movies[index].releaseDate} - Vote: ${movies[index].voteAverage.toString().substring(0,3)}')
                )
              );
            }
          ),
        ),
      ),
    );
  }
}