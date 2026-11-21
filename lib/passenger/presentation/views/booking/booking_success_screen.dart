import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../data/bookings_data.dart';
import '../../passenger_shell.dart';

/// PAS-06 · Reserva confirmada
class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  static const String routeName = '/passenger/booking/success';

  void _goToTrips(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      PassengerShell.routeName,
      (route) => false,
      arguments: 1,
    );
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      PassengerShell.routeName,
      (route) => false,
      arguments: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  40,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 104,
                      height: 104,
                      decoration: const BoxDecoration(
                        color: AppColors.successSoft,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Text(
                      '¡Asiento reservado!',
                      textAlign: TextAlign.center,
                      style: AppTypography.screenTitle,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      BookingsData.bookingSuccess.schedule,
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      BookingsData.bookingSuccess.route,
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(color: AppColors.ink2),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: 4,
                      ),
                      child: Column(
                        children: [
                          const _InfoRow(
                            icon: Icons.notifications_outlined,
                            title: 'Te avisaremos 10 minutos antes',
                            subtitle: 'Con modelo, color y placa del auto',
                          ),
                          const Divider(),
                          const _InfoRow(
                            icon: Icons.qr_code_2,
                            title: 'Tu código de abordaje',
                            subtitle:
                                'Lo encuentras en el detalle de tu reserva',
                          ),
                          const Divider(),
                          const _InfoRow(
                            icon: Icons.schedule,
                            title: 'Cancela sin penalidad',
                            subtitle: 'Hasta 30 minutos antes de la salida',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: 'Ver mis viajes',
                    onPressed: () => _goToTrips(context),
                  ),
                  AppTextAction(
                    label: 'Volver al inicio',
                    onPressed: () => _goHome(context),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
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
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(subtitle, style: AppTypography.support),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
