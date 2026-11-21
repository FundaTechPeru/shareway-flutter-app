import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';
import '../../shared/widgets/route_map_preview.dart';
import '../domain/driver_models.dart';
import 'driver_controller.dart';
import 'driver_widgets.dart';

class DriverProposalsScreen extends StatelessWidget {
  const DriverProposalsScreen({
    super.key,
    required this.controller,
    this.isConnected = false,
  });

  final DriverController controller;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    if (isConnected) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        children: [
          Text('Propuestas', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 5),
          Text(
            'Bandeja del conductor',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Icon(
                    Icons.inbox_outlined,
                    color: ShareWayColors.primary,
                    size: 34,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'La bandeja aún no está disponible',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'El servicio permite consultar propuestas por solicitud, pero todavía no ofrece una lista para el conductor ni acciones para aceptar o rechazar desde esta app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ShareWayColors.secondaryInk,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final proposals = controller.proposals;
    final pendingCount = proposals
        .where((proposal) => proposal.status == ProposalStatus.pending)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
      children: [
        Text('Propuestas', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 5),
        Text(
          '$pendingCount propuestas por responder',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1D1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: ShareWayColors.warning,
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Revisa la ruta y la ganancia antes de aceptar. Cada propuesta tiene un tiempo límite.',
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
        const SizedBox(height: 15),
        for (final proposal in proposals)
          Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: ProposalPreviewCard(
              proposal: proposal,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ProposalDetailsScreen(
                    controller: controller,
                    proposalId: proposal.id,
                  ),
                ),
              ),
            ),
          ),
        if (proposals.isEmpty)
          const ServiceStatePanel(state: ServiceViewState.serviceError),
      ],
    );
  }
}

class ProposalDetailsScreen extends StatelessWidget {
  const ProposalDetailsScreen({
    super.key,
    required this.controller,
    required this.proposalId,
  });

  final DriverController controller;
  final String proposalId;

  @override
  Widget build(BuildContext context) {
    final proposal = controller.proposals.firstWhere(
      (item) => item.id == proposalId,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Propuesta de viaje')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          StatusPill(
            label: 'Vence en ${proposal.expiresIn}',
            color: ShareWayColors.warning,
            icon: Icons.schedule_rounded,
          ),
          const SizedBox(height: 14),
          Text(
            '${proposal.origin} → ${proposal.destination}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '${proposal.dateLabel} · ${proposal.timeLabel}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          RouteMapPreview(height: 178, points: proposal.mapPoints),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DetailLine(
                    icon: Icons.people_alt_outlined,
                    label: 'Pasajeros agrupados',
                    value: '${proposal.passengerCount} personas',
                  ),
                  const Divider(height: 24),
                  _DetailLine(
                    icon: Icons.location_on_outlined,
                    label: 'Paradas de recojo',
                    value: '${proposal.stopCount} paradas',
                  ),
                  const Divider(height: 24),
                  _DetailLine(
                    icon: Icons.route_outlined,
                    label: 'Distancia y duración',
                    value:
                        '${proposal.distanceLabel} · ${proposal.durationLabel}',
                  ),
                  const Divider(height: 24),
                  _DetailLine(
                    icon: Icons.payments_outlined,
                    label: 'Ganancia estimada',
                    value: 'S/ ${proposal.estimatedFare.toStringAsFixed(2)}',
                    highlight: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (proposal.status == ProposalStatus.pending) ...[
            FilledButton.icon(
              onPressed: () {
                controller.respondToProposal(
                  proposal.id,
                  ProposalStatus.accepted,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Aceptaste la propuesta de viaje.'),
                  ),
                );
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text('Aceptar viaje'),
            ),
            const SizedBox(height: 9),
            OutlinedButton.icon(
              onPressed: () {
                controller.respondToProposal(
                  proposal.id,
                  ProposalStatus.declined,
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close_rounded),
              label: const Text('Rechazar'),
            ),
          ] else
            StatusPill(
              label: proposal.status.name.toUpperCase(),
              color: ShareWayColors.muted,
            ),
          const SizedBox(height: 10),
          const Text(
            'Datos de demostración. Las propuestas reales se conectarán al endpoint del conductor cuando esté disponible.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: ShareWayColors.primary, size: 19),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          label,
          style: const TextStyle(
            color: ShareWayColors.secondaryInk,
            fontSize: 12,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: highlight ? ShareWayColors.primaryDark : ShareWayColors.ink,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
