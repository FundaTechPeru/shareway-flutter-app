import 'dart:async';

import 'package:dio/dio.dart';

import 'api_config.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';

/// Cliente HTTP unificado basado en Dio para conectar la app al API Gateway de ShareWay.
class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(AuthInterceptor());
  }

  static final ApiClient instance = ApiClient._();
  late final Dio _dio;

  Dio get rawDio => _dio;

  /// Método GET genérico con reintento automático y backoff para 429 / 502 / 503 / 504.
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetries = 2,
  }) async {
    final fullUrl = ApiConfig.buildUrl(path);
    int attempt = 0;

    while (attempt <= maxRetries) {
      try {
        final response = await _dio.get(
          fullUrl,
          queryParameters: queryParameters,
          options: options,
        );
        return response.data;
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode ?? 0;

        // Reintentar solo si es error 429 o 502/503/504 en GET
        if (attempt < maxRetries &&
            (statusCode == 429 || (statusCode >= 502 && statusCode <= 504))) {
          attempt++;
          int delayMs = attempt * 1000;

          // Si 503 tiene Retry-After
          final retryAfterHeader = e.response?.headers.value('Retry-After');
          if (retryAfterHeader != null) {
            final parsedSeconds = int.tryParse(retryAfterHeader);
            if (parsedSeconds != null && parsedSeconds > 0) {
              delayMs = parsedSeconds * 1000;
            }
          }
          await Future.delayed(Duration(milliseconds: delayMs));
          continue;
        }

        throw _handleDioError(e);
      } catch (e) {
        if (e is ApiException) rethrow;
        throw ApiException.networkError(e.toString());
      }
    }
  }

  /// Método POST genérico (sin reintento automático salvo que sea explícito).
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final fullUrl = ApiConfig.buildUrl(path);
    try {
      final response = await _dio.post(
        fullUrl,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException.networkError(e.toString());
    }
  }

  /// Método DELETE genérico.
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final fullUrl = ApiConfig.buildUrl(path);
    try {
      final response = await _dio.delete(
        fullUrl,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException.networkError(e.toString());
    }
  }

  /// Convierte una [DioException] en una [ApiException] estructurada.
  ApiException _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final statusCode = e.response!.statusCode ?? 500;
      final rawData = e.response!.data;

      int? retryAfterSeconds;
      final retryAfterHeader = e.response!.headers.value('Retry-After');
      if (retryAfterHeader != null) {
        retryAfterSeconds = int.tryParse(retryAfterHeader);
      }

      if (rawData is Map<String, dynamic>) {
        return ApiException.fromJson(
          statusCode,
          rawData,
          retryAfterSeconds: retryAfterSeconds,
        );
      } else {
        return ApiException(
          statusCode: statusCode,
          message: rawData.toString(),
          retryAfterSeconds: retryAfterSeconds,
        );
      }
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const ApiException(
        statusCode: 504,
        message: 'La conexión con el servidor tardó demasiado. Por favor, reintenta.',
        error: 'TimeoutError',
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return const ApiException(
        statusCode: 502,
        message: 'No se pudo conectar al servidor de ShareWay. Revisa tu conexión a internet.',
        error: 'ConnectionError',
      );
    }

    return ApiException.networkError(e.message ?? 'Error de conexión');
  }
}
