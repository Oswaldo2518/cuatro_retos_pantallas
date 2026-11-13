import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dominio/modelos.dart';
import 'config_claves.dart';

class Servicios {
  Future<Map<String, dynamic>> consultar(Uri url) async {
    final respuesta = await http.get(url).timeout(const Duration(seconds: 20));
    if (respuesta.statusCode != 200) {
      if (respuesta.statusCode == 429) {
        throw Exception('Demasiadas consultas a la API. Intenta más tarde.');
      }
      throw Exception('La API respondió con error ${respuesta.statusCode}.');
    }
    return jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
  }

  // 1. Películas: TMDB. Los datos se obtienen solamente desde la API.
  Future<List<Pelicula>> obtenerPeliculas() async {
    if (ConfigClaves.tmdb.isEmpty) {
      throw Exception('Falta TMDB_API_KEY en el archivo de claves.');
    }
    final url = Uri.https('api.themoviedb.org', '/3/trending/movie/week', {
      'api_key': ConfigClaves.tmdb,
      'language': 'es-MX',
    });
    final datos = await consultar(url);
    return (datos['results'] as List<dynamic>)
        .map((elemento) => Pelicula.desdeJson(elemento as Map<String, dynamic>))
        .toList();
  }

  // 2. Gatos: Cataas. Devuelve la URL real de una imagen con texto y efectos.
  String generarUrlGato(String texto, String filtro, String colorTexto) {
    if (texto.trim().isEmpty) {
      throw Exception('Escribe una frase para el meme.');
    }
    final parametros = <String, String>{
      'fontSize': '42',
      'fontColor': colorTexto,
      't': '${DateTime.now().millisecondsSinceEpoch}',
    };
    if (filtro == 'mono') {
      parametros['filter'] = 'mono';
    } else if (filtro == 'violeta') {
      parametros.addAll({'filter': 'custom', 'r': '190', 'g': '100', 'b': '220'});
    } else if (filtro == 'azul') {
      parametros.addAll({'filter': 'custom', 'r': '90', 'g': '170', 'b': '255'});
    }
    return Uri(
      scheme: 'https',
      host: 'cataas.com',
      pathSegments: ['cat', 'says', texto.trim()],
      queryParameters: parametros,
    ).toString();
  }

  // 3. Clima: OpenWeatherMap.
  Future<ClimaActual> obtenerClima(String ciudad) async {
    if (ConfigClaves.openWeather.isEmpty) {
      throw Exception('Falta OPENWEATHER_API_KEY en el archivo de claves.');
    }
    if (ciudad.trim().isEmpty) throw Exception('Escribe una ciudad.');
    final url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': ciudad.trim(),
      'appid': ConfigClaves.openWeather,
      'units': 'metric',
      'lang': 'es',
    });
    return ClimaActual.desdeJson(await consultar(url));
  }

  // 4. Criptomonedas: CoinGecko público SIN token ni API Key.
  Future<PreciosCrypto> obtenerPrecios() async {
    final url = Uri.https('api.coingecko.com', '/api/v3/simple/price', {
      'ids': 'bitcoin,ethereum,solana',
      'vs_currencies': 'usd',
    });
    return PreciosCrypto.desdeJson(await consultar(url));
  }
}
