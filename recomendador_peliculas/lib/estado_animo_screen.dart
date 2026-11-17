
import 'package:flutter/material.dart';
import 'package:recomendador_peliculas/detalle_pelicula_screen.dart';
import 'package:recomendador_peliculas/prueba_api.dart';

class EstadoAnimoScreen extends StatefulWidget {
  const EstadoAnimoScreen({super.key});

  @override
  State<EstadoAnimoScreen> createState() =>
      _EstadoAnimoScreenState();
}

class _EstadoAnimoScreenState extends State<EstadoAnimoScreen> {
  String? estadoSeleccionado;
  Future<List<dynamic>>? peliculasRecomendadas;

  static const Color fondo = Color(0xFF10111B);
  static const Color superficie = Color(0xFF1B1D2A);
  static const Color morado = Color(0xFF8B5CF6);
  static const Color moradoClaro = Color(0xFFA78BFA);

  final Map<String, List<int>> generosPorEstado = {
    'Feliz': [35, 16],
    'Triste': [18, 10749],
    'Aburrido': [12, 28],
    'Emocionado': [53, 878],
    'Romántico': [10749, 35],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        title: const Text(
          'Recomendaciones',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Encabezado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF492B82),
                    Color(0xFF211936),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFD8C5FF),
                    size: 30,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Encuentra tu próxima película',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Elige cómo te sientes y descubre películas para ti.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              '¿Cómo te sientes hoy?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Opciones de estados de ánimo
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _crearOpcion('😊', 'Feliz'),
                _crearOpcion('😢', 'Triste'),
                _crearOpcion('😴', 'Aburrido'),
                _crearOpcion('😨', 'Emocionado'),
                _crearOpcion('❤️', 'Romántico'),
              ],
            ),

            const SizedBox(height: 20),

            // Resultados
            if (estadoSeleccionado != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Películas para cuando estás $estadoSeleccionado',
                  style: const TextStyle(
                    color: moradoClaro,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            if (peliculasRecomendadas != null)
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: peliculasRecomendadas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: morado,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error al cargar las recomendaciones',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    final peliculas = snapshot.data ?? [];

                    if (peliculas.isEmpty) {
                      return const Center(
                        child: Text(
                          'No se encontraron películas',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: peliculas.length,
                      itemBuilder: (context, index) {
                        final pelicula = peliculas[index];

                        return _tarjetaPelicula(pelicula);
                      },
                    );
                  },
                ),
              ),

            if (peliculasRecomendadas == null)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.movie_filter_outlined,
                        color: moradoClaro,
                        size: 65,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tus recomendaciones aparecerán aquí',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Tarjetas de estados de ánimo
  Widget _crearOpcion(String emoji, String estado) {
    final seleccionado = estadoSeleccionado == estado;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: seleccionado ? morado : superficie,
        foregroundColor: Colors.white,
        elevation: seleccionado ? 5 : 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: seleccionado
                ? moradoClaro
                : const Color(0xFF343044),
            width: seleccionado ? 2 : 1,
          ),
        ),
      ),
      onPressed: () {
        setState(() {
          estadoSeleccionado = estado;
          peliculasRecomendadas =
              consultarPeliculasPorGeneros(obtenerGeneros());
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 5),
          Text(
            estado,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Tarjetas de películas recomendadas
  Widget _tarjetaPelicula(dynamic pelicula) {
    return Card(
      color: superficie,
      margin: const EdgeInsets.symmetric(vertical: 7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetallePeliculaScreen(
                pelicula: pelicula,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: pelicula['poster_path'] != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w500${pelicula['poster_path']}',
                        width: 90,
                        height: 130,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _imagenAlternativa();
                        },
                      )
                    : _imagenAlternativa(),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pelicula['title'] ?? 'Sin título',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFBBF24),
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${pelicula['vote_average'] ?? 'N/A'}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      pelicula['overview'] ?? 'Sin descripción',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagenAlternativa() {
    return Container(
      width: 90,
      height: 130,
      color: const Color(0xFF29243B),
      child: const Icon(
        Icons.movie_outlined,
        size: 40,
        color: moradoClaro,
      ),
    );
  }

  List<int> obtenerGeneros() {
    return generosPorEstado[estadoSeleccionado] ?? [];
  }
}
