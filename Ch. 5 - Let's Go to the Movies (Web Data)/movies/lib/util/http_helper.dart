// lib/util/http_helper.dart
/*
 * We'll use this create the settings and methods that we'll use to connect to the web service.
 */

import 'dart:convert' show json;
import 'dart:io' show HttpStatus;

import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:http/http.dart' as http show Response, get;

import '../models/movie.dart' show Movie;


class HttpHelper {
  final String? apiKey = dotenv.env['API_KEY'];
  final String urlHost = 'api.themoviedb.org';


  Future<List?> findMovies(String title) async {
    final String urlSearchBase = '/3/search/movie';
    final query = Uri.https(
      urlHost,
      urlSearchBase,
      {
        'api_key': apiKey,
        'query=': title
      }
    );

    http.Response result = await http.get(query);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];

      List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();

      return movies;
    } else {
      return null;
    }
  }


  Future<List?> getUpcoming() async {
    final String urlBase = '/3/movie';
    final String urlUpcoming = '/upcoming';
    final String language = 'en-US';

    if (this.apiKey == null) {
      return null;
    }

    final String apiKey = this.apiKey!;
    final upcoming = Uri.https(
      urlHost,
      '$urlBase$urlUpcoming',
      {
        'api_key': apiKey,
        'language': language
      }
    );

    http.Response result = await http.get(upcoming);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];

      List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();

      return movies;
    } else {
      return null;
    }
  }
}