import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';
import '../domain/driver_models.dart';

class TripPreviewCard extends StatelessWidget {
  const TripPreviewCard({
    super.key,
    required this.trip,
    this.onTap,
    this.showStatus = true,
  });

  final DriverTrip trip;
  final VoidCallback? onTap;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final status = switch (trip.status) {
      DriverTripStatus.upcoming => (
        'Confirmado',
        ShareWayColors.success,
        Icons.check_circle_outline_rounded,
      ),
      DriverTripStatus.active => (
        'En curso',
        ShareWayColors.primary,
        Icons.navigation_rounded,
      ),
      DriverTripStatus.completed => (
        'Finalizado',
        ShareWayColors.muted,
        Icons.flag_outlined,
      ),
    };

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${trip.dateLabel} · ${trip.timeLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (showStatus)
                    StatusPill(
                      label: status.$1,
                      color: status.$2,
                      icon: status.$3,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.route_rounded,
                      color: ShareWayColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${trip.origin}  →  ${trip.destination}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${trip.passengers.length} pasajeros · ${trip.stops.length - 1} paradas · ${trip.distanceLabel}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'S/ ${trip.estimatedFare.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: ShareWayColors.primaryDark,
                    ),
                  ),
                ],
              ),
              if (trip.routeChanged) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1D1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.alt_route_rounded,
                        color: ShareWayColors.warning,
                        size: 17,
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Un pasajero canceló. La ruta y el horario se actualizaron.',
                          style: TextStyle(
                            color: ShareWayColors.warning,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (onTap != null) ...[
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ver viaje',
                      style: TextStyle(
                        color: ShareWayColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: ShareWayColors.primary,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProposalPreviewCard extends StatelessWidget {
  const ProposalPreviewCard({
    super.key,
    required this.proposal,
    required this.onTap,
  });

  final DriverProposal proposal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = switch (proposal.status) {
      ProposalStatus.pending => (
        'Vence en ${proposal.expiresIn}',
        ShareWayColors.warning,
      ),
      ProposalStatus.accepted => ('Aceptada', ShareWayColors.success),
      ProposalStatus.declined => ('Rechazada', ShareWayColors.error),
      ProposalStatus.expired => ('Expirada', ShareWayColors.muted),
    };

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusPill(
                      label: status.$1,
                      color: status.$2,
                      icon: Icons.schedule_rounded,
                    ),
                    const SizedBox(height: 9),
                    Text(
                      '${proposal.origin}  →  ${proposal.destination}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${proposal.dateLabel} · ${proposal.timeLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${proposal.passengerCount} pasajeros · ${proposal.stopCount} paradas · ${proposal.distanceLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'S/ ${proposal.estimatedFare.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: ShareWayColors.primaryDark,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'estimado',
                    style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: ShareWayColors.muted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PassengerListTile extends StatelessWidget {
  const PassengerListTile({
    super.key,
    required this.passenger,
    this.trailing,
    this.subtitle,
    this.onTap,
  });

  final DriverPassenger passenger;
  final Widget? trailing;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: ShareWayColors.primarySoft,
                  child: Text(
                    passenger.initials,
                    style: const TextStyle(
                      color: ShareWayColors.primaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passenger.name,
                        style: const TextStyle(
                          color: ShareWayColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle ?? passenger.pickup,
                        style: const TextStyle(
                          color: ShareWayColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing ??
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: ShareWayColors.muted,
                      size: 19,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.tint = ShareWayColors.primary,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ShareWayColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: tint),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: ShareWayColors.ink,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(color: ShareWayColors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
