
import 'package:flutter/material.dart';

import '../servicios/clima_service.dart';
import '../modelos/clima.dart';

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  final ClimaService servicio = ClimaService();
  final TextEditingController controlador = TextEditingController();

  Clima? clima;
  bool cargando = false;
  String? error;

  Future<void> consultar() async {
    if (controlador.text.trim().isEmpty) {
      setState(() {
        error = 'Escribe el nombre de una ciudad';
      });
      return;
    }

    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final resultado = await servicio.consultarClima(
        controlador.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        clima = resultado;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = 'No se encontró la ciudad o hubo un error de conexión.';
        clima = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
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
            'Consulta el clima',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: controlador,
            decoration: const InputDecoration(
              labelText: 'Ciudad',
              hintText: 'Ej. Celaya',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_city),
            ),
            onSubmitted: (_) => consultar(),
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            onPressed: cargando ? null : consultar,
            icon: const Icon(Icons.search),
            label: const Text('Consultar clima'),
          ),

          const SizedBox(height: 20),

          if (cargando)
            const CircularProgressIndicator(),

          if (error != null)
            Text(
              error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),

          if (clima != null) ...[
            Image.network(
              'https:${clima!.icono}',
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.cloud,
                  size: 80,
                );
              },
            ),

            Text(
              clima!.ciudad,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              '${clima!.temperatura.toStringAsFixed(1)} °C',
              style: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              clima!.descripcion,
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.thermostat),
                    title: const Text('Sensación térmica'),
                    trailing: Text(
                      '${clima!.sensacion} °C',
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.water_drop),
                    title: const Text('Humedad'),
                    trailing: Text(
                      '${clima!.humedad}%',
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.air),
                    title: const Text('Viento'),
                    trailing: Text(
                      '${clima!.viento} km/h',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
