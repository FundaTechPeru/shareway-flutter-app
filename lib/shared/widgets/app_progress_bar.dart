import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Barra de progreso de cupos ("3 de 4 pasajeros confirmados").
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primary,
    this.height = 8,
  });

  /// Valor entre 0 y 1.
  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double clamped = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: [
            Container(color: AppColors.surface2),
            FractionallySizedBox(
              widthFactor: clamped,
              child: Container(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
