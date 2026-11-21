import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../auth/auth_service.dart';
import '../auth/token_storage.dart';

/// Interceptor que inyecta cabeceras de autorización y trazabilidad (X-Request-Id)
/// y captura respuestas 401 para limpiar sesión.
class AuthInterceptor extends Interceptor {
  static const _uuid = Uuid();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Inyectar X-Request-Id en cada solicitud para auditoría en el gateway
    options.headers['X-Request-Id'] = _uuid.v4();

    final path = options.path;
    final isPublicAuthEndpoint =
        path.contains('/auth/login') || path.contains('/auth/register');

    if (!isPublicAuthEndpoint) {
      final token = await TokenStorage.instance.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;
    final isPublicAuthEndpoint =
        path.contains('/auth/login') || path.contains('/auth/register');

    if (statusCode == 401 && !isPublicAuthEndpoint) {
      // Limpiar sesión local e informar al listener de navegación
      AuthService.instance.logout();
    }

    handler.next(err);
  }
}
