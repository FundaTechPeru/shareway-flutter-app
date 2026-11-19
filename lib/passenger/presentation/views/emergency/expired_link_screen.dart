import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_logo.dart';

/// EME-03 · Enlace expirado.
///
/// Estado que ve el contacto cuando abre un enlace de seguimiento después de
/// que el viaje terminó: el recorrido ya no se comparte.
class ExpiredLinkScreen extends StatelessWidget {
  const ExpiredLinkScreen({super.key});

  static const String routeName = '/passenger/emergency/link-expired';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                AppSpacing.md,
                AppSpacing.screenMargin,
                AppSpacing.md,
              ),
              child: Row(children: [Expanded(child: AppBrand(size: 32))]),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 132,
                            height: 132,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.surface2,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_outlined,
                              size: 46,
                              color: AppColors.ink2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Text(
                              'Este enlace ya no está disponible',
                              textAlign: TextAlign.center,
                              style: AppTypography.screenTitle,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Text(
                              'El viaje terminó a las 7:38 a. m. y el seguimiento '
                              'se desactivó automáticamente.',
                              textAlign: TextAlign.center,
                              style: AppTypography.body.copyWith(
                                color: AppColors.ink2,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 340),
                            child: AppCard(
                              backgroundColor: AppColors.surface2,
                              borderColor: Colors.transparent,
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.phone_outlined,
                                    size: 20,
                                    color: AppColors.ink2,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '¿Necesitas ubicar a Lucía?',
                                          style: AppTypography.support.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.ink,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Comunícate directamente con ella. '
                                          'ShareWay ya no comparte su ubicación.',
                                          style: AppTypography.support,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Text(
                'ShareWay · viajes compartidos y programados',
                style: AppTypography.label.copyWith(color: AppColors.ink3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
