// lib/util/http_helper.dart
/*
 * We'll use this create the settings and methods that we'll use to connect to the web service.
 */


import 'dart:io' show HttpStatus;

import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:http/http.dart' as http show Response, get;

class HttpHelper {
  final String? urlKey = dotenv.env['API_KEY'];
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';

  Future<String?> getUpcoming() async {
    if (this.urlKey == null) {
      return null;
    }
    
    final String urlKey = this.urlKey!;
    final String upcoming = urlBase + urlUpcoming + urlKey + urlLanguage;
    
    http.Response result = await http.get(upcoming as Uri);

    if (result.statusCode == HttpStatus.ok) {
      return result.body;
    } else {
      return null;
    }
  }
}