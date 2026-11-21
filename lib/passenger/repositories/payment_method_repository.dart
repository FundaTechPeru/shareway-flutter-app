import '../../core/network/api_client.dart';
import '../models/payment_models.dart';

class PaymentMethodRepository {
  PaymentMethodRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  /// Obtiene la lista de métodos de pago activos (GET /payment-methods).
  Future<List<PaymentMethodItem>> getPaymentMethods() async {
    final response = await _apiClient.get('/payment-methods');
    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((e) => PaymentMethodItem.fromJson(e))
          .toList();
    }
    return [];
  }

  /// Registra una nueva tarjeta con cardToken (POST /payment-methods).
  /// NOTA: La app nunca envía el número completo ni CVV; solo cardToken + brand + last4 + expiración.
  Future<PaymentMethodItem> addPaymentMethod({
    required String cardToken,
    required String brand,
    required String last4,
    required int expMonth,
    required int expYear,
  }) async {
    final response = await _apiClient.post(
      '/payment-methods',
      data: {
        'cardToken': cardToken,
        'brand': brand,
        'last4': last4,
        'expMonth': expMonth,
        'expYear': expYear,
      },
    );
    return PaymentMethodItem.fromJson(response as Map<String, dynamic>);
  }

  /// Desactiva/elimina un método de pago (DELETE /payment-methods/{id}).
  Future<void> deletePaymentMethod(String id) async {
    await _apiClient.delete('/payment-methods/$id');
  }
}
