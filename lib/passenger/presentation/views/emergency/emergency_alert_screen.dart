import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../widgets/live_trip_map.dart';
import '../../widgets/vehicle_card.dart';

/// EME-02 · Alerta de emergencia activa.
///
/// La ve un contacto del pasajero cuando este activa la alerta desde la app:
/// aviso rojo con la hora y el viaje, ubicación en vivo del auto y acciones
/// de llamada al conductor y a la policía (105).
class EmergencyAlertScreen extends StatelessWidget {
  const EmergencyAlertScreen({super.key});

  static const String routeName = '/passenger/emergency/alert';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── Marca + estado ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                AppSpacing.md,
                AppSpacing.screenMargin,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  const Expanded(child: AppBrand(size: 32)),
                  AppBadge(
                    label: 'Emergencia',
                    tone: AppBadgeTone.error,
                    icon: Icons.error_outline,
                  ),
                ],
              ),
            ),

            // ── Banda de alerta ──────────────────────────────────
            Container(
              width: double.infinity,
              color: AppColors.error,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0x33FFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Carlos activó una alerta',
                          style: AppTypography.sectionTitle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mié 7 oct · 7:21 a. m. · viaje SW-58213',
                          style: AppTypography.support.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Te avisamos porque eres su contacto.',
                          style: AppTypography.support.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Mapa con la última ubicación ─────────────────────
            Stack(
              children: [
                const SizedBox(height: 220, child: LiveTripMap()),
                const Positioned(
                  left: AppSpacing.screenMargin,
                  top: AppSpacing.md,
                  child: _LiveChip(label: 'Ubicación en vivo · hace 4 s'),
                ),
              ],
            ),

            // ── Panel inferior ───────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                AppSpacing.md,
                AppSpacing.screenMargin,
                AppSpacing.xl,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'ÚLTIMA UBICACIÓN CONOCIDA',
                    style: AppTypography.label.copyWith(
                      color: AppColors.ink3,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Av. Arenales 1250, Lince',
                    style: AppTypography.highlightedData.copyWith(fontSize: 21),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Actualizada a las 7:21:38 a. m.',
                    style: AppTypography.support,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const VehicleCard(
                    title: 'Toyota Yaris gris plata',
                    subtitle: 'Conduce Carlos Huamán',
                    plate: 'BKL-482',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Llamar a Carlos',
                          icon: Icons.phone,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppButton(
                          label: 'Llamar al 105',
                          icon: Icons.phone,
                          variant: AppButtonVariant.error,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 14,
                        color: AppColors.ink3,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Verás su ubicación hasta que se cierre la alerta.',
                          style: AppTypography.label.copyWith(
                            color: AppColors.ink3,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveChip extends StatelessWidget {
  const _LiveChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.near_me, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: AppTypography.label),
        ],
      ),
    );
  }
}
