import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Tarjeta de información con icono, título opcional y mensaje de apoyo.
///
/// Se usa para los avisos "¿Por qué lo pedimos?" (ACC-05), "El enlace vence
/// en 30 minutos" (ACC-06) y notas de permisos (ACC-07).
class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    super.key,
    this.icon,
    this.title,
    required this.message,
    this.backgroundColor = AppColors.surface2,
    this.iconColor = AppColors.ink2,
  });

  final IconData? icon;
  final String? title;
  final String message;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: AppTypography.support.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                Text(message, style: AppTypography.support),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
