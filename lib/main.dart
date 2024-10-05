import 'package:flutter/material.dart';
import 'menu_screen.dart';


void main() {
  runApp(CafeteriaApp());
}

class CafeteriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafetería',
      theme: ThemeData(
        // Color de fondo de la aplicación
        scaffoldBackgroundColor: Colors.brown[50],

        // Color de texto personalizado
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.brown[900]),
          bodyMedium: TextStyle(color: Colors.brown[800]),
        ),

        // Tipo de fuente personalizada
        fontFamily: 'Georgia',

        // Estilo de AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown[400],
          foregroundColor: Colors.white,
        ),

        // Estilo de botones
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[400],
            foregroundColor: Colors.white,
            textStyle: TextStyle(
              fontFamily: 'Georgia',
            ),
          ),
        ),

        // Estilo de tarjetas
        cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: Colors.brown[100],
        ),
      ),
      home: MenuScreen(),
    );
  }
}

