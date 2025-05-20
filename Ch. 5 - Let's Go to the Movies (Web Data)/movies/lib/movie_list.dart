// lib/movie_list.dart

import 'package:flutter/material.dart' show AppBar, BuildContext, Card, Center, CircleAvatar, Colors, EdgeInsets, Icon, IconButton, Icons, ListTile, ListView, MaterialPageRoute, Navigator, NetworkImage, Padding, Scaffold, State, StatefulWidget, Text, TextField, TextInputAction, TextStyle, Theme, Widget;

import './util/http_helper.dart';
import './movie_details.dart';


class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Movies');
  List movies = [];
  int moviesCount = 0;
  final String imageBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
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
    String imagePath;
    // Data fetching is now done in _fetchMovies, called from initState.
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          IconButton(
            icon: visibleIcon,
            onPressed: () {
              setState(() {
                if (visibleIcon.icon == Icons.search) {
                  visibleIcon = Icon(Icons.cancel);
                  searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    )
                  );
                } else {
                  visibleIcon = Icon(Icons.search);
                  searchBar = Text('Movies');
                }
              });
            },
          )
        ]
      ),
      body: Center( // Center the content
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add some padding
          child: ListView.builder(
            itemCount: moviesCount,
            itemBuilder: (BuildContext context, int index) {
              imagePath = movies[index].posterPath == null
                        ? defaultImage
                        : imageBase + movies[index].posterPath;
              return Card(
                color: Colors.white,
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(imagePath),
                  ),
                  title: Text(movies[index].title),
                  subtitle: Text('Released: ${movies[index].releaseDate} - Vote: ${movies[index].voteAverage.toString().substring(0,3)}'),
                  onTap: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (_) => MovieDetails(movie: movies[index])
                    );
                    Navigator.push(context, route);
                  }
                )
              );
            }
          ),
        ),
      ),
    );
  }
}