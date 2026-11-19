class GatosService {
  String generarUrlGato(String texto) {
    final frase = Uri.encodeComponent(texto);

    return 'https://cataas.com/cat/says/$frase'
        '?fontSize=40&fontColor=white';
  }
}