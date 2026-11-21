import 'package:flutter/foundation.dart';

import 'token_storage.dart';

/// Servicio singleton que gestiona el estado global de autenticación/sesión.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final ValueNotifier<bool> isAuthenticated = ValueNotifier<bool>(false);

  /// Evento notificado cuando vence o falla el token (401).
  final ValueNotifier<bool> onUnauthorized = ValueNotifier<bool>(false);

  /// Inicializa y verifica si hay una sesión activa válida.
  Future<bool> checkSession() async {
    final valid = await TokenStorage.instance.hasValidToken();
    isAuthenticated.value = valid;
    return valid;
  }

  /// Limpia la sesión y notifica logout.
  Future<void> logout() async {
    await TokenStorage.instance.clearToken();
    isAuthenticated.value = false;
    onUnauthorized.value = true;
  }
}
