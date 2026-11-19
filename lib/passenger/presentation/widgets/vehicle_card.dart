import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';

/// Tarjeta de vehículo con la placa en recuadro, usada en el seguimiento
/// en vivo (EME-01) y en la alerta de emergencia (EME-02).
class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.plate,
  });

  final String title;
  final String subtitle;
  final String plate;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_outlined,
              size: 20,
              color: AppColors.ink2,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.support),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          VehiclePlate(plate),
        ],
      ),
    );
  }
}

/// Placa del vehículo en recuadro con borde (formato de matrícula).
class VehiclePlate extends StatelessWidget {
  const VehiclePlate(this.plate, {super.key});

  final String plate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Text(
        plate,
        style: AppTypography.body.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
