class Pelicula {
  final String titulo;
  final String descripcion;
  final String? poster;
  final double calificacion;

  Pelicula(this.titulo, this.descripcion, this.poster, this.calificacion);

  factory Pelicula.desdeJson(Map<String, dynamic> json) {
    final rutaPoster = json['poster_path'] as String?;
    return Pelicula(
      (json['title'] ?? json['original_title'] ?? 'Sin título').toString(),
      (json['overview'] ?? '').toString(),
      rutaPoster == null ? null : 'https://image.tmdb.org/t/p/w300$rutaPoster',
      (json['vote_average'] as num? ?? 0).toDouble(),
    );
  }
}

class ClimaActual {
  final String ciudad;
  final double temperatura;
  final int humedad;
  final String descripcion;

  ClimaActual(this.ciudad, this.temperatura, this.humedad, this.descripcion);

  factory ClimaActual.desdeJson(Map<String, dynamic> json) {
    final principal = json['main'] as Map<String, dynamic>;
    final condiciones = json['weather'] as List<dynamic>;
    return ClimaActual(
      (json['name'] ?? '').toString(),
      (principal['temp'] as num).toDouble(),
      (principal['humidity'] as num).toInt(),
      (condiciones.first as Map<String, dynamic>)['description'].toString(),
    );
  }
}

class PreciosCrypto {
  final double bitcoin;
  final double ethereum;
  final double solana;

  PreciosCrypto(this.bitcoin, this.ethereum, this.solana);

  factory PreciosCrypto.desdeJson(Map<String, dynamic> json) {
    double precioDe(String moneda) {
      final info = json[moneda] as Map<String, dynamic>;
      final precio = (info['usd'] as num).toDouble();
      if (precio <= 0) throw Exception('Precio inválido recibido de CoinGecko.');
      return precio;
    }

    return PreciosCrypto(
      precioDe('bitcoin'),
      precioDe('ethereum'),
      precioDe('solana'),
    );
  }
}
