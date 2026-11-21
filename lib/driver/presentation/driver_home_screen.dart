import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';
import '../domain/driver_models.dart';
import 'driver_controller.dart';
import 'driver_trip_detail_screen.dart';
import 'driver_widgets.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({
    super.key,
    required this.controller,
    this.onOpenProposals,
    this.driverName,
    this.driverStatus,
  });

  final DriverController controller;
  final VoidCallback? onOpenProposals;
  final String? driverName;
  final String? driverStatus;

  void _openTrip(BuildContext context, DriverTrip trip) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            DriverTripDetailScreen(controller: controller, tripId: trip.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextTrip = controller.nextTrip;
    final pendingCount = controller.proposals
        .where((proposal) => proposal.status == ProposalStatus.pending)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      children: [
        Text(
          'Hola, ${driverName?.split(' ').first ?? 'Carlos'}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Icon(
              driverStatus == null || driverStatus == 'VERIFIED'
                  ? Icons.verified_rounded
                  : Icons.schedule_rounded,
              color: driverStatus == null || driverStatus == 'VERIFIED'
                  ? ShareWayColors.success
                  : ShareWayColors.warning,
              size: 16,
            ),
            const SizedBox(width: 5),
            Text(
              driverStatus == null || driverStatus == 'VERIFIED'
                  ? 'Conductor habilitado'
                  : 'Verificación pendiente',
              style: const TextStyle(
                color: ShareWayColors.secondaryInk,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [ShareWayColors.primaryDark, ShareWayColors.primary],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ganancia estimada',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'S/ 50.70',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Esta semana · 2 viajes realizados',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const SectionHeading(title: 'Tu próximo viaje'),
        const SizedBox(height: 10),
        if (nextTrip != null)
          TripPreviewCard(
            trip: nextTrip,
            onTap: () => _openTrip(context, nextTrip),
          )
        else
          const _NoUpcomingTripCard(),
        const SizedBox(height: 20),
        SectionHeading(
          title: 'Propuestas por responder',
          actionLabel: 'Ver todas',
          onAction: onOpenProposals,
        ),
        const SizedBox(height: 9),
        if (pendingCount == 0)
          const _NoPendingProposalsCard()
        else ...[
          for (final proposal
              in controller.proposals
                  .where((item) => item.status == ProposalStatus.pending)
                  .take(2))
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const IconTile(icon: Icons.alt_route_rounded),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${proposal.origin} → ${proposal.destination}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${proposal.dateLabel} · S/ ${proposal.estimatedFare.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      StatusPill(
                        label: '04:32',
                        color: ShareWayColors.warning,
                        icon: Icons.schedule_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ShareWayColors.primarySoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: ShareWayColors.primaryDark,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Comparte tu ubicación durante el viaje para que tus contactos estén informados.',
                  style: TextStyle(
                    color: ShareWayColors.primaryDark,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NoUpcomingTripCard extends StatelessWidget {
  const _NoUpcomingTripCard();

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(18),
      child: Row(
        children: [
          IconTile(
            icon: Icons.event_available_outlined,
            color: ShareWayColors.muted,
            background: ShareWayColors.pale,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Todavía no tienes viajes programados.',
              style: TextStyle(
                color: ShareWayColors.secondaryInk,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _NoPendingProposalsCard extends StatelessWidget {
  const _NoPendingProposalsCard();

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(18),
      child: Text(
        'Cuando recibas una propuesta nueva, aparecerá aquí.',
        style: TextStyle(color: ShareWayColors.muted, fontSize: 12),
      ),
    ),
  );
}
