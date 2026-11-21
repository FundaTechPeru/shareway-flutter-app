import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Configuración global de la API para ShareWay Passenger.
class ApiConfig {
  ApiConfig._();

  /// URL base por defecto del gateway.
  static String get defaultBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000';
      }
    } catch (_) {}
    return 'http://localhost:8000';
  }

  /// URL base configurada dinámicamente vía `--dart-define=API_BASE_URL=...`
  static String get baseUrl {
    const String configured = String.fromEnvironment('API_BASE_URL');
    if (configured.isNotEmpty) {
      return configured.endsWith('/')
          ? configured.substring(0, configured.length - 1)
          : configured;
    }
    return defaultBaseUrl;
  }

  /// Prefijo de API v1.
  static const String apiVersionPrefix = '/api/v1';

  /// URL completa del endpoint con prefijo.
  static String buildUrl(String path) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    if (cleanPath.startsWith(apiVersionPrefix)) {
      return '$baseUrl$cleanPath';
    }
    return '$baseUrl$apiVersionPrefix$cleanPath';
  }
}
