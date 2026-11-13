// Las claves se leen de secrets.json o secrets.json.example al ejecutar Flutter.
// CoinGecko y Cataas no requieren clave para las peticiones de este proyecto.
class ConfigClaves {
  static const tmdb = String.fromEnvironment('TMDB_API_KEY');
  static const openWeather = String.fromEnvironment('OPENWEATHER_API_KEY');
}
