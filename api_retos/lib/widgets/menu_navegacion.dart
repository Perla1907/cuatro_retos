import 'package:flutter/material.dart';

class MenuNavegacion extends StatelessWidget {
  final int indice;
  final ValueChanged<int> onSeleccionar;

  const MenuNavegacion({
    super.key,
    required this.indice,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: indice,
      onDestinationSelected: onSeleccionar,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.movie),
          label: 'Películas',
        ),
        NavigationDestination(
          icon: Icon(Icons.pets),
          label: 'Gatos',
        ),
        NavigationDestination(
          icon: Icon(Icons.cloud),
          label: 'Clima',
        ),
        NavigationDestination(
          icon: Icon(Icons.currency_bitcoin),
          label: 'Crypto',
        ),
      ],
    );
  }
}