import 'package:api_retos/modelos/criptomonedas.dart';
import 'package:flutter/material.dart';

import '../servicios/crypto_service.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final CryptoService servicio = CryptoService();
  final TextEditingController controlador = TextEditingController();

  late Future<List<Criptomoneda>> precios;

  @override
  void initState() {
    super.initState();
    precios = servicio.consultarPrecios();
  }

  void actualizar() {
    setState(() {
      precios = servicio.consultarPrecios();
    });
  }

  double calcularConversion(double monto, double precio) {
    return monto / precio;
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Criptomoneda>>(
      future: precios,
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

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Precios de criptomonedas',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...lista.map(
              (crypto) => Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.currency_bitcoin,
                    size: 35,
                  ),
                  title: Text(crypto.nombre),
                  subtitle: Text(crypto.simbolo),
                  trailing: Text(
                    '\$${crypto.precio.toStringAsFixed(2)} USD',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: actualizar,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar precios'),
            ),

            const Divider(height: 35),

            const Text(
              'Convertidor de USD',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextField(
              controller: controlador,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Cantidad en dólares',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            ...lista.map((crypto) {
              return ValueListenableBuilder<TextEditingValue>(
                valueListenable: controlador,
                builder: (context, value, child) {
                  final monto = double.tryParse(value.text) ?? 0;

                  final cantidad = monto > 0
                      ? calcularConversion(monto, crypto.precio)
                      : 0.0;

                  return Card(
                    child: ListTile(
                      title: Text('Equivalencia en ${crypto.nombre}'),
                      subtitle: Text(
                        '${cantidad.toStringAsFixed(8)} ${crypto.simbolo}',
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        );
      },
    );
  }
}