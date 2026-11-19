/// Espaciado y radios de ShareWay.
///
/// La guía de estilo define espaciado en múltiplos de 4 (4 · 8 · 12 · 16 · 24),
/// margen lateral de 16 en móvil y radios de 12 a 18.
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Margen lateral de pantalla en móvil.
  static const double screenMargin = 16;

  // ── Radios ───────────────────────────────────────────────────
  static const double radiusSm = 12;
  static const double radiusMd = 14;
  static const double radiusLg = 18;

  /// Radio tipo píldora, usado en botones.
  static const double radiusPill = 100;

  // ── Alturas de control ───────────────────────────────────────
  /// Botones de 48 a 52 px de alto.
  static const double buttonHeight = 52;
  static const double fieldHeight = 52;
}
