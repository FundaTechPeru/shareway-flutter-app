import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_progress_bar.dart';
import '../../widgets/trip_map.dart';
import '../booking/confirm_booking_screen.dart';
import '../driver/driver_profile_screen.dart';

/// PAS-04 · Detalle del viaje
class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  static const String routeName = '/passenger/trip';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle del viaje'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Compartir',
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TripMap(
                      height: 148,
                      radius: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenMargin,
                        AppSpacing.lg,
                        AppSpacing.screenMargin,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SummaryCard(),
                          const SizedBox(height: AppSpacing.md),
                          const _PassengersCard(),
                          const SizedBox(height: AppSpacing.md),
                          const _StopsCard(),
                          const SizedBox(height: AppSpacing.md),
                          const _DriverCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'S/ 7.50',
                        style: AppTypography.screenTitle.copyWith(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'precio estimado',
                        style: AppTypography.label
                            .copyWith(color: AppColors.ink3),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: AppButton(
                      label: 'Reservar asiento',
                      onPressed: () => Navigator.of(context)
                          .pushNamed(ConfirmBookingScreen.routeName),
                    ),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jue 8 oct · sale 7:10 a. m.',
            style: AppTypography.support.copyWith(color: AppColors.ink3),
          ),
          const SizedBox(height: 6),
          Text(
            'Lince → San Isidro',
            style: AppTypography.screenTitle.copyWith(fontSize: 21),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            children: [
              Icon(Icons.schedule, size: 17, color: AppColors.ink2),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '28 min · 6.4 km · 2 paradas de recojo',
                  style: AppTypography.support,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PassengersCard extends StatelessWidget {
  const _PassengersCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pasajeros confirmados',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Text(
                '3 de 4',
                style: AppTypography.highlightedData.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const AppProgressBar(value: 0.75),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const _PassengerAvatar(
                initials: 'AM',
                background: AppColors.primarySoft,
                foreground: AppColors.primaryDark,
              ),
              const SizedBox(width: 6),
              const _PassengerAvatar(
                initials: 'LT',
                background: AppColors.accentSoft,
                foreground: AppColors.warning,
              ),
              const SizedBox(width: 6),
              const _PassengerAvatar(
                initials: 'RC',
                background: AppColors.surface2,
                foreground: AppColors.ink2,
              ),
              const SizedBox(width: 6),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.borderStrong,
                    width: 1.4,
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: AppColors.ink3,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.check_circle,
                size: 17,
                color: AppColors.success,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  'Mínimo de 3 cumplido',
                  style: AppTypography.support.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PassengerAvatar extends StatelessWidget {
  const _PassengerAvatar({
    required this.initials,
    required this.background,
    required this.foreground,
  });

  final String initials;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}

class _StopsCard extends StatelessWidget {
  const _StopsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          _StopItem(
            dot: const _RingDot(color: AppColors.primary),
            title: 'Av. Arequipa con Risso',
            subtitle: 'Tu punto de recojo',
            time: '7:10 a. m.',
          ),
          _StopItem(
            dot: const _RingDot(color: AppColors.borderStrong),
            title: 'Av. Arenales con Canevaro',
            subtitle: 'Recojo de 1 pasajero',
            time: '7:17 a. m.',
          ),
          const _StopItem(
            dot: Icon(
              Icons.location_on,
              size: 24,
              color: AppColors.accent,
            ),
            title: 'Av. Rivera Navarrete 501',
            subtitle: 'Llegada a San Isidro',
            time: '7:38 a. m.',
            last: true,
          ),
        ],
      ),
    );
  }
}

class _StopItem extends StatelessWidget {
  const _StopItem({
    required this.dot,
    required this.title,
    required this.subtitle,
    required this.time,
    this.last = false,
  });

  final Widget dot;
  final String title;
  final String subtitle;
  final String time;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                dot,
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      time,
                      style: AppTypography.support
                          .copyWith(color: AppColors.ink2),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.support
                      .copyWith(color: AppColors.ink3),
                ),
                if (!last) const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RingDot extends StatelessWidget {
  const _RingDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 5),
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () => Navigator.of(context)
          .pushNamed(DriverProfileScreen.routeName),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Text(
              'CH',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Carlos Huamán',
                      style: AppTypography.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      size: 17,
                      color: AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.star, size: 15, color: AppColors.accent),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '4.8 · Toyota Yaris gris · BKL-482',
                        style: AppTypography.support,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.ink3),
        ],
      ),
    );
  }
}
