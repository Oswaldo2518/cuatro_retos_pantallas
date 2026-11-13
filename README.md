# Cuatro retos Flutter: pantallas separadas

Aplicación para clase con **cinco pantallas**: menú principal, películas, memes de gatos, clima y criptomonedas. Se conserva la estructura `datos`, `dominio` y `presentacion`. Todo el contenido de películas, imágenes, clima y precios proviene de las APIs indicadas en el documento original.

## Estructura

```text
lib/
  main.dart
  datos/
    config_claves.dart
    servicios.dart
  dominio/
    modelos.dart
  presentacion/
    pantallas/
      inicio.dart
      peliculas.dart
      gatos.dart
      clima.dart
      criptomonedas.dart
```

## APIs exactas

- **TMDB:** `https://api.themoviedb.org/3/trending/movie/week` (necesita `TMDB_API_KEY` v3).
- **Cataas:** `https://cataas.com/cat/says/...` (sin clave; filtros de foto normal, blanco y negro, violeta o azul, y color de texto blanco/negro/amarillo).
- **OpenWeatherMap:** `https://api.openweathermap.org/data/2.5/weather` (necesita `OPENWEATHER_API_KEY`).
- **CoinGecko:** `https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd` (API Keyless pública, sin clave). Muestra los tres precios en USD y calcula fracciones según el monto introducido. **No solicita, utiliza ni necesita una clave de CoinGecko**. Las consultas gratuitas sin clave están sujetas a un límite compartido; si aparece 429, espera antes de reintentar.

## Configura tus claves

1. Copia `secrets.json.example` a `secrets.json` dentro de la carpeta principal del proyecto.
2. Coloca las **dos** claves en `secrets.json`:

```json
{
  "TMDB_API_KEY": "TU_CLAVE_V3_DE_TMDB",
  "OPENWEATHER_API_KEY": "TU_CLAVE_DE_OPENWEATHERMAP"
}
```

Para obtenerlas:
- TMDB: https://www.themoviedb.org/settings/api
- OpenWeatherMap: https://home.openweathermap.org/api_keys

Si prefieres editar directamente `secrets.json.example`, también es posible, pero ejecútalo con el nombre exacto en `--dart-define-from-file`. Ambos archivos están excluidos en `.gitignore` para reducir el riesgo de publicar tus claves.

## Ejecutar en VS Code / PowerShell

Abre la carpeta descomprimida y ejecuta:

```powershell
flutter create --platforms=android,web .
flutter pub get
flutter run -d chrome --dart-define-from-file=secrets.json
```

Si agregaste tus claves al archivo de ejemplo en vez de crear `secrets.json`, ejecuta:

```powershell
flutter run -d chrome --dart-define-from-file=secrets.json.example
```

El archivo con claves **no debe subirse a GitHub**. Aunque `--dart-define` evita dejarlas escritas en el código fuente, una aplicación web no garantiza ocultarlas a sus usuarios; úsala para un ejercicio educativo, no como protección de secretos de producción.

## Funcionamiento

- **Menú:** toca una tarjeta para ir a su propia pantalla; la flecha de retroceso regresa al inicio.
- **Películas:** tendencias o película aleatoria tomada de los resultados auténticos de TMDB.
- **Gatos:** escribe una frase, selecciona filtro/cambio de color y genera un gato desde Cataas. No se utilizan imágenes guardadas.
- **Clima:** ingresa una ciudad y consulta su temperatura, descripción y humedad desde OpenWeatherMap.
- **Criptomonedas:** al abrir se consultan los precios de Bitcoin, Ethereum y Solana. Introduce un monto de dólares y observa automáticamente la cantidad equivalente de cada criptomoneda: `monto USD / precio USD`. El botón permite actualizar precios; no hay conversión con resultados ficticios.

## Notas

Este ZIP tiene código fuente y configuración; Flutter generará las carpetas de las plataformas con `flutter create`. Para ejecutar en Android también necesitas el SDK de Android correctamente configurado. No ha podido compilarse en el entorno donde se preparó el archivo porque no está instalado Flutter.
