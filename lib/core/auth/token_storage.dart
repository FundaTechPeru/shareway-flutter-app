import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Almacenamiento seguro del token JWT usando flutter_secure_storage.
class TokenStorage {
  TokenStorage._();

  static final TokenStorage instance = TokenStorage._();
  static const String _keyToken = 'shareway_access_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  String? _cachedToken;

  /// Guardar el accessToken.
  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _keyToken, value: token);
  }

  /// Leer el accessToken.
  Future<String?> getToken() async {
    _cachedToken ??= await _storage.read(key: _keyToken);
    return _cachedToken;
  }

  /// Eliminar el token de la sesión.
  Future<void> clearToken() async {
    _cachedToken = null;
    await _storage.delete(key: _keyToken);
  }

  /// Parsea el payload del JWT sin requerir librerías de terceros.
  Map<String, dynamic>? parseJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String payload = parts[1];
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }
      final decodedBytes = base64Url.decode(payload);
      final decodedString = utf8.decode(decodedBytes);
      return jsonDecode(decodedString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Verifica si hay un token guardado y si sigue vigente según su `exp`.
  Future<bool> hasValidToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;

    final payload = parseJwt(token);
    if (payload == null) return false;

    final exp = payload['exp'];
    if (exp is num) {
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(
        exp.toInt() * 1000,
      );
      return DateTime.now().isBefore(expiryDate);
    }
    return true;
  }

  /// Retorna el `sub` (User ID) del JWT guardado.
  Future<String?> getUserId() async {
    final token = await getToken();
    if (token == null) return null;
    final payload = parseJwt(token);
    return payload?['sub']?.toString();
  }

  /// Retorna el rol del token guardado.
  Future<String?> getRole() async {
    final token = await getToken();
    if (token == null) return null;
    final payload = parseJwt(token);
    return payload?['role']?.toString();
  }
}
