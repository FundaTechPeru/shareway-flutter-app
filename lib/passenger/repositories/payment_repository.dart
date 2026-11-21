import '../../core/network/api_client.dart';
import '../models/payment_models.dart';

class PaymentRepository {
  PaymentRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  /// Obtiene el historial de pagos propios (GET /payments/me).
  Future<List<PaymentItem>> getMyPayments() async {
    final response = await _apiClient.get('/payments/me');
    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((e) => PaymentItem.fromJson(e))
          .toList();
    }
    return [];
  }

  /// Obtiene el detalle de un pago propio (GET /payments/me/{id}).
  Future<PaymentItem> getPaymentDetail(String paymentId) async {
    final response = await _apiClient.get('/payments/me/$paymentId');
    return PaymentItem.fromJson(response as Map<String, dynamic>);
  }
}
