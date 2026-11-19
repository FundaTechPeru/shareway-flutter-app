import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';

/// Diálogo de error: el viaje se quedó sin asientos (PAS-E3).
///
/// Se muestra sobre la pantalla de confirmar reserva.
Future<void> showSeatUnavailableDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const SeatUnavailableDialog(),
  );
}

class SeatUnavailableDialog extends StatelessWidget {
  const SeatUnavailableDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl,
            AppSpacing.xl, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.errorSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cancel_outlined,
                size: 30,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'El viaje ya no tiene asientos disponibles.',
              textAlign: TextAlign.center,
              style: AppTypography.sectionTitle.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Otro pasajero confirmó el último asiento antes que tú. '
              'No se hizo ningún cobro.',
              textAlign: TextAlign.center,
              style: AppTypography.support.copyWith(height: 1.5),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // cierra el diálogo
                  Navigator.of(context).popUntil(
                    (route) => route.settings.name == '/passenger/search/results',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  textStyle: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Ver otros viajes'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/passenger',
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(44),
                textStyle: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
