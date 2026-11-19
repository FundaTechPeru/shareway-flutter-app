import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Tarjeta blanca redondeada con borde, usada en toda la app.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.backgroundColor = AppColors.surface,
    this.borderColor = AppColors.border,
    this.radius = AppSpacing.radiusMd,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color borderColor;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );

    if (onTap == null) return card;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: card,
    );
  }
}
