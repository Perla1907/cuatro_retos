import 'package:flutter/material.dart';
import 'package:recomendador_peliculas/detalle_pelicula_screen.dart';
import 'package:recomendador_peliculas/estado_animo_screen.dart';
import 'package:recomendador_peliculas/prueba_api.dart';

const Color fondo = Color(0xFF10111B);
const Color superficie = Color(0xFF1B1D2A);
const Color morado = Color(0xFF8B5CF6);
const Color moradoClaro = Color(0xFFA78BFA);

void main() {
  runApp(const RecomendadorApp());
}

class RecomendadorApp extends StatelessWidget {
  const RecomendadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineMood',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: fondo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: morado,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: fondo,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const PantallaPeliculas(),
    );
  }
}

class PantallaPeliculas extends StatefulWidget {
  const PantallaPeliculas({super.key});

  @override
  State<PantallaPeliculas> createState() => _PantallaPeliculasState();
}

class _PantallaPeliculasState extends State<PantallaPeliculas> {
  late Future<List<dynamic>> peliculas;
  late Future<List<dynamic>> generos;

  @override
  void initState() {
    super.initState();
    peliculas = consultarPeliculas();
    generos = consultarGeneros();
  }

  void abrirRecomendaciones() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EstadoAnimoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.movie_filter, color: moradoClaro),
            const SizedBox(width: 10),
            const Text(
              'CineMood',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mood, color: moradoClaro),
            tooltip: 'Recomendaciones',
            onPressed: abrirRecomendaciones,
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: FutureBuilder<List<dynamic>>(
        future: peliculas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: morado),
            );
          }

          if (snapshot.hasError) {
            return _mensajeEstado(
              Icons.error_outline,
              'No se pudieron cargar las películas',
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _mensajeEstado(
              Icons.movie_outlined,
              'No hay películas disponibles',
            );
          }

          final listaPeliculas = snapshot.data!;

          return FutureBuilder<List<dynamic>>(
            future: generos,
            builder: (context, snapshotGeneros) {
              if (snapshotGeneros.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: morado),
                );
              }

              if (snapshotGeneros.hasError) {
                return _mensajeEstado(
                  Icons.error_outline,
                  'No se pudieron cargar los géneros',
                );
              }

              final listaGeneros = snapshotGeneros.data ?? [];

              final Map<int, String> mapaGeneros = {
                for (var genero in listaGeneros)
                  genero['id']: genero['name'],
              };

              return ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  _encabezado(),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(18, 24, 18, 12),
                    child: Row(
                      children: [
                        Icon(Icons.local_fire_department,
                            color: moradoClaro),
                        SizedBox(width: 8),
                        Text(
                          'Películas populares',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ...List.generate(listaPeliculas.length, (index) {
                    final pelicula = listaPeliculas[index];

                    final idsGeneros =
                        pelicula['genre_ids'] as List? ?? [];

                    final nombresGeneros = idsGeneros
                        .map((id) => mapaGeneros[id] ?? 'Desconocido')
                        .join(' • ');

                    return _tarjetaPelicula(
                      pelicula,
                      nombresGeneros,
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _encabezado() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF492B82),
            Color(0xFF211936),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TU PRÓXIMA PELÍCULA FAVORITA',
            style: TextStyle(
              color: Color(0xFFD8C5FF),
              fontSize: 11,
              letterSpacing: 1.3,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '¿Qué quieres ver hoy?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Descubre películas que se adapten a tu estado de ánimo.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: abrirRecomendaciones,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Descubrir recomendaciones'),
            style: ElevatedButton.styleFrom(
              backgroundColor: morado,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaPelicula(
    dynamic pelicula,
    String nombresGeneros,
  ) {
    return Card(
      color: superficie,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
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
                        width: 100,
                        height: 145,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _imagenAlternativa();
                        },
                      )
                    : _imagenAlternativa(),
              ),

              const SizedBox(width: 14),

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
                        fontSize: 17,
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
                        const SizedBox(width: 4),
                        Text(
                          '${pelicula['vote_average'] ?? 'N/A'}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Text(
                      nombresGeneros.isEmpty
                          ? 'Géneros no disponibles'
                          : nombresGeneros,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: moradoClaro,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'Estreno: ${pelicula['release_date'] ?? 'Sin fecha'}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      pelicula['overview'] ?? 'Sin descripción',
                      maxLines: 3,
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
      width: 100,
      height: 145,
      color: const Color(0xFF29243B),
      child: const Icon(
        Icons.movie_outlined,
        size: 40,
        color: moradoClaro,
      ),
    );
  }

  Widget _mensajeEstado(IconData icono, String mensaje) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 50, color: moradoClaro),
          const SizedBox(height: 12),
          Text(
            mensaje,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
