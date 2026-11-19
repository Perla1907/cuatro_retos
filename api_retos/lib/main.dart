import 'package:flutter/material.dart';
import 'pantallas/inicio_screen.dart';

void main() {
  runApp(const ApiChallenge());
}

class ApiChallenge extends StatelessWidget {
  const ApiChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Challenge',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E2E),
          foregroundColor: Colors.white,
        ),
      ),

      home: const InicioScreen(),
    );
  }
}