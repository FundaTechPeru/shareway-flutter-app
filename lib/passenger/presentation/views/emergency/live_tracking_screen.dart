import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../widgets/live_trip_map.dart';
import '../../widgets/vehicle_card.dart';

/// EME-01 · Seguimiento en vivo.
///
/// Vista que recibe un contacto por el enlace compartido: muestra el auto en
/// el mapa, la llegada estimada y los datos del conductor. Al terminar el
/// viaje el enlace se apaga y esta vista deja de estar disponible
/// (ver [ExpiredLinkScreen]).
class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  static const String routeName = '/passenger/emergency/live-tracking';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── Marca + estado del enlace ────────────────────────
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
                    label: 'En vivo',
                    tone: AppBadgeTone.primary,
                    icon: Icons.near_me,
                  ),
                ],
              ),
            ),

            // ── Mapa con "actualizado hace" y refrescar ──────────
            Stack(
              children: [
                const SizedBox(height: 240, child: LiveTripMap()),
                const Positioned(
                  left: AppSpacing.screenMargin,
                  top: AppSpacing.md,
                  child: _UpdatedChip(label: 'Actualizado hace 5 s'),
                ),
                const Positioned(
                  right: AppSpacing.screenMargin,
                  top: AppSpacing.md,
                  child: _RefreshButton(),
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
                    'Lucía va camino a San Isidro',
                    style: AppTypography.highlightedData.copyWith(fontSize: 21),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Llega cerca de las 7:38 a. m. · faltan 14 min',
                    style: AppTypography.support,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const VehicleCard(
                    title: 'Toyota Yaris 2019',
                    subtitle: 'Gris plata · sedán',
                    plate: 'BKL-482',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _DriverRow(),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Llamar a Lucía',
                    icon: Icons.phone,
                    variant: AppButtonVariant.secondary,
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _LinkNote(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdatedChip extends StatelessWidget {
  const _UpdatedChip({required this.label});

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
          const Icon(Icons.schedule, size: 15, color: AppColors.ink2),
          const SizedBox(width: 6),
          Text(label, style: AppTypography.label),
        ],
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.refresh, size: 22, color: AppColors.ink2),
    );
  }
}

class _DriverRow extends StatelessWidget {
  const _DriverRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primarySoft,
            shape: BoxShape.circle,
          ),
          child: Text(
            'CH',
            style: AppTypography.label.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Carlos Huamán',
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                'Conductor verificado por ShareWay',
                style: AppTypography.support,
              ),
            ],
          ),
        ),
        const Icon(Icons.verified, size: 20, color: AppColors.success),
      ],
    );
  }
}

class _LinkNote extends StatelessWidget {
  const _LinkNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lock_outline, size: 14, color: AppColors.ink3),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'El enlace deja de funcionar cuando termina el viaje.',
            style: AppTypography.label.copyWith(
              color: AppColors.ink3,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
