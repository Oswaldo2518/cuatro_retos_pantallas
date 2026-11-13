import 'package:flutter/material.dart';
import '../../datos/servicios.dart';
import '../../dominio/modelos.dart';

class PantallaClima extends StatefulWidget {
  const PantallaClima({super.key});

  @override
  State<PantallaClima> createState() => _PantallaClimaState();
}

class _PantallaClimaState extends State<PantallaClima> {
  final servicio = Servicios();
  final ciudad = TextEditingController();
  ClimaActual? resultado;
  bool cargando = false;
  String error = '';

  @override
  void dispose() {
    ciudad.dispose();
    super.dispose();
  }

  Future<void> consultar() async {
    setState(() {
      resultado = null;
      error = '';
      cargando = true;
    });
    try {
      final datos = await servicio.obtenerClima(ciudad.text);
      if (mounted) setState(() => resultado = datos);
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima - OpenWeatherMap')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Consulta el clima actual de una ciudad.'),
          const SizedBox(height: 12),
          TextField(
            controller: ciudad,
            decoration: const InputDecoration(
              labelText: 'Nombre de la ciudad',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => consultar(),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: cargando ? null : consultar,
            child: const Text('Consultar clima'),
          ),
          if (cargando) const LinearProgressIndicator(),
          if (error.isNotEmpty)
            Text(error, style: const TextStyle(color: Colors.red)),
          if (resultado != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(resultado!.ciudad,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text('${resultado!.temperatura.toStringAsFixed(1)} °C',
                        style: const TextStyle(fontSize: 28)),
                    Text(resultado!.descripcion),
                    Text('Humedad: ${resultado!.humedad}%'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
