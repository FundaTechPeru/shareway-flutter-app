/// Respuesta del login de usuario.
class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken']?.toString() ?? '',
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 3600,
    );
  }

  final String accessToken;
  final String tokenType;
  final int expiresIn;
}

/// Respuesta del registro de pasajero.
class RegisterResponse {
  const RegisterResponse({
    required this.id,
    required this.email,
    required this.role,
    this.createdAt,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'PASSENGER',
      createdAt: json['createdAt']?.toString(),
    );
  }

  final String id;
  final String email;
  final String role;
  final String? createdAt;
}

/// Perfil de usuario retornado por `/users/me`.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    this.driverStatus,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? 'PASSENGER',
      driverStatus: json['driverStatus']?.toString(),
    );
  }

  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String role;
  final String? driverStatus;
}
