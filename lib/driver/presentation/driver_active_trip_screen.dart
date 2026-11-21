import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';
import '../../shared/widgets/route_map_preview.dart';
import 'driver_controller.dart';
import 'driver_emergency_screen.dart';
import 'boarding_validation_screen.dart';
import 'driver_trip_closeout_screen.dart';
import 'driver_widgets.dart';
import '../../shared/presentation/emergency_link_screen.dart';

class DriverActiveTripScreen extends StatelessWidget {
  const DriverActiveTripScreen({
    super.key,
    required this.controller,
    required this.tripId,
  });

  final DriverController controller;
  final String tripId;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final trip = controller.trips.firstWhere((item) => item.id == tripId);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Viaje en curso'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: StatusPill(
                    label: 'En vivo',
                    color: ShareWayColors.success,
                    icon: Icons.circle,
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              RouteMapPreview(
                height: 250,
                activeStop: 2,
                points: trip.mapPoints,
              ),
              const SizedBox(height: 13),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusPill(
                        label: 'En curso desde las 7:18 a. m.',
                        color: ShareWayColors.success,
                        icon: Icons.check_circle_rounded,
                      ),
                      const SizedBox(height: 9),
                      Text(
                        'Llegas a las 7:38 a. m.',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${trip.destination} · ${trip.distanceLabel} restantes',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => EmergencyTrackingScreen(
                                    mode: EmergencyLinkMode.live,
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                Icons.share_location_rounded,
                                size: 17,
                              ),
                              label: const Text('Ver enlace'),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => DriverEmergencyScreen(
                                    controller: controller,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.sos_rounded, size: 18),
                              label: const Text('Emergencia'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SectionHeading(title: 'Siguiente parada'),
              const SizedBox(height: 7),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      for (final passenger in trip.passengers)
                        PassengerListTile(
                          passenger: passenger,
                          subtitle: passenger.boarded
                              ? 'A bordo'
                              : passenger.pickup,
                          trailing: passenger.boarded
                              ? const StatusPill(
                                  label: 'A bordo',
                                  color: ShareWayColors.success,
                                  icon: Icons.check_rounded,
                                )
                              : const Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: ShareWayColors.primary,
                                  size: 19,
                                ),
                          onTap: passenger.boarded
                              ? null
                              : () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => BoardingValidationScreen(
                                      controller: controller,
                                      tripId: trip.id,
                                      passenger: passenger,
                                    ),
                                  ),
                                ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Card(
                child: SwitchListTile.adaptive(
                  value: controller.isSharing,
                  onChanged: (value) =>
                      controller.setTripSharing(trip.id, value),
                  activeTrackColor: ShareWayColors.primary,
                  secondary: const Icon(
                    Icons.my_location_rounded,
                    color: ShareWayColors.primary,
                  ),
                  title: const Text(
                    'Compartir ubicación en vivo',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Actualizada hace unos segundos',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => DriverTripCloseoutScreen(
                        controller: controller,
                        tripId: trip.id,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.flag_outlined),
                label: const Text('Finalizar y revisar cobro'),
              ),
              const SizedBox(height: 9),
              const Text(
                'Vista ilustrativa. La ubicación real y las alertas requieren integración con los servicios correspondientes.',
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
