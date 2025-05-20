// lib/util/http_helper.dart
/*
 * We'll use this create the settings and methods that we'll use to connect to the web service.
 */

import 'dart:io' show HttpStatus;

import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:http/http.dart' as http show Response, get;


class HttpHelper {
  final String? apiKey = dotenv.env['API_KEY'];
  final String urlHost = 'api.themoviedb.org';
  final String urlBase = '/3/movie';
  final String urlUpcoming = '/upcoming';
  final String language = 'en-US';

  Future<String?> getUpcoming() async {
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
      return result.body;
    } else {
      return null;
    }
  }
}