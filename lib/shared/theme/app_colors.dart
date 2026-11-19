import 'package:flutter/material.dart';

/// Paleta de colores de ShareWay.
///
/// Extraída de `ImagenReferencia-Shareway/00 · Guía de estilo.png`:
/// azul petróleo para confianza y ámbar para lo que pide atención
/// (asiento, precio y tiempo).
abstract class AppColors {
  // ── Primarios ────────────────────────────────────────────────
  /// Acciones y marca.
  static const Color primary = Color(0xFF0F5F73);

  /// Barra lateral y títulos.
  static const Color primaryDark = Color(0xFF0A4656);

  /// Fondos de apoyo.
  static const Color primarySoft = Color(0xFFD9EEF2);

  // ── Acento ───────────────────────────────────────────────────
  /// Destino, tiempo y precio.
  static const Color accent = Color(0xFFF2A31B);

  /// Avisos de tiempo.
  static const Color accentSoft = Color(0xFFFFF1D1);

  // ── Semánticos ───────────────────────────────────────────────
  /// Confirmado y verificado.
  static const Color success = Color(0xFF1B8554);

  /// Rechazo y emergencia.
  static const Color error = Color(0xFFC2362B);

  /// En revisión y último cupo.
  static const Color warning = Color(0xFF9A5B00);

  // ── Fondos semánticos (derivados de los anteriores) ──────────
  /// Fondo suave de "confirmado / verificado".
  static const Color successSoft = Color(0xFFE4F3EB);

  /// Fondo suave de "rechazo / emergencia".
  static const Color errorSoft = Color(0xFFF9E5E3);

  // ── Tintas ───────────────────────────────────────────────────
  static const Color ink = Color(0xFF132329);
  static const Color ink2 = Color(0xFF47595F);
  static const Color ink3 = Color(0xFF73858B);

  // ── Bordes y superficies ─────────────────────────────────────
  static const Color borderStrong = Color(0xFF9FAEB4);
  static const Color border = Color(0xFFD5DDE0);
  static const Color surface2 = Color(0xFFEAF0F2);
  static const Color background = Color(0xFFF4F7F8);
  static const Color surface = Color(0xFFFFFFFF);
}
