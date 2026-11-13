import 'package:flutter/material.dart';
import 'presentacion/pantallas/inicio.dart';

void main() {
  runApp(const CuatroRetosApp());
}

class CuatroRetosApp extends StatelessWidget {
  const CuatroRetosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Los cuatro retos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const PantallaInicio(),
    );
  }
}
