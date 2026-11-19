import 'dart:convert';
import 'package:api_retos/modelos/criptomonedas.dart';
import 'package:http/http.dart' as http;


class CryptoService {
  Future<List<Criptomoneda>> consultarPrecios() async {
    final url = Uri.https(
      'api.coingecko.com',
      '/api/v3/simple/price',
      {
        'ids': 'bitcoin,ethereum,solana',
        'vs_currencies': 'usd',
      },
    );

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);

      return [
        Criptomoneda(
          nombre: 'Bitcoin',
          id: 'bitcoin',
          simbolo: 'BTC',
          precio: (datos['bitcoin']['usd'] as num).toDouble(),
        ),
        Criptomoneda(
          nombre: 'Ethereum',
          id: 'ethereum',
          simbolo: 'ETH',
          precio: (datos['ethereum']['usd'] as num).toDouble(),
        ),
        Criptomoneda(
          nombre: 'Solana',
          id: 'solana',
          simbolo: 'SOL',
          precio: (datos['solana']['usd'] as num).toDouble(),
        ),
      ];
    } else {
      throw Exception('Error al consultar criptomonedas');
    }
  }
}