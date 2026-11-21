import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';
import 'passenger_data.dart';

// TODO(gateway): sustituir por llamadas al API.

/// Datos de las vistas de perfil y ajustes (PAS-20 … PAS-24).
///
/// Cada vista solo lee sus datasets desde [PassengerData] o [ProfileData];
/// el copy de UI (títulos, botones, mensajes) permanece en la vista.
abstract class ProfileData {
  ProfileData._();

  // ── Mi perfil (PAS-22) ────────────────────────────────────────

  /// Cabecera de "Mi perfil": iniciales, nombre, antigüedad y rating.
  static const ProfileHeader header = ProfileHeader(
    initials: 'LP',
    name: 'Lucía Paredes',
    memberSince: 'Pasajera desde agosto de 2026',
    rating: '4.9 · 18 viajes',
  );

  // ── Editar perfil (PAS-23) ────────────────────────────────────

  /// Valores con los que se abre el formulario de edición.
  ///
  /// Usa el mismo modelo [PassengerAccount] que [PassengerData.account],
  /// pero con los textos exactos que muestra la vista. `location` no se
  /// muestra en estas vistas.
  static const PassengerAccount account = PassengerAccount(
    name: 'Lucía Paredes Rojas',
    location: 'Cerca de Linde, Lima',
    initials: 'LP',
    email: 'lucia.paredes@correo.pe',
    phone: '+51 987 654 321',
  );

  // ── Usuarios bloqueados (PAS-20) ──────────────────────────────

  /// Personas bloqueadas por el pasajero.
  static const List<BlockedUser> blockedUsers = [
    BlockedUser(
      initials: 'LT',
      name: 'Luis T.',
      meta: 'Pasajero · desde el 2 oct',
      background: AppColors.primarySoft,
      foreground: AppColors.primaryDark,
    ),
    BlockedUser(
      initials: 'MD',
      name: 'Marco D.',
      meta: 'Conductor · desde el 14 sep',
      background: AppColors.accentSoft,
      foreground: AppColors.warning,
    ),
  ];

  // ── Contactos de emergencia (PAS-21) ──────────────────────────

  /// Contactos que reciben SMS cuando se comparte un viaje o se activa
  /// una alerta.
  static const List<EmergencyContact> emergencyContacts = [
    EmergencyContact(
      initials: 'RP',
      name: 'Rosa Paredes',
      meta: 'Mamá · +51 987 112 204',
      background: AppColors.accentSoft,
      foreground: AppColors.warning,
      primary: true,
    ),
    EmergencyContact(
      initials: 'DP',
      name: 'Diego Paredes',
      meta: 'Hermano · +51 986 440 871',
      background: AppColors.primarySoft,
      foreground: AppColors.primaryDark,
      primary: false,
    ),
  ];
}

// ── Modelos ──────────────────────────────────────────────────────

/// Cabecera de "Mi perfil" (PAS-22).
class ProfileHeader {
  const ProfileHeader({
    required this.initials,
    required this.name,
    required this.memberSince,
    required this.rating,
  });

  /// Iniciales del avatar, por ejemplo `'LP'`.
  final String initials;

  final String name;

  /// Antigüedad en la plataforma, por ejemplo `'Pasajera desde agosto de 2026'`.
  final String memberSince;

  /// Resumen de calificación, por ejemplo `'4.9 · 18 viajes'`.
  final String rating;
}

/// Usuario bloqueado (PAS-20).
class BlockedUser {
  const BlockedUser({
    required this.initials,
    required this.name,
    required this.meta,
    required this.background,
    required this.foreground,
  });

  final String initials;
  final String name;

  /// Rol y fecha del bloqueo, por ejemplo `'Pasajero · desde el 2 oct'`.
  final String meta;

  final Color background;
  final Color foreground;
}

/// Contacto de emergencia (PAS-21).
class EmergencyContact {
  const EmergencyContact({
    required this.initials,
    required this.name,
    required this.meta,
    required this.background,
    required this.foreground,
    required this.primary,
  });

  final String initials;
  final String name;

  /// Parentesco y celular, por ejemplo `'Mamá · +51 987 112 204'`.
  final String meta;

  final Color background;
  final Color foreground;

  /// Si es el contacto principal (muestra la etiqueta "Principal").
  final bool primary;
}
