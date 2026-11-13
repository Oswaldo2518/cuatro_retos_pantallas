import 'package:flutter/material.dart';
import '../../datos/servicios.dart';
import '../../dominio/modelos.dart';

class PantallaCriptomonedas extends StatefulWidget {
  const PantallaCriptomonedas({super.key});

  @override
  State<PantallaCriptomonedas> createState() => _PantallaCriptomonedasState();
}

class _PantallaCriptomonedasState extends State<PantallaCriptomonedas> {
  final servicio = Servicios();
  final dolares = TextEditingController();
  PreciosCrypto? precios;
  double? monto;
  bool cargando = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => consultarPrecios());
  }

  @override
  void dispose() {
    dolares.dispose();
    super.dispose();
  }

  Future<void> consultarPrecios() async {
    if (cargando) return;
    setState(() {
      cargando = true;
      error = '';
    });
    try {
      final respuesta = await servicio.obtenerPrecios();
      if (mounted) setState(() => precios = respuesta);
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  void calcular(String texto) {
    final valor = double.tryParse(texto.trim().replaceAll(',', '.'));
    setState(() {
      monto = valor != null && valor.isFinite && valor >= 0 ? valor : null;
    });
  }

  Widget tarjetaMoneda(String nombre, String simbolo, double precio) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nombre, style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Precio actual: \$${precio.toStringAsFixed(2)} USD'),
            if (monto != null)
              Text('Con \$${monto!.toStringAsFixed(2)} USD = '
                  '${(monto! / precio).toStringAsFixed(8)} $simbolo'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criptomonedas - CoinGecko')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Precios actuales en USD desde la API pública de CoinGecko.'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: cargando ? null : consultarPrecios,
            child: const Text('Actualizar precios'),
          ),
          if (cargando) const LinearProgressIndicator(),
          if (error.isNotEmpty)
            Text(error, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          TextField(
            controller: dolares,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Cantidad en USD',
              hintText: 'Ejemplo: 100',
              border: OutlineInputBorder(),
            ),
            onChanged: calcular,
          ),
          if (dolares.text.isNotEmpty && monto == null)
            const Text('Introduce un monto válido de 0 o más.',
                style: TextStyle(color: Colors.red)),
          const SizedBox(height: 14),
          if (precios != null) ...[
            tarjetaMoneda('Bitcoin', 'BTC', precios!.bitcoin),
            tarjetaMoneda('Ethereum', 'ETH', precios!.ethereum),
            tarjetaMoneda('Solana', 'SOL', precios!.solana),
          ],
          const SizedBox(height: 12),
          const Text('Fuente: CoinGecko. Los valores son aproximados y pueden cambiar.',
              style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
