import 'dart:math';
import 'package:flutter/material.dart';
import '../../datos/servicios.dart';
import '../../dominio/modelos.dart';

class PantallaPeliculas extends StatefulWidget {
  const PantallaPeliculas({super.key});

  @override
  State<PantallaPeliculas> createState() => _PantallaPeliculasState();
}

class _PantallaPeliculasState extends State<PantallaPeliculas> {
  final servicio = Servicios();
  List<Pelicula> peliculas = [];
  Pelicula? recomendada;
  bool cargando = false;
  String error = '';

  Future<void> consultar({bool alAzar = false}) async {
    setState(() {
      cargando = true;
      error = '';
      peliculas = [];
      recomendada = null;
    });
    try {
      final resultados = await servicio.obtenerPeliculas();
      if (!mounted) return;
      setState(() {
        if (alAzar && resultados.isNotEmpty) {
          recomendada = resultados[Random().nextInt(resultados.length)];
        } else {
          peliculas = resultados.take(10).toList();
        }
        if (resultados.isEmpty) error = 'TMDB no devolvió películas.';
      });
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Películas - TMDB')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Consulta películas en tendencia o recibe una recomendación.'),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ElevatedButton(
              onPressed: cargando ? null : () => consultar(),
              child: const Text('Ver tendencias'),
            ),
            ElevatedButton(
              onPressed: cargando ? null : () => consultar(alAzar: true),
              child: const Text('Recomendar al azar'),
            ),
          ]),
          if (cargando) const LinearProgressIndicator(),
          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error, style: const TextStyle(color: Colors.red)),
            ),
          if (recomendada != null) ...[
            const SizedBox(height: 16),
            Text(recomendada!.titulo,
                style: Theme.of(context).textTheme.titleLarge),
            if (recomendada!.poster != null)
              Image.network(recomendada!.poster!, height: 260,
                  alignment: Alignment.centerLeft,
                  errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 60)),
            Text('Calificación: ${recomendada!.calificacion.toStringAsFixed(1)}'),
            Text(recomendada!.descripcion),
          ],
          ...peliculas.map((p) => Card(
                child: ListTile(
                  leading: p.poster == null
                      ? const Icon(Icons.movie)
                      : Image.network(p.poster!, width: 55, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.movie)),
                  title: Text(p.titulo),
                  subtitle: Text('Calificación: ${p.calificacion.toStringAsFixed(1)}'),
                ),
              )),
          const SizedBox(height: 14),
          const Text('Datos de TMDB.', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
