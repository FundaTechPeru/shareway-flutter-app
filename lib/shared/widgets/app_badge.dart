import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Tono de color de un [AppBadge].
enum AppBadgeTone {
  neutral,
  primary,
  success,
  warning,
  error,
}

/// Chip de estado redondeado ("Confirmado", "2 asientos libres", etc.).
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.neutral,
    this.icon,
    this.dense = false,
  });

  final String label;
  final AppBadgeTone tone;
  final IconData? icon;
  final bool dense;

  (Color background, Color foreground) get _palette {
    switch (tone) {
      case AppBadgeTone.neutral:
        return (AppColors.surface2, AppColors.ink2);
      case AppBadgeTone.primary:
        return (AppColors.primarySoft, AppColors.primaryDark);
      case AppBadgeTone.success:
        return (AppColors.successSoft, AppColors.success);
      case AppBadgeTone.warning:
        return (AppColors.accentSoft, AppColors.warning);
      case AppBadgeTone.error:
        return (AppColors.errorSoft, AppColors.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground) = _palette;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.label.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
