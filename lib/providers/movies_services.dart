//import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_fluutter/helpers/debouncer.dart';
import 'package:peliculas_fluutter/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = 'ab296cb3ff98750a06e731076f4d23f5';
  final String _baseUrl = 'api.themoviedb.org';
  final String _idioma = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> onCastingMovie = {};

  int _popularPage = 0;

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionsStreamController =
      new StreamController.broadcast();
  Stream<List<Movie>> get suggestionsStream =>
      this._suggestionsStreamController.stream;
  MoviesProvider() {
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String segment, [int page = 1]) async {
    var url = Uri.https(_baseUrl, segment,
        {'api_key': _apiKey, 'language': _idioma, 'page': '$page'});
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    this.onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await this._getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    this.popularMovies = [...popularMovies, ...popularResponse.results];

    notifyListeners();
  }

  Future<List<Cast>> getCastOnMovie(int movie_id) async {
    if (onCastingMovie.containsKey(movie_id)) return onCastingMovie[movie_id]!;
    final jsonData = await _getJsonData('3/movie/$movie_id/credits');
    final castingResponse = CastingResponse.fromJson(jsonData);
    onCastingMovie[movie_id] = castingResponse.cast;
    return castingResponse.cast;

    // notifyListeners();
  }

  Future<List<Movie>> searchMovie(String query) async {
    var url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _idioma, 'query': '$query'});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final result = await this.searchMovie(value);
      _suggestionsStreamController.add(result);
    };
    final timmer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });
    Future.delayed(Duration(milliseconds: 301)).then((_) => timmer.cancel());
  }
}
