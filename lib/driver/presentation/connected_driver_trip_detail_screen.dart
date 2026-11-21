import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/route_map_preview.dart';
import '../../shared/widgets/shareway_components.dart';
import '../domain/driver_map_models.dart';
import '../domain/driver_trip_api_models.dart';

class ConnectedDriverTripDetailScreen extends StatelessWidget {
  const ConnectedDriverTripDetailScreen({super.key, required this.trip});

  final DriverApiTrip trip;

  @override
  Widget build(BuildContext context) {
    final route = trip.route;
    final statusColor = trip.isCancelled
        ? ShareWayColors.error
        : trip.isCompleted
        ? ShareWayColors.muted
        : trip.isActive
        ? ShareWayColors.primary
        : ShareWayColors.success;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del viaje')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${route?.dateLabel ?? 'Horario por confirmar'} · ${route?.timeLabel ?? ''}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              StatusPill(
                label: trip.statusLabel,
                color: statusColor,
                icon: trip.isCompleted
                    ? Icons.flag_outlined
                    : trip.isActive
                    ? Icons.navigation_rounded
                    : Icons.check_circle_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${route?.origin ?? 'Origen por confirmar'} → ${route?.destination ?? 'Destino por confirmar'}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (trip.isTestSimulation) ...[
            const SizedBox(height: 12),
            const _TestNotice(),
          ],
          const SizedBox(height: 14),
          if (route?.hasMapRoute ?? false)
            RouteMapPreview(
              height: 255,
              points: route!.points,
              allowDemoFallback: false,
              routeLabel: trip.isTestSimulation
                  ? 'Ruta de prueba · MapTiler'
                  : 'Ruta recibida del API',
              showVehicle: false,
            )
          else
            const _RouteUnavailableCard(),
          const SizedBox(height: 18),
          const SectionHeading(title: 'Recorrido recibido del API'),
          const SizedBox(height: 8),
          if (route == null || route.points.isEmpty)
            const _RouteUnavailableCard(compact: true)
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    for (var index = 0; index < route.points.length; index++)
                      _RoutePointRow(
                        point: route.points[index],
                        isLast: index == route.points.length - 1,
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID del viaje',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 5),
                  SelectableText(
                    trip.id,
                    style: const TextStyle(
                      color: ShareWayColors.primaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
}

class _RoutePointRow extends StatelessWidget {
  const _RoutePointRow({required this.point, required this.isLast});

  final DriverMapPoint point;
  final bool isLast;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Icon(
          point.kind == DriverMapPointKind.origin
              ? Icons.trip_origin_rounded
              : point.kind == DriverMapPointKind.destination
              ? Icons.flag_rounded
              : Icons.location_on_rounded,
          color: point.kind == DriverMapPointKind.destination
              ? ShareWayColors.accent
              : ShareWayColors.primary,
          size: 19,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            point.label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        if (isLast)
          const Text(
            'Destino',
            style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
          ),
      ],
    ),
  );
}

class _RouteUnavailableCard extends StatelessWidget {
  const _RouteUnavailableCard({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: EdgeInsets.all(compact ? 14 : 22),
      child: Row(
        children: [
          const Icon(Icons.map_outlined, color: ShareWayColors.muted),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Este viaje no incluye coordenadas de ruta. No se mostrará una ruta de demostración.',
              style: TextStyle(
                color: ShareWayColors.secondaryInk,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _TestNotice extends StatelessWidget {
  const _TestNotice();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF1D1),
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.science_outlined, color: ShareWayColors.warning, size: 18),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Simulación académica creada desde el API. No representa una reserva real ni un cobro.',
            style: TextStyle(
              color: ShareWayColors.warning,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ),
      ],
    ),
  );
}
