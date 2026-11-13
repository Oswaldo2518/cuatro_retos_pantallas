import 'package:flutter/material.dart';
import '../../datos/servicios.dart';

class PantallaGatos extends StatefulWidget {
  const PantallaGatos({super.key});

  @override
  State<PantallaGatos> createState() => _PantallaGatosState();
}

class _PantallaGatosState extends State<PantallaGatos> {
  final servicio = Servicios();
  final frase = TextEditingController();
  String filtro = 'ninguno';
  String colorTexto = 'white';
  String? urlGato;
  String error = '';

  @override
  void dispose() {
    frase.dispose();
    super.dispose();
  }

  void crearMeme() {
    try {
      setState(() {
        error = '';
        urlGato = servicio.generarUrlGato(frase.text, filtro, colorTexto);
      });
    } catch (e) {
      setState(() {
        urlGato = null;
        error = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memes de gatos - Cataas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Escribe una frase y personaliza la foto del gato.'),
          const SizedBox(height: 12),
          TextField(
            controller: frase,
            maxLength: 80,
            decoration: const InputDecoration(
              labelText: 'Frase del meme',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: filtro,
            decoration: const InputDecoration(
              labelText: 'Filtro de la foto',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'ninguno', child: Text('Sin efecto')),
              DropdownMenuItem(value: 'mono', child: Text('Blanco y negro')),
              DropdownMenuItem(value: 'violeta', child: Text('Tinte violeta')),
              DropdownMenuItem(value: 'azul', child: Text('Tinte azul')),
            ],
            onChanged: (valor) => setState(() => filtro = valor ?? 'ninguno'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: colorTexto,
            decoration: const InputDecoration(
              labelText: 'Color de la frase',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'white', child: Text('Blanco')),
              DropdownMenuItem(value: 'black', child: Text('Negro')),
              DropdownMenuItem(value: 'yellow', child: Text('Amarillo')),
            ],
            onChanged: (valor) => setState(() => colorTexto = valor ?? 'white'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: crearMeme, child: const Text('Generar meme')),
          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error, style: const TextStyle(color: Colors.red)),
            ),
          if (urlGato != null) ...[
            const SizedBox(height: 16),
            Image.network(
              urlGato!,
              key: ValueKey(urlGato),
              height: 320,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progreso) =>
                  progreso == null ? child : const LinearProgressIndicator(),
              errorBuilder: (_, __, ___) => const Text(
                'No se pudo mostrar la imagen de Cataas. Intenta otra vez.',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
