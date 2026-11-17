
import 'package:flutter/material.dart';

class DetallePeliculaScreen extends StatelessWidget {
  final dynamic pelicula;

  const DetallePeliculaScreen({
    super.key,
    required this.pelicula,
  });

  static const Color fondo = Color(0xFF10111B);
  static const Color superficie = Color(0xFF1B1D2A);
  static const Color morado = Color(0xFF8B5CF6);
  static const Color moradoClaro = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    final posterPath = pelicula['poster_path'];

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        title: const Text(
          'Detalles de la película',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: fondo,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Póster de la película
            Container(
              width: double.infinity,
              height: 420,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF30204D),
                    fondo,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: posterPath != null
                  ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500$posterPath',
                          height: 350,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.movie_outlined,
                              size: 100,
                              color: moradoClaro,
                            );
                          },
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.movie_outlined,
                        size: 100,
                        color: moradoClaro,
                      ),
                    ),
            ),

            // Información de la película
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    pelicula['title'] ?? 'Sin título',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Calificación y fecha
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: superficie,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFBBF24),
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${pelicula['vote_average'] ?? 'N/A'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          'Estreno: ${pelicula['release_date'] ?? 'Sin fecha'}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Sinopsis
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: morado,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Sinopsis',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    pelicula['overview'] ?? 'Sin descripción disponible.',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botón para regresar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver a películas'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: morado,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
