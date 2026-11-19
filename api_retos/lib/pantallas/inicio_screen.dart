import 'package:flutter/material.dart';

import 'peliculas_screen.dart';
import 'gatos_screen.dart';
import 'clima_screen.dart';
import 'crypto_screen.dart';

import '../widgets/menu_navegacion.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int indiceSeleccionado = 0;

  final List<Widget> pantallas = const [
    PeliculasScreen(),
    GatosScreen(),
    ClimaScreen(),
    CryptoScreen(),
  ];

  final List<String> titulos = [
    'MovieMood',
    'CatMemes',
    'WeatherNow',
    'CryptoConvert',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulos[indiceSeleccionado]),
        centerTitle: true,
      ),

      body: IndexedStack(
        index: indiceSeleccionado,
        children: pantallas,
      ),

      bottomNavigationBar: MenuNavegacion(
        indice: indiceSeleccionado,
        onSeleccionar: (indice) {
          setState(() {
            indiceSeleccionado = indice;
          });
        },
      ),
    );
  }
}