class Clima {
  final String ciudad;
  final double temperatura;
  final double sensacion;
  final int humedad;
  final double viento;
  final String descripcion;
  final String icono;

  Clima({
    required this.ciudad,
    required this.temperatura,
    required this.sensacion,
    required this.humedad,
    required this.viento,
    required this.descripcion,
    required this.icono,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      ciudad: json['location']['name'],
      temperatura: (json['current']['temp_c'] as num).toDouble(),
      sensacion: (json['current']['feelslike_c'] as num).toDouble(),
      humedad: json['current']['humidity'],
      viento: (json['current']['wind_kph'] as num).toDouble(),
      descripcion: json['current']['condition']['text'],
      icono: json['current']['condition']['icon'],
    );
  }
}