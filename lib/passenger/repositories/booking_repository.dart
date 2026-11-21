import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../core/auth/token_storage.dart';
import '../../core/network/api_client.dart';
import '../models/booking_models.dart';

class BookingRepository {
  BookingRepository({ApiClient? apiClient, TokenStorage? tokenStorage})
    : _apiClient = apiClient ?? ApiClient.instance,
      _tokenStorage = tokenStorage ?? TokenStorage.instance;

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;
  static const _uuid = Uuid();

  /// Crea una nueva reserva (POST /bookings).
  /// Exige cabeceras `X-User-Id` e `Idempotency-Key`.
  /// Si se reintenta por error de red, pasar el mismo [idempotencyKey].
  Future<BookingResponse> createBooking({
    required String groupId,
    required String requestId,
    String? idempotencyKey,
  }) async {
    final userId = await _tokenStorage.getUserId() ?? '';
    final key = idempotencyKey ?? _uuid.v4();

    final response = await _apiClient.post(
      '/bookings',
      data: {'groupId': groupId, 'requestId': requestId},
      options: Options(headers: {'X-User-Id': userId, 'Idempotency-Key': key}),
    );

    return BookingResponse.fromJson(response as Map<String, dynamic>);
  }

  /// Obtiene el estado actual de una reserva (GET /bookings/{bookingId}).
  Future<BookingResponse> getBooking(String bookingId) async {
    final response = await _apiClient.get('/bookings/$bookingId');
    return BookingResponse.fromJson(response as Map<String, dynamic>);
  }

  /// Cancela una reserva existente (POST /bookings/{bookingId}/cancel).
  /// Retorna el estado CANCELLED y la penalidad aplicada (penaltyAmount).
  Future<BookingCancellationResponse> cancelBooking(String bookingId) async {
    final userId = await _tokenStorage.getUserId() ?? '';

    final response = await _apiClient.post(
      '/bookings/$bookingId/cancel',
      options: Options(headers: {'X-User-Id': userId}),
    );

    return BookingCancellationResponse.fromJson(
      response as Map<String, dynamic>,
    );
  }
}
