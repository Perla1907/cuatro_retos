
import 'dart:math';
import 'package:flutter/material.dart';

import '../servicios/peliculas_service.dart';
import '../modelos/pelicula.dart';
import '../widgets/pelicula_card.dart';

class PeliculasScreen extends StatefulWidget {
  const PeliculasScreen({super.key});

  @override
  State<PeliculasScreen> createState() => _PeliculasScreenState();
}

class _PeliculasScreenState extends State<PeliculasScreen> {
  final PeliculasService servicio = PeliculasService();

  late Future<List<Pelicula>> peliculas;

  String? estadoSeleccionado;

  final Map<String, List<int>> estadosAnimo = {
    '😊 Feliz': [35, 16],
    '😢 Triste': [18, 10749],
    '😱 Emocionado': [27, 53],
    '❤️ Romántico': [10749, 35],
    '🧠 Pensativo': [878, 9648],
    '⚡ Aventurero': [28, 12],
  };

  @override
  void initState() {
    super.initState();
    peliculas = servicio.consultarPeliculas();
  }

  void recomendarPelicula(List<Pelicula> lista) {
    if (estadoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero selecciona cómo te sientes'),
        ),
      );
      return;
    }

    final generos = estadosAnimo[estadoSeleccionado]!;

    final filtradas = lista.where((pelicula) {
      return pelicula.generos.any(
        (genero) => generos.contains(genero),
      );
    }).toList();

    if (filtradas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No encontramos películas para este estado de ánimo',
          ),
        ),
      );
      return;
    }

    final pelicula = filtradas[
      Random().nextInt(filtradas.length)
    ];

    mostrarDetalle(pelicula);
  }

  void mostrarDetalle(Pelicula pelicula) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pelicula.titulo),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pelicula.poster.isNotEmpty)
                Image.network(
                  'https://image.tmdb.org/t/p/w500${pelicula.poster}',
                  height: 200,
                ),

              const SizedBox(height: 12),

              Text(pelicula.sinopsis),

              const SizedBox(height: 8),

              Text(
                'Calificación: ${pelicula.calificacion.toStringAsFixed(1)}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pelicula>>(
      future: peliculas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final lista = snapshot.data ?? [];

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '¿Cómo te sientes hoy?',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                initialValue: estadoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Selecciona tu estado de ánimo',
                  border: OutlineInputBorder(),
                ),
                items: estadosAnimo.keys.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    estadoSeleccionado = valor;
                  });
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                onPressed: () => recomendarPelicula(lista),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Recomiéndame una película'),
              ),
            ),

            const Text(
              'Películas populares',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  return PeliculaCard(
                    pelicula: lista[index],
                    onTap: () => mostrarDetalle(lista[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
