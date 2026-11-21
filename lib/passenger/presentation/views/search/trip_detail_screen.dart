import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_progress_bar.dart';
import '../../../data/passenger_data.dart';
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
                    const TripMap(height: 148, radius: 18),
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
                        PassengerData.tripDetail.price,
                        style: AppTypography.screenTitle.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'precio estimado',
                        style: AppTypography.label.copyWith(
                          color: AppColors.ink3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: AppButton(
                      label: 'Reservar asiento',
                      onPressed: () =>
                          Navigator.of(context)
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
    final TripDetail trip = PassengerData.tripDetail;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.summary,
            style: AppTypography.support.copyWith(color: AppColors.ink3),
          ),
          const SizedBox(height: 6),
          Text(
            trip.route,
            style: AppTypography.screenTitle.copyWith(fontSize: 21),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.schedule, size: 17, color: AppColors.ink2),
              const SizedBox(width: 6),
              Expanded(child: Text(trip.meta, style: AppTypography.support)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PassengersCard extends StatelessWidget {
  const _PassengersCard();

  /// Rondas de avatar: mismo ciclo de colores que el diseño original.
  static const List<Color> _avatarBackgrounds = [
    AppColors.primarySoft,
    AppColors.accentSoft,
    AppColors.surface2,
  ];

  static const List<Color> _avatarForegrounds = [
    AppColors.primaryDark,
    AppColors.warning,
    AppColors.ink2,
  ];

  @override
  Widget build(BuildContext context) {
    final PassengerGroup group = PassengerData.tripPassengers;

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
                '${group.confirmed} de ${group.total}',
                style: AppTypography.highlightedData.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppProgressBar(value: group.progress),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              for (int i = 0; i < group.initials.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                _PassengerAvatar(
                  initials: group.initials[i],
                  background: _avatarBackgrounds[i % _avatarBackgrounds.length],
                  foreground: _avatarForegrounds[i % _avatarForegrounds.length],
                ),
              ],
              const SizedBox(width: 6),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderStrong, width: 1.4),
                ),
                child: const Icon(Icons.add, size: 18, color: AppColors.ink3),
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
                  group.minimumLabel,
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
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
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
    final List<TripStop> stops = PassengerData.tripDetail.stops;

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          for (int i = 0; i < stops.length; i++)
            _StopItem(
              dot: i == stops.length - 1
                  ? const Icon(
                      Icons.location_on,
                      size: 24,
                      color: AppColors.accent,
                    )
                  : _RingDot(
                      color: i == 0
                          ? AppColors.primary
                          : AppColors.borderStrong,
                    ),
              title: stops[i].title,
              subtitle: stops[i].subtitle,
              time: stops[i].time,
              last: i == stops.length - 1,
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
                  Expanded(child: Container(width: 2, color: AppColors.border)),
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
                      style: AppTypography.support.copyWith(
                        color: AppColors.ink2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.support.copyWith(color: AppColors.ink3),
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
    final DriverProfile driver = PassengerData.driver;

    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () =>
          Navigator.of(context).pushNamed(DriverProfileScreen.routeName),
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
            child: Text(
              driver.initials,
              style: const TextStyle(
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
                      driver.name,
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
                Row(
                  children: [
                    const Icon(Icons.star, size: 15, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${driver.rating} · ${driver.vehicleShort} · '
                        '${driver.plate}',
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
