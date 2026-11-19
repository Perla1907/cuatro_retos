import 'package:flutter/material.dart';
import '../modelos/pelicula.dart';

class PeliculaCard extends StatelessWidget {
  final Pelicula pelicula;
  final VoidCallback onTap;

  const PeliculaCard({
    super.key,
    required this.pelicula,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: pelicula.poster.isEmpty
            ? const Icon(Icons.movie)
            : Image.network(
                'https://image.tmdb.org/t/p/w500${pelicula.poster}',
                width: 60,
                fit: BoxFit.cover,
              ),
        title: Text(pelicula.titulo),
        subtitle: Text(
          'Calificación: ${pelicula.calificacion.toStringAsFixed(1)}',
        ),
        onTap: onTap,
      ),
    );
  }
}