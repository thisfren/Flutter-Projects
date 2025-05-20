// lib/movie_details.dart


import 'package:flutter/material.dart' show AppBar, BuildContext, Center, Column, Container, EdgeInsets, Image, MediaQuery, Scaffold, SingleChildScrollView, StatelessWidget, Text, Theme, Widget;

import 'models/movie.dart' show Movie;


class MovieDetails extends StatelessWidget {
  final Movie movie;
  final String imageBase = 'https://image.tmdb.org/t/p/w500';

  const MovieDetails({
    super.key,
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String imagePath;
    imagePath = movie.posterPath.isEmpty
              ? 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg'
              : imageBase + movie.posterPath;
              
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                height: height / 1.5,
                child: Image.network(imagePath)
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Text(movie.overview)
              )
            ]
          )
        )
      )
    );
  }
}