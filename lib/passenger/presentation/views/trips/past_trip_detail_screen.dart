import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../booking/trip_receipt_screen.dart';

/// PAS-19 · Detalle de viaje pasado (con opción de bloquear usuario)
class PastTripDetailScreen extends StatelessWidget {
  const PastTripDetailScreen({super.key});

  static const String routeName = '/passenger/trips/past';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Viaje del vie 2 oct')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.sm,
            AppSpacing.screenMargin,
            AppSpacing.xl,
          ),
          children: [
            const _SummaryCard(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Con quién viajaste',
              style: AppTypography.sectionTitle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: const [
                  _PersonRow(
                    initials: 'CH',
                    name: 'Carlos Huamán',
                    role: 'Conductor · 4.8',
                    background: AppColors.primarySoft,
                    foreground: AppColors.primaryDark,
                  ),
                  Divider(),
                  _PersonRow(
                    initials: 'AM',
                    name: 'Andrea M.',
                    role: 'Pasajera',
                    background: AppColors.accentSoft,
                    foreground: AppColors.warning,
                  ),
                  Divider(),
                  _PersonRow(
                    initials: 'LT',
                    name: 'Luis T.',
                    role: 'Pasajero',
                    background: AppColors.primarySoft,
                    foreground: AppColors.primaryDark,
                  ),
                  Divider(),
                  _PersonRow(
                    initials: 'RC',
                    name: 'Rosa C.',
                    role: 'Pasajera',
                    background: AppColors.accentSoft,
                    foreground: AppColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.block, size: 20, color: AppColors.ink2),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Qué pasa si bloqueas a alguien',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'No volveremos a agruparlos en un mismo viaje. '
                          'La otra persona no recibe ningún aviso.',
                          style: AppTypography.support,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(TripReceiptScreen.routeName),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusPill),
                        ),
                        textStyle: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Ver recibo'),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusPill),
                        ),
                        textStyle: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: const Icon(Icons.chat_bubble_outline, size: 17),
                      label: const Text('Reportar'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Finalizado',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'S/ 7.50',
                style: AppTypography.highlightedData.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Lince → San Isidro',
            style: AppTypography.highlightedData.copyWith(fontSize: 21),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '7:10 a 7:36 a. m. · calificaste con 5 estrellas',
            style: AppTypography.support.copyWith(color: AppColors.ink2),
          ),
        ],
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.initials,
    required this.name,
    required this.role,
    required this.background,
    required this.foreground,
  });

  final String initials;
  final String name;
  final String role;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: background, shape: BoxShape.circle),
            child: Text(
              initials,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(role, style: AppTypography.support),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              minimumSize: const Size(0, 38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              textStyle: AppTypography.support.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.block, size: 16),
                SizedBox(width: 5),
                Text('Bloquear'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
