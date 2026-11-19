import 'dart:convert';


import 'package:http/http.dart' as http;

import '../modelos/pelicula.dart';
import '../configuracion/secrets.dart';

class PeliculasService {
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Pelicula>> consultarPeliculas() async {
    final url = Uri.parse('$baseUrl/movie/popular?language=es-MX');

    final respuesta = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${Secrets.tmdbToken}',
        'accept': 'application/json',
      },
    );

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);

      return (datos['results'] as List)
          .map((json) => Pelicula.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al consultar películas');
    }
  }

  Future<List<Map<String, dynamic>>> consultarGeneros() async {
    final url = Uri.parse(
      '$baseUrl/genre/movie/list?language=es-MX',
    );

    final respuesta = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${Secrets.tmdbToken}',
        'accept': 'application/json',
      },
    );

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);

      return List<Map<String, dynamic>>.from(datos['genres']);
    } else {
      throw Exception('Error al consultar géneros');
    }
  }
}