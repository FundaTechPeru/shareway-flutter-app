import '../../core/auth/token_storage.dart';
import '../../core/network/api_client.dart';
import '../models/trip_request_models.dart';

class TripRequestRepository {
  TripRequestRepository({ApiClient? apiClient, TokenStorage? tokenStorage})
    : _apiClient = apiClient ?? ApiClient.instance,
      _tokenStorage = tokenStorage ?? TokenStorage.instance;

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  /// Crea una nueva solicitud de viaje (POST /trip-requests).
  Future<TripRequest> createTripRequest({
    required String originLabel,
    required String destinationLabel,
    required String travelDate,
    required String earliestDeparture,
    required String latestDeparture,
    int seatsRequested = 1,
    String operationZone = 'LIMA_METROPOLITANA',
    double? originLat,
    double? originLng,
    double? destLat,
    double? destLng,
  }) async {
    final passengerId = await _tokenStorage.getUserId() ?? '';

    final payload = {
      'passengerId': passengerId,
      'originLabel': originLabel,
      'destinationLabel': destinationLabel,
      'operationZone': operationZone,
      'travelDate': travelDate,
      'earliestDeparture': earliestDeparture,
      'latestDeparture': latestDeparture,
      'seatsRequested': seatsRequested,
      'originLat': ?originLat,
      'originLng': ?originLng,
      'destLat': ?destLat,
      'destLng': ?destLng,
    };

    final response = await _apiClient.post('/trip-requests', data: payload);
    return TripRequest.fromJson(response as Map<String, dynamic>);
  }

  /// Obtiene las solicitudes de viaje registradas del pasajero actual.
  Future<List<TripRequest>> getMyTripRequests() async {
    final currentUserId = await _tokenStorage.getUserId();
    final response = await _apiClient.get('/trip-requests');

    if (response is List) {
      final list = response
          .whereType<Map<String, dynamic>>()
          .map((e) => TripRequest.fromJson(e))
          .toList();

      if (currentUserId != null && currentUserId.isNotEmpty) {
        return list
            .where(
              (req) =>
                  req.passengerId == currentUserId || req.passengerId.isEmpty,
            )
            .toList();
      }
      return list;
    }
    return [];
  }

  /// Genera las propuestas de coincidencia para una solicitud de viaje.
  Future<List<MatchProposal>> generateMatchProposals(String requestId) async {
    final response = await _apiClient.post(
      '/trip-requests/$requestId/match-proposals',
    );
    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((e) => MatchProposal.fromJson(e))
          .toList();
    }
    return [];
  }

  /// Obtiene las propuestas de coincidencia ya generadas.
  Future<List<MatchProposal>> getMatchProposals(String requestId) async {
    final response = await _apiClient.get(
      '/trip-requests/$requestId/match-proposals',
    );
    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((e) => MatchProposal.fromJson(e))
          .toList();
    }
    return [];
  }
}
