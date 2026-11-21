import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';

/// Bottom sheet: el precio del viaje cambió por una parada agregada (PAS-E4).
///
/// Devuelve `true` si el pasajero acepta el nuevo precio.
Future<bool?> showPriceChangeSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    isScrollControlled: true,
    builder: (context) => const _PriceChangeSheet(),
  );
}

class _PriceChangeSheet extends StatelessWidget {
  const _PriceChangeSheet();

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
              'El precio de tu viaje cambió',
              style: AppTypography.screenTitle.copyWith(fontSize: 23),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Se sumó una parada y la ruta se recalculó antes de salir.',
              style: AppTypography.body.copyWith(color: AppColors.ink2),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _ChangeRow(
                    label: 'Precio por asiento',
                    from: 'S/ 7.50',
                    to: 'S/ 8.10',
                  ),
                  SizedBox(height: AppSpacing.md),
                  _ChangeRow(
                    label: 'Llegada a San Isidro',
                    from: '7:38',
                    to: '7:42 a. m.',
                  ),
                  SizedBox(height: AppSpacing.md),
                  Divider(),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Diferencia',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      Text('+ S/ 0.60', style: AppTypography.highlightedData),
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
                    'Si no aceptas, puedes cancelar sin penalidad.',
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
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  textStyle: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Aceptar S/ 8.10 y continuar'),
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
              child: const Text('Cancelar mi reserva'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({required this.label, required this.from, required this.to});

  final String label;
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(color: AppColors.ink2),
          ),
        ),
        Text(
          from,
          style: AppTypography.body.copyWith(
            color: AppColors.ink3,
            decoration: TextDecoration.lineThrough,
            decorationColor: AppColors.ink3,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward, size: 15, color: AppColors.ink2),
        ),
        Text(
          to,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}
