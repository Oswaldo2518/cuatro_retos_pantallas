import 'package:flutter/material.dart';
import 'peliculas.dart';
import 'gatos.dart';
import 'clima.dart';
import 'criptomonedas.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Los cuatro retos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Elige un reto',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.movie, size: 32),
              title: const Text('1. Películas'),
              subtitle: const Text('Tendencias y recomendación al azar con TMDB'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantallaPeliculas()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.pets, size: 32),
              title: const Text('2. Memes de gatos'),
              subtitle: const Text('Frases, filtros y colores con Cataas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantallaGatos()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud, size: 32),
              title: const Text('3. Clima'),
              subtitle: const Text('Consulta el clima de una ciudad'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantallaClima()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.currency_bitcoin, size: 32),
              title: const Text('4. Criptomonedas'),
              subtitle: const Text('Precios USD y equivalencias con CoinGecko'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantallaCriptomonedas()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
