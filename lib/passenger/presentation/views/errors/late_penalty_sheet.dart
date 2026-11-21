import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';

/// Bottom sheet: cancelación con penalidad por hacerse a menos de 30
/// minutos de la salida (PAS-E5).
///
/// Devuelve `true` si el pasajero confirma el pago de la penalidad.
Future<bool?> showLatePenaltySheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    isScrollControlled: true,
    builder: (context) => const _LatePenaltySheet(),
  );
}

class _LatePenaltySheet extends StatelessWidget {
  const _LatePenaltySheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Cancelar ahora tiene penalidad',
              style: AppTypography.screenTitle.copyWith(fontSize: 23),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Faltan 18 minutos para la salida. La cancelación sin costo '
              'terminó a las 6:40 a. m.',
              style: AppTypography.body.copyWith(color: AppColors.ink2),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Penalidad por cancelación tardía',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      Text('S/ 3.00', style: AppTypography.highlightedData),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  Divider(color: Color(0x339A5B00)),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Icon(Icons.credit_card, size: 19, color: AppColors.ink2),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Se cobra a Visa •••• 4821',
                          style: AppTypography.support.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    Icons.info_outline,
                    size: 17,
                    color: AppColors.ink3,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Tu asiento se libera de inmediato.',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.ink3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  textStyle: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Cancelar y pagar S/ 3.00'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(44),
                textStyle: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Mantener mi reserva'),
            ),
          ],
        ),
      ),
    );
  }
}
