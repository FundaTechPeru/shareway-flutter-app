import '../../core/network/api_client.dart';
import '../models/fare_models.dart';

class FareRepository {
  FareRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  /// Obtiene la estimación de tarifa para un grupo específico de viaje (GET /fares/estimate?groupId={groupId}).
  Future<FareEstimate> getFareEstimate(String groupId) async {
    final response = await _apiClient.get(
      '/fares/estimate',
      queryParameters: {'groupId': groupId},
    );
    return FareEstimate.fromJson(response as Map<String, dynamic>);
  }
}
