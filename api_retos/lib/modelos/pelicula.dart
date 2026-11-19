class Pelicula {
  final int id;
  final String titulo;
  final String sinopsis;
  final String poster;
  final String fecha;
  final double calificacion;
  final List<int> generos;

  Pelicula({
    required this.id,
    required this.titulo,
    required this.sinopsis,
    required this.poster,
    required this.fecha,
    required this.calificacion,
    required this.generos,
  });

  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      id: json['id'] ?? 0,
      titulo: json['title'] ?? 'Sin título',
      sinopsis: json['overview'] ?? 'Sin descripción',
      poster: json['poster_path'] ?? '',
      fecha: json['release_date'] ?? '',
      calificacion: (json['vote_average'] ?? 0).toDouble(),
      generos: List<int>.from(json['genre_ids'] ?? []),
    );
  }
}