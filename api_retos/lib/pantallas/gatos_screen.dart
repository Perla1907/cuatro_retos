import 'package:flutter/material.dart';
import '../servicios/gatos_service.dart';

class GatosScreen extends StatefulWidget {
  const GatosScreen({super.key});

  @override
  State<GatosScreen> createState() => _GatosScreenState();
}

class _GatosScreenState extends State<GatosScreen> {
  final TextEditingController controlador = TextEditingController();
  final GatosService servicio = GatosService();

  String imagenUrl = 'https://cataas.com/cat';
  bool cargando = false;

  void generarMeme() {
    setState(() {
      cargando = true;

      imagenUrl = controlador.text.trim().isEmpty
          ? 'https://cataas.com/cat?timestamp=${DateTime.now().millisecondsSinceEpoch}'
          : servicio.generarUrlGato(controlador.text.trim()) +
              '&timestamp=${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            '¡Crea tu meme de gatos!',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: controlador,
            decoration: const InputDecoration(
              labelText: 'Escribe tu frase',
              hintText: 'Ej. Hoy no quiero trabajar',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            onPressed: generarMeme,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generar meme'),
          ),

          const SizedBox(height: 25),

          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imagenUrl,
              key: ValueKey(imagenUrl),
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }

                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: Text('No se pudo cargar el gato'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}