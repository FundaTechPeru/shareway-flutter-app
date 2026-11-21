import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Variante visual de [AppButton].
enum AppButtonVariant {
  /// Fondo primario, texto blanco.
  primary,

  /// Fondo blanco, borde y texto primarios.
  secondary,

  /// Fondo blanco, borde y texto de error.
  danger,

  /// Fondo primario suave, texto primario.
  soft,

  /// Fondo de error sólido, texto blanco (acciones críticas como llamar al 105).
  error,
}

/// Botón reutilizable de 52 px de alto con radio tipo píldora.
///
/// Cuando [onPressed] es `null` el botón queda desactivado, tal como muestra
/// la guía de estilo ("Desactivado").
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expand = true,
    this.height = AppSpacing.buttonHeight,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;

  /// Si es `true` ocupa todo el ancho disponible.
  final bool expand;

  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;

    Color background;
    Color foreground;
    Color? border;

    switch (variant) {
      case AppButtonVariant.primary:
        background = enabled ? AppColors.primary : AppColors.surface2;
        foreground = enabled ? Colors.white : AppColors.ink3;
        border = null;
      case AppButtonVariant.secondary:
        background = AppColors.surface;
        foreground = enabled ? AppColors.primary : AppColors.ink3;
        border = enabled ? AppColors.primarySoft : AppColors.border;
      case AppButtonVariant.danger:
        background = AppColors.surface;
        foreground = enabled ? AppColors.error : AppColors.ink3;
        border = enabled ? AppColors.error : AppColors.border;
      case AppButtonVariant.soft:
        background = AppColors.primarySoft;
        foreground = enabled ? AppColors.primary : AppColors.ink3;
        border = null;
      case AppButtonVariant.error:
        background = enabled ? AppColors.error : AppColors.surface2;
        foreground = enabled ? Colors.white : AppColors.ink3;
        border = null;
    }

    final Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 19),
              const SizedBox(width: AppSpacing.sm),
              Text(label),
            ],
          );

    return SizedBox(
      height: height,
      width: expand ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: AppColors.surface2,
          disabledForegroundColor: AppColors.ink3,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          side: border == null ? null : BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
          textStyle: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
        ),
        child: child,
      ),
    );
  }
}

/// Botón de texto plano (sin relleno) para acciones secundarias.
class AppTextAction extends StatelessWidget {
  const AppTextAction({
    super.key,
    required this.label,
    this.onPressed,
    this.color = AppColors.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        disabledForegroundColor: AppColors.ink3,
        textStyle: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      ),
      child: Text(label),
    );
  }
}
