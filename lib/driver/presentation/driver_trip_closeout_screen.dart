import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';
import '../domain/driver_models.dart';
import 'driver_controller.dart';

class DriverTripCloseoutScreen extends StatelessWidget {
  const DriverTripCloseoutScreen({
    super.key,
    required this.controller,
    required this.tripId,
  });

  final DriverController controller;
  final String tripId;

  @override
  Widget build(BuildContext context) {
    final trip = controller.trips.firstWhere((item) => item.id == tripId);
    final perPassenger = trip.passengers.isEmpty
        ? 0.0
        : trip.estimatedFare / trip.passengers.length;
    final grossFare = trip.estimatedFare / 0.88;
    final serviceFee = grossFare - trip.estimatedFare;

    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar viaje')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ShareWayColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: ShareWayColors.success,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Llegaste al destino · ${trip.timeLabel}',
                    style: const TextStyle(
                      color: ShareWayColors.primaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${trip.origin} → ${trip.destination}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${trip.dateLabel} · ${trip.distanceLabel}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const SectionHeading(title: 'Ganancia por pasajero'),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  for (
                    var index = 0;
                    index < trip.passengers.length;
                    index++
                  ) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: ShareWayColors.primarySoft,
                        child: Text(
                          trip.passengers[index].initials,
                          style: const TextStyle(
                            color: ShareWayColors.primaryDark,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(
                        trip.passengers[index].name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        trip.passengers[index].boarded
                            ? 'Abordaje validado'
                            : 'Validación pendiente',
                        style: const TextStyle(fontSize: 10),
                      ),
                      trailing: Text(
                        'S/ ${perPassenger.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (index < trip.passengers.length - 1)
                      const Divider(height: 1),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  _AmountRow(
                    label: 'Cobrado a pasajeros',
                    amount: 'S/ ${grossFare.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 9),
                  _AmountRow(
                    label: 'Comisión de ShareWay',
                    amount: '− S/ ${serviceFee.toStringAsFixed(2)}',
                  ),
                  const Divider(height: 22),
                  _AmountRow(
                    label: 'Tu ganancia',
                    amount: 'S/ ${trip.estimatedFare.toStringAsFixed(2)}',
                    highlight: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 17),
          FilledButton.icon(
            onPressed: () {
              controller.updateTripStatus(trip.id, DriverTripStatus.completed);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => DriverRatingScreen(
                    controller: controller,
                    tripId: trip.id,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.check_rounded),
            label: const Text('Confirmar cierre del viaje'),
          ),
          const SizedBox(height: 9),
          const Text(
            'Importes de demostración; el cálculo real se obtendrá de Payments & Settlement.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class DriverRatingScreen extends StatefulWidget {
  const DriverRatingScreen({
    super.key,
    required this.controller,
    required this.tripId,
  });

  final DriverController controller;
  final String tripId;

  @override
  State<DriverRatingScreen> createState() => _DriverRatingScreenState();
}

class _DriverRatingScreenState extends State<DriverRatingScreen> {
  final _ratings = <String, int>{};
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.controller.trips.firstWhere(
      (item) => item.id == widget.tripId,
    );
    final messenger = ScaffoldMessenger.of(context);

    void finish(String message) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Califica a tus pasajeros')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Text(
            '${trip.dateLabel} · ${trip.origin} a ${trip.destination}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Card(
            child: Column(
              children: [
                for (
                  var index = 0;
                  index < trip.passengers.length;
                  index++
                ) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: ShareWayColors.primarySoft,
                          child: Text(
                            trip.passengers[index].initials,
                            style: const TextStyle(
                              color: ShareWayColors.primaryDark,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            trip.passengers[index].name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        for (var star = 1; star <= 5; star++)
                          GestureDetector(
                            onTap: () => setState(
                              () =>
                                  _ratings[trip.passengers[index].name] = star,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 1,
                              ),
                              child: Icon(
                                star <=
                                        (_ratings[trip
                                                .passengers[index]
                                                .name] ??
                                            5)
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: ShareWayColors.accent,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (index < trip.passengers.length - 1)
                    const Divider(height: 1, indent: 14, endIndent: 14),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Comentario (opcional)',
              hintText: '¿Algo que debamos saber de este viaje?',
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => finish('Gracias. El viaje quedó finalizado.'),
            child: const Text('Enviar calificaciones'),
          ),
          TextButton(
            onPressed: () =>
                finish('Viaje finalizado. Puedes calificar más tarde.'),
            child: const Text('Ahora no'),
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.amount,
    this.highlight = false,
  });

  final String label;
  final String amount;
  final bool highlight;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            color: highlight ? ShareWayColors.ink : ShareWayColors.secondaryInk,
            fontSize: 12,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
      Text(
        amount,
        style: TextStyle(
          color: highlight
              ? ShareWayColors.primaryDark
              : ShareWayColors.secondaryInk,
          fontSize: highlight ? 16 : 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
