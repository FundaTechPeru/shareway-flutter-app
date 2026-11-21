import '../../core/network/api_client.dart';
import '../models/trip_execution_models.dart';

class TripRepository {
  TripRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  /// Obtiene el detalle de un viaje en curso por su ID (GET /trips/{id}).
  Future<TripExecutionDetail> getTripDetail(String tripId) async {
    final response = await _apiClient.get('/trips/$tripId');
    return TripExecutionDetail.fromJson(response as Map<String, dynamic>);
  }
}
