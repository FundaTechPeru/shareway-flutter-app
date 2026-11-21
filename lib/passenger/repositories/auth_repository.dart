import '../../core/auth/auth_service.dart';
import '../../core/auth/token_storage.dart';
import '../../core/network/api_client.dart';
import '../models/auth_models.dart';

class AuthRepository {
  AuthRepository({ApiClient? apiClient, TokenStorage? tokenStorage})
    : _apiClient = apiClient ?? ApiClient.instance,
      _tokenStorage = tokenStorage ?? TokenStorage.instance;

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  /// Inicia sesión y almacena el token JWT de forma segura.
  Future<LoginResponse> login(String email, String password) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final loginData = LoginResponse.fromJson(response as Map<String, dynamic>);
    await _tokenStorage.saveToken(loginData.accessToken);
    AuthService.instance.isAuthenticated.value = true;
    return loginData;
  }

  /// Registra un nuevo usuario con rol PASSENGER.
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final response = await _apiClient.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        'phone': phone,
        'role': 'PASSENGER',
      },
    );

    return RegisterResponse.fromJson(response as Map<String, dynamic>);
  }

  /// Obtiene el perfil del usuario autenticado (GET /users/me).
  Future<UserProfile> getProfile() async {
    final response = await _apiClient.get('/users/me');
    return UserProfile.fromJson(response as Map<String, dynamic>);
  }

  /// Cierra la sesión activa.
  Future<void> logout() async {
    await AuthService.instance.logout();
  }
}
