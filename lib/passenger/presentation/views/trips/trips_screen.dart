import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../booking/booking_detail_screen.dart';
import '../booking/rate_trip_screen.dart';
import 'past_trip_detail_screen.dart';
import 'recurring_trips_tab.dart';

/// PAS-08 · Mis viajes
///
/// Contiene las dos pestañas del módulo: "Viajes" (PAS-08) y
/// "Recurrentes" (PAS-18).
class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Mis viajes'),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.ink2,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            indicatorColor: AppColors.primary,
            indicatorWeight: 2.5,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Viajes'),
              Tab(text: 'Recurrentes'),
            ],
          ),
        ),
        body: const TabBarView(children: [_TripsTab(), RecurringTripsTab()]),
      ),
    );
  }
}

class _TripsTab extends StatelessWidget {
  const _TripsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        const _SectionLabel('Próximos'),
        _UpcomingTrip(
          weekday: 'MIE',
          day: '7',
          month: 'oct',
          onTap: () =>
              Navigator.of(context).pushNamed(BookingDetailScreen.routeName),
        ),
        const SizedBox(height: 12),
        _UpcomingTrip(
          weekday: 'JUE',
          day: '8',
          month: 'oct',
          onTap: () =>
              Navigator.of(context).pushNamed(BookingDetailScreen.routeName),
        ),
        const SizedBox(height: 24),
        const _SectionLabel('Pasados'),
        _PastTripsCard(
          onOpenFirst: () =>
              Navigator.of(context).pushNamed(PastTripDetailScreen.routeName),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink),
      ),
    );
  }
}

class _UpcomingTrip extends StatelessWidget {
  const _UpcomingTrip({
    required this.weekday,
    required this.day,
    required this.month,
    this.onTap,
  });

  final String weekday;
  final String day;
  final String month;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 66,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 24,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Text(
                    month,
                    style: const TextStyle(fontSize: 11, color: AppColors.ink2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lince → San Isidro',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.schedule, size: 15, color: AppColors.ink2),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Sale 7:10 a. m. · con Carlos H.',
                          style: TextStyle(fontSize: 13, color: AppColors.ink2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
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
                              size: 13,
                              color: AppColors.success,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Confirmado',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '4 de 4 pasajeros',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: AppColors.ink3),
          ],
        ),
      ),
    );
  }
}

class _PastTripsCard extends StatelessWidget {
  const _PastTripsCard({this.onOpenFirst});

  final VoidCallback? onOpenFirst;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _PastTrip(
            status: _PastStatus.done,
            title: 'Vie 2 oct · Lince a San Isidro',
            subtitle: 'S/ 7.50 · Calificaste con 5 estrellas',
            onTap: onOpenFirst,
          ),
          const Divider(height: 1),
          _PastTrip(
            status: _PastStatus.done,
            title: 'Mié 30 sep · Lince a Miraflores',
            subtitle: 'S/ 7.00 · Aún sin calificar',
            onTap: () =>
                Navigator.of(context).pushNamed(RateTripScreen.routeName),
          ),
          Divider(height: 1),
          _PastTrip(
            status: _PastStatus.cancelled,
            title: 'Lun 28 sep · Lince a San Isidro',
            subtitle: 'Cancelado por ti · sin penalidad',
          ),
        ],
      ),
    );
  }
}

enum _PastStatus { done, cancelled }

class _PastTrip extends StatelessWidget {
  const _PastTrip({
    required this.status,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final _PastStatus status;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool done = status == _PastStatus.done;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: done ? AppColors.successSoft : AppColors.surface2,
                shape: BoxShape.circle,
              ),
              child: Icon(
                done ? Icons.check : Icons.close,
                size: 18,
                color: done ? AppColors.success : AppColors.ink3,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.ink3),
          ],
        ),
      ),
    );
  }
}
