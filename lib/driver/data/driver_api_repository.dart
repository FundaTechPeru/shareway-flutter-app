import '../domain/driver_api_models.dart';
import '../../shared/data/secure_session_store.dart';
import '../../shared/data/shareway_api_client.dart';

String _string(Map<String, dynamic> json, String key) =>
    json[key] is String ? json[key] as String : '';

class DriverApiRepository {
  DriverApiRepository({required this.client, SecureSessionStore? sessionStore})
    : _sessionStore = sessionStore ?? SecureSessionStore();

  final ShareWayApiClient client;
  final SecureSessionStore _sessionStore;

  Future<void> registerAccount({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    await client.postMap('/api/v1/auth/register', {
      'fullName': fullName.trim(),
      'email': email.trim(),
      'phone': phone.replaceAll(RegExp(r'[^+0-9]'), ''),
      'password': password,
    }, authenticated: false);
  }

  Future<DriverAccountSnapshot?> restoreSession() async {
    final token = await _sessionStore.readToken();
    if (token == null || token.isEmpty) return null;
    client.bearerToken = token;
    try {
      return await _loadAccount();
    } on ShareWayApiException catch (error) {
      if (error.statusCode == 401) {
        await signOut();
        return null;
      }
      rethrow;
    }
  }

  Future<DriverAccountSnapshot> signIn({
    required String email,
    required String password,
  }) async {
    final response = await client.postMap('/api/v1/auth/login', {
      'email': email.trim(),
      'password': password,
    }, authenticated: false);
    final token = response['accessToken'];
    if (token is! String || token.isEmpty) {
      throw const ShareWayApiException(
        502,
        'El inicio de sesión no devolvió un token válido.',
      );
    }
    await _sessionStore.saveToken(token);
    client.bearerToken = token;
    try {
      return await _loadAccount();
    } catch (_) {
      await signOut();
      rethrow;
    }
  }

  Future<DriverAccountSnapshot> _loadAccount() async {
    final user = await client.getMap('/api/v1/users/me');
    final role = _string(user, 'role');
    final driverProfile = role == 'DRIVER'
        ? await client.getMap('/api/v1/users/me/driver-profile')
        : null;
    return DriverAccountSnapshot.fromJson(user, driverProfile);
  }

  Future<DriverAccountSnapshot> registerDriverProfile({
    required String licenseNumber,
    required EmergencyContactData emergencyContact,
  }) async {
    await client.postMap('/api/v1/users/me/driver-profile', {
      'licenseNumber': licenseNumber.trim().toUpperCase(),
      'emergencyContact': emergencyContact.toJson(),
    });
    return _loadAccount();
  }

  Future<void> signOut() async {
    client.bearerToken = null;
    await _sessionStore.clearToken();
  }

  Future<List<DriverVehicleData>> listVehicles() async {
    final values = await client.getList('/api/v1/drivers/me/vehicles');
    return values
        .whereType<Map<String, dynamic>>()
        .map(DriverVehicleData.fromJson)
        .toList(growable: false);
  }

  Future<DriverVehicleData> saveVehicle(DriverVehicleData vehicle) async {
    final body = vehicle.toJson();
    final response = vehicle.id == null
        ? await client.postMap('/api/v1/drivers/me/vehicles', body)
        : await client.putMap(
            '/api/v1/drivers/me/vehicles/${Uri.encodeComponent(vehicle.id!)}',
            body,
          );
    return DriverVehicleData.fromJson(response);
  }

  Future<List<DriverDocumentData>> listDocuments() async {
    final values = await client.getList('/api/v1/drivers/me/documents');
    return values
        .whereType<Map<String, dynamic>>()
        .map(DriverDocumentData.fromJson)
        .toList(growable: false);
  }

  Future<DriverDocumentData> uploadDocument({
    required String type,
    required String filename,
    required List<int> bytes,
    required String mimeType,
  }) async {
    final response = await client.uploadFile(
      path:
          '/api/v1/drivers/me/documents?type=${Uri.encodeQueryComponent(type)}',
      fieldName: 'file',
      filename: filename,
      bytes: bytes,
      mimeType: mimeType,
    );
    return DriverDocumentData.fromJson(response);
  }

  Future<List<WeeklyAvailabilitySlot>> getAvailability() async {
    final response = await client.getMap('/api/v1/drivers/me/availability');
    final slots = response['slots'];
    if (slots is! List<dynamic>) return const [];
    return slots
        .whereType<Map<String, dynamic>>()
        .map(WeeklyAvailabilitySlot.fromJson)
        .toList(growable: false);
  }

  Future<void> saveAvailability(List<WeeklyAvailabilitySlot> slots) async {
    await client.putMap('/api/v1/drivers/me/availability', {
      'slots': slots.map((slot) => slot.toJson()).toList(growable: false),
    });
  }
}
