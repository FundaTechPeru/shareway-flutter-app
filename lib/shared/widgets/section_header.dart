import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Encabezado de sección: título a la izquierda y acción opcional a la derecha.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.sectionTitle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: const Size(0, 32),
                textStyle: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
