import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';
import '../data/driver_api_repository.dart';
import '../domain/driver_trip_api_models.dart';
import 'connected_driver_trip_detail_screen.dart';

class ConnectedDriverTripsScreen extends StatefulWidget {
  const ConnectedDriverTripsScreen({super.key, required this.repository});

  final DriverApiRepository repository;

  @override
  State<ConnectedDriverTripsScreen> createState() =>
      _ConnectedDriverTripsScreenState();
}

class _ConnectedDriverTripsScreenState
    extends State<ConnectedDriverTripsScreen> {
  List<DriverApiTrip> _trips = const [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final trips = await widget.repository.listMyTrips();
      if (!mounted) return;
      setState(() {
        _trips = trips;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _trips.where((trip) => !trip.isCompleted).toList();
    final history = _trips.where((trip) => trip.isCompleted).toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Mis viajes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  tooltip: 'Actualizar viajes',
                  onPressed: _isLoading ? null : _loadTrips,
                  icon: _isLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded),
                ),
              ],
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
            child: _isLoading && _trips.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _error != null && _trips.isEmpty
                ? _LoadError(message: _error!, onRetry: _loadTrips)
                : TabBarView(
                    children: [
                      _TripList(
                        trips: upcoming,
                        emptyMessage: 'No tienes viajes próximos.',
                        error: _error,
                        onRefresh: _loadTrips,
                      ),
                      _TripList(
                        trips: history,
                        emptyMessage:
                            'Tu historial aparecerá aquí al cerrar un viaje.',
                        error: _error,
                        onRefresh: _loadTrips,
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
    required this.emptyMessage,
    required this.onRefresh,
    this.error,
  });

  final List<DriverApiTrip> trips;
  final String emptyMessage;
  final String? error;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
        children: [
          if (error != null) ...[
            _InlineError(message: error!),
            const SizedBox(height: 10),
          ],
          if (trips.isEmpty)
            SizedBox(
              height: 220,
              child: Center(child: _EmptyTrips(message: emptyMessage)),
            )
          else
            for (final trip in trips) ...[
              _ConnectedTripCard(trip: trip),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _ConnectedTripCard extends StatelessWidget {
  const _ConnectedTripCard({required this.trip});

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

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ConnectedDriverTripDetailScreen(trip: trip),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${route?.dateLabel ?? 'Horario por confirmar'} · ${route?.timeLabel ?? ''}',
                      style: Theme.of(context).textTheme.bodySmall,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.route_rounded,
                    color: ShareWayColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      '${route?.origin ?? 'Origen por confirmar'}  →  ${route?.destination ?? 'Destino por confirmar'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              if (trip.isTestSimulation) ...[
                const SizedBox(height: 9),
                const _TestTripBadge(),
              ],
              const SizedBox(height: 8),
              Text(
                'ID · ${trip.id}',
                style: const TextStyle(
                  color: ShareWayColors.muted,
                  fontSize: 10,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyTrips extends StatelessWidget {
  const _EmptyTrips({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.event_available_outlined,
            color: ShareWayColors.primary,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 7),
          const Text(
            'Los viajes confirmados para tu cuenta se sincronizan desde ShareWay.',
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
  );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, color: ShareWayColors.error),
          const SizedBox(height: 8),
          const Text(
            'No se pudieron cargar tus viajes',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: ShareWayColors.secondaryInk),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    ),
  );
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFBE5E3),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      'No se pudo actualizar: $message',
      style: const TextStyle(color: ShareWayColors.error, fontSize: 12),
    ),
  );
}

class _TestTripBadge extends StatelessWidget {
  const _TestTripBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF1D1),
      borderRadius: BorderRadius.circular(100),
    ),
    child: const Text(
      'Viaje de prueba',
      style: TextStyle(
        color: ShareWayColors.warning,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
