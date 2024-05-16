import 'dart:convert';

import 'package:movie_app_flutter/constant.dart';
import 'package:movie_app_flutter/models/genre_model.dart';
import 'package:movie_app_flutter/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app_flutter/models/videos_model.dart';

class MovieServices {
  static Future<List<Movie>> getMovies(String fleg,
      {http.Client? client, String? query}) async {
    String url = '$baseURL/trending/movie/day?api_key=$apiKey';

    if (fleg == 'upcoming') {
      url = '$baseURL/movie/upcoming?api_key=$apiKey';
    }

    if (fleg == 'now_playing') {
      url = '$baseURL/movie/now_playing?api_key=$apiKey';
    }

    if (fleg == 'search') {
      url = '$baseURL/search/movie?api_key=$apiKey&query=$query';
    }

    if (fleg == 'genre') {
      url = '$baseURL/discover/movie?api_key=$apiKey&with_genres=$query';
    }

    client ??= http.Client();

    final response = await client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return [];
    }

    var data = json.decode(response.body);
    List result = data['results'];

    return result.map((e) => Movie.fromJson(e)).toList();
  }

  static Future<List<Genres>> getGenres({http.Client? client}) async {
    String url = '$baseURL/genre/movie/list?api_key=$apiKey';

    client ??= http.Client();

    final response = await client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return [];
    }

    var data = json.decode(response.body);
    List result = data['genres'];

    return result.map((e) => Genres.fromJson(e)).toList();
  }

  static Future<List<Videos>> getVideos(int id, {http.Client? client}) async {
    String url = '$baseURL/movie/$id/videos?api_key=$apiKey';

    client ??= http.Client();

    final response = await client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return [];
    }

    var data = json.decode(response.body);
    List result = data['results'];

    return result.map((e) => Videos.fromJson(e)).toList();
  }
}
