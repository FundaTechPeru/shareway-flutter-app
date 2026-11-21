import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import 'driver_controller.dart';
import 'driver_trip_detail_screen.dart';
import 'driver_widgets.dart';
import '../domain/driver_models.dart';

class DriverTripsScreen extends StatelessWidget {
  const DriverTripsScreen({super.key, required this.controller});

  final DriverController controller;

  @override
  Widget build(BuildContext context) {
    final trips = controller.trips;
    final upcoming = trips
        .where((trip) => trip.status != DriverTripStatus.completed)
        .toList();
    final history = trips
        .where((trip) => trip.status == DriverTripStatus.completed)
        .toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: Text(
              'Mis viajes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const TabBar(
            tabs: [
              Tab(text: 'Próximos'),
              Tab(text: 'Historial'),
            ],
            labelColor: ShareWayColors.primary,
            unselectedLabelColor: ShareWayColors.muted,
            indicatorColor: ShareWayColors.primary,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _TripList(
                  trips: upcoming,
                  controller: controller,
                  emptyMessage: 'No tienes viajes próximos.',
                ),
                _TripList(
                  trips: history,
                  controller: controller,
                  emptyMessage:
                      'Tu historial aparecerá aquí al cerrar un viaje.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripList extends StatelessWidget {
  const _TripList({
    required this.trips,
    required this.controller,
    required this.emptyMessage,
  });

  final List<DriverTrip> trips;
  final DriverController controller;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
      itemCount: trips.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final trip = trips[index];
        return TripPreviewCard(
          trip: trip,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => DriverTripDetailScreen(
                controller: controller,
                tripId: trip.id,
              ),
            ),
          ),
        );
      },
    );
  }
}
