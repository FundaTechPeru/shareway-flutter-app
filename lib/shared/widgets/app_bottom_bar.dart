import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Barra inferior con los botones principales de una pantalla.
///
/// Cuando [divider] es `true` dibuja una línea de separación superior, como
/// en la verificación por SMS (ACC-05) y la recuperación de contraseña
/// (ACC-06).
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.child,
    this.divider = false,
    this.backgroundColor = AppColors.surface,
  });

  final Widget child;
  final bool divider;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.md,
        AppSpacing.screenMargin,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: divider
            ? const Border(top: BorderSide(color: AppColors.border))
            : null,
      ),
      child: child,
    );
  }
}
