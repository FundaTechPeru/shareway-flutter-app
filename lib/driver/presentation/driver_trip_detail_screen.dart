import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';
import '../../shared/widgets/route_map_preview.dart';
import '../domain/driver_models.dart';
import 'driver_controller.dart';
import 'driver_active_trip_screen.dart';
import 'driver_widgets.dart';

class DriverTripDetailScreen extends StatelessWidget {
  const DriverTripDetailScreen({
    super.key,
    required this.controller,
    required this.tripId,
  });

  final DriverController controller;
  final String tripId;

  DriverTrip _trip() =>
      controller.trips.firstWhere((trip) => trip.id == tripId);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final trip = _trip();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              trip.status == DriverTripStatus.completed
                  ? 'Viaje finalizado'
                  : 'Viaje confirmado',
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${trip.dateLabel} · ${trip.timeLabel}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  StatusPill(
                    label: trip.status == DriverTripStatus.active
                        ? 'En curso'
                        : trip.status == DriverTripStatus.completed
                        ? 'Finalizado'
                        : 'Confirmado',
                    color: trip.status == DriverTripStatus.completed
                        ? ShareWayColors.muted
                        : ShareWayColors.success,
                    icon: trip.status == DriverTripStatus.active
                        ? Icons.navigation_rounded
                        : Icons.check_circle_outline_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Text(
                '${trip.origin} → ${trip.destination}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 14),
              RouteMapPreview(height: 194, points: trip.mapPoints),
              if (trip.routeChanged) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1D1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.alt_route_rounded,
                        color: ShareWayColors.warning,
                        size: 19,
                      ),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'El grupo cambió. Actualizamos el orden de recojo y la hora estimada de llegada.',
                          style: TextStyle(
                            color: ShareWayColors.warning,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TripMetric(
                          icon: Icons.people_alt_outlined,
                          value: '${trip.passengers.length}',
                          label: 'pasajeros',
                        ),
                      ),
                      Expanded(
                        child: _TripMetric(
                          icon: Icons.location_on_outlined,
                          value: '${trip.stops.length - 1}',
                          label: 'paradas',
                        ),
                      ),
                      Expanded(
                        child: _TripMetric(
                          icon: Icons.route_outlined,
                          value: trip.distanceLabel,
                          label: trip.durationLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const SectionHeading(title: 'Paradas de recojo'),
              const SizedBox(height: 7),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  child: Column(
                    children: [
                      for (var index = 0; index < trip.stops.length; index++)
                        _StopLine(
                          stop: trip.stops[index],
                          isLast: index == trip.stops.length - 1,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const SectionHeading(title: 'Pasajeros confirmados'),
              const SizedBox(height: 7),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  child: Column(
                    children: [
                      for (final passenger in trip.passengers)
                        PassengerListTile(passenger: passenger),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Card(
                child: SwitchListTile.adaptive(
                  value: controller.isSharing,
                  onChanged: (value) =>
                      controller.setTripSharing(trip.id, value),
                  activeTrackColor: ShareWayColors.primary,
                  secondary: const Icon(
                    Icons.share_location_rounded,
                    color: ShareWayColors.primary,
                  ),
                  title: const Text(
                    'Compartir seguimiento',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Tus contactos pueden ver la ruta durante el viaje.',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (trip.status == DriverTripStatus.completed)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ShareWayColors.primarySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Ganancia registrada: S/ ${trip.estimatedFare.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: ShareWayColors.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                FilledButton.icon(
                  onPressed: () {
                    if (trip.status == DriverTripStatus.upcoming) {
                      controller.updateTripStatus(
                        trip.id,
                        DriverTripStatus.active,
                      );
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DriverActiveTripScreen(
                          controller: controller,
                          tripId: trip.id,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.navigation_rounded),
                  label: Text(
                    trip.status == DriverTripStatus.active
                        ? 'Continuar viaje'
                        : 'Iniciar viaje',
                  ),
                ),
              const SizedBox(height: 8),
              const Text(
                'Datos de demostración. La ubicación del mapa es ilustrativa.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TripMetric extends StatelessWidget {
  const _TripMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: ShareWayColors.primary, size: 19),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          color: ShareWayColors.ink,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: const TextStyle(color: ShareWayColors.muted, fontSize: 10),
      ),
    ],
  );
}

class _StopLine extends StatelessWidget {
  const _StopLine({required this.stop, required this.isLast});

  final TripStop stop;
  final bool isLast;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 26,
          child: Column(
            children: [
              Icon(
                stop.isDestination ? Icons.flag_rounded : Icons.circle,
                size: stop.isDestination ? 17 : 11,
                color: stop.isDestination
                    ? ShareWayColors.accent
                    : ShareWayColors.primary,
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: ShareWayColors.border),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.address,
                  style: const TextStyle(
                    color: ShareWayColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  stop.isDestination
                      ? 'Destino · ${stop.time}'
                      : '${stop.passengerName} · ${stop.time}',
                  style: const TextStyle(
                    color: ShareWayColors.muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
