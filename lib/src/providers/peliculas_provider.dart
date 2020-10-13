import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/src/models/actores_model.dart';
import 'package:movie_app/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apiKey = '14d10c79b49581abba3239b6122dc1ca';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;

  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popoularesSink => _popularesStreamController.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void dispose() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> getEnCines() async {
    final uri = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});
    return await _procesarRespuesta(uri);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];
    _cargando = true;
    _popularesPage++;
    final uri = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });
    final response = await _procesarRespuesta(uri);
    _populares.addAll(response);
    popoularesSink(_populares);
    _cargando = false;
    return response;
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri uri) async {
    final response = await http.get(uri);
    final decodedData = json.decode(response.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Actor>> getCast(String peliculaId) async {
    final uri = Uri.https(_url, '3/movie/$peliculaId/credits',
        {'api_key': _apiKey, 'language': _language});

    final response = await http.get(uri);
    final decodedData = json.decode(response.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final uri = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});
    return await _procesarRespuesta(uri);
  }
}
