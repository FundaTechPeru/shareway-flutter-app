import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Escala tipográfica de ShareWay: Roboto en tres pesos (400, 500 y 700).
abstract class AppTypography {
  /// Roboto es la fuente del sistema en Android.
  static const String fontFamily = 'Roboto';

  /// Título de pantalla — 28 / 700.
  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.2,
    color: AppColors.ink,
  );

  /// Título de sección — 19 / 500.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.ink,
  );

  /// Dato destacado — 19 / 700.
  static const TextStyle highlightedData = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.ink,
  );

  /// Cuerpo — 15 / 400.
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.ink,
  );

  /// Apoyo — 13 / 400.
  static const TextStyle support = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.ink2,
  );

  /// Etiqueta — 12 / 500.
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.ink2,
  );

  /// Enlace o texto accionable en color primario.
  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.primary,
  );
}
