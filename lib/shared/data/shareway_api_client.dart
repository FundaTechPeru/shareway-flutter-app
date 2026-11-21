import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ShareWayApiException implements Exception {
  const ShareWayApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}

class ShareWayApiClient {
  ShareWayApiClient({required String baseUrl, http.Client? client})
    : _baseUri = _normalizeBaseUrl(baseUrl),
      _client = client ?? http.Client();

  final Uri _baseUri;
  final http.Client _client;
  String? bearerToken;

  static Uri _normalizeBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'baseUrl', 'Must not be empty.');
    }
    final normalized = trimmed.endsWith('/') ? trimmed : '$trimmed/';
    final uri = Uri.parse(normalized);
    if (!uri.hasAuthority || !uri.hasScheme) {
      throw ArgumentError.value(value, 'baseUrl', 'Must be an absolute URL.');
    }
    return uri;
  }

  Future<Map<String, dynamic>> getMap(String path) async =>
      _expectMap(await _send('GET', path));

  Future<List<dynamic>> getList(String path) async =>
      _expectList(await _send('GET', path));

  Future<Map<String, dynamic>> postMap(
    String path,
    Map<String, Object?> body, {
    bool authenticated = true,
  }) async => _expectMap(
    await _send('POST', path, body: body, authenticated: authenticated),
  );

  Future<Map<String, dynamic>> putMap(
    String path,
    Map<String, Object?> body,
  ) async => _expectMap(await _send('PUT', path, body: body));

  Future<Map<String, dynamic>> uploadFile({
    required String path,
    required String fieldName,
    required String filename,
    required List<int> bytes,
    required String mimeType,
  }) async {
    final request = http.MultipartRequest('POST', _uri(path))
      ..headers['Accept'] = 'application/json';
    final token = bearerToken;
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(
      http.MultipartFile.fromBytes(
        fieldName,
        bytes,
        filename: filename,
        contentType: MediaType.parse(mimeType),
      ),
    );
    final streamed = await _client
        .send(request)
        .timeout(const Duration(seconds: 25));
    final response = await http.Response.fromStream(streamed);
    final decoded = _decode(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ShareWayApiException(
        response.statusCode,
        _errorMessage(decoded, response.statusCode),
      );
    }
    return _expectMap(decoded);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, Object?>? body,
    bool authenticated = true,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json';
    final token = bearerToken;
    if (authenticated && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final request = http.Request(method, _uri(path))..headers.addAll(headers);
    if (body != null) request.body = jsonEncode(body);
    final streamed = await _client
        .send(request)
        .timeout(const Duration(seconds: 25));
    final response = await http.Response.fromStream(streamed);
    final decoded = _decode(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ShareWayApiException(
        response.statusCode,
        _errorMessage(decoded, response.statusCode),
      );
    }
    return decoded;
  }

  Uri _uri(String path) =>
      _baseUri.resolve(path.startsWith('/') ? path.substring(1) : path);

  dynamic _decode(http.Response response) {
    if (response.bodyBytes.isEmpty) return <String, dynamic>{};
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      return <String, dynamic>{'message': response.body};
    }
  }

  String _errorMessage(dynamic body, int statusCode) {
    if (body is Map<String, dynamic>) {
      final message = body['message'] ?? body['error'];
      if (message is String && message.trim().isNotEmpty) return message;
    }
    return 'El servidor respondió con el estado $statusCode.';
  }

  Map<String, dynamic> _expectMap(dynamic body) {
    if (body is Map<String, dynamic>) return body;
    throw const ShareWayApiException(
      502,
      'El servidor devolvió un formato de respuesta inesperado.',
    );
  }

  List<dynamic> _expectList(dynamic body) {
    if (body is List<dynamic>) return body;
    throw const ShareWayApiException(
      502,
      'El servidor devolvió un formato de lista inesperado.',
    );
  }

  void close() => _client.close();
}
