/// Error en el formato de validación por campo retornado por el backend.
class FieldError {
  const FieldError({required this.field, required this.message});

  factory FieldError.fromJson(Map<String, dynamic> json) {
    return FieldError(
      field: json['field']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  final String field;
  final String message;
}

/// Excepción personalizada para respuestas de error de ShareWay API Gateway.
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.error,
    this.path,
    this.timestamp,
    this.fieldErrors = const [],
    this.retryAfterSeconds,
  });

  factory ApiException.fromJson(
    int statusCode,
    Map<String, dynamic> json, {
    int? retryAfterSeconds,
  }) {
    List<FieldError> errors = [];
    if (json['fieldErrors'] is List) {
      errors = (json['fieldErrors'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => FieldError.fromJson(e))
          .toList();
    }

    return ApiException(
      statusCode: statusCode,
      message:
          json['message']?.toString() ??
          json['error']?.toString() ??
          'Ocurrió un error inesperado',
      error: json['error']?.toString(),
      path: json['path']?.toString(),
      timestamp: json['timestamp']?.toString(),
      fieldErrors: errors,
      retryAfterSeconds: retryAfterSeconds,
    );
  }

  factory ApiException.networkError(String message) {
    return ApiException(statusCode: 0, message: message, error: 'NetworkError');
  }

  final int statusCode;
  final String message;
  final String? error;
  final String? path;
  final String? timestamp;
  final List<FieldError> fieldErrors;
  final int? retryAfterSeconds;

  bool get isValidationError => statusCode == 400 && fieldErrors.isNotEmpty;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;
  bool get isRateLimit => statusCode == 429;
  bool get isServerError => statusCode >= 500 && statusCode <= 504;

  /// Retorna el mensaje de error para un campo específico, si existe.
  String? getFieldError(String fieldName) {
    for (final err in fieldErrors) {
      if (err.field.toLowerCase() == fieldName.toLowerCase()) {
        return err.message;
      }
    }
    return null;
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
