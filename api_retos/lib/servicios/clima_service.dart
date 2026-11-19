import 'dart:convert';
import 'package:http/http.dart' as http;

import '../modelos/clima.dart';
import '../configuracion/secrets.dart';

class ClimaService {
  Future<Clima> consultarClima(String ciudad) async {
    final url = Uri.https(
      'api.weatherapi.com',
      '/v1/current.json',
      {
        'key': Secrets.weatherApiKey,
        'q': ciudad,
        'lang': 'es',
      },
    );

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);

      return Clima.fromJson(datos);
    } else {
      throw Exception('No se pudo consultar el clima');
    }
  }
}