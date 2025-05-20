// lib/home.dart

import 'package:flutter/material.dart' show BuildContext, StatelessWidget, Widget;
import 'package:movies/movie_list.dart' show MovieList;


class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MovieList();
  }
}
