import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secrets.dart';

Future<List<dynamic>> consultarPeliculas() async {
  final url = Uri.parse(
    'https://api.themoviedb.org/3/movie/popular?language=es-MX',
  );

  final respuesta = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $tmdbToken',
      'accept': 'application/json',
    },
  );

  if (respuesta.statusCode == 200) {

    final datos = jsonDecode(respuesta.body);

    final peliculas = datos['results'];

    return peliculas;
  } else {
    throw Exception('Error al consultar películas');
  }
}


Future<List<dynamic>> consultarGeneros() async {
  final url = Uri.parse(
    'https://api.themoviedb.org/3/genre/movie/list?language=es-MX',
  );

  final respuesta = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $tmdbToken',
      'accept': 'application/json',
    },
  );

  if (respuesta.statusCode == 200) {
    final datos = jsonDecode(respuesta.body);
    return datos['genres'];
  } else {
    throw Exception('Error al consultar géneros');
  }
}

Future<List<dynamic>> consultarPeliculasPorGeneros(
    List<int> idsGeneros) async {

  final url = Uri.parse(
    'https://api.themoviedb.org/3/discover/movie',
  ).replace(
    queryParameters: {
      'language': 'es-MX',
      'sort_by': 'popularity.desc',
      'with_genres': idsGeneros.join(','),
    },
  );

  final respuesta = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $tmdbToken',
      'accept': 'application/json',
    },
  );

  if (respuesta.statusCode == 200) {
    final datos = jsonDecode(respuesta.body);
    return datos['results'];
  } else {
    throw Exception('Error al consultar películas por género');
  }
}