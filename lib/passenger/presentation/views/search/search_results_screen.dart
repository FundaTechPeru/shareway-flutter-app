import 'package:flutter/material.dart';

import '../../../models/trip_request_models.dart';
import '../../../repositories/trip_request_repository.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_progress_bar.dart';
import '../../../data/passenger_data.dart';
import '../booking/confirm_booking_screen.dart';

/// PAS-03 · Resultados de búsqueda
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key, this.empty = false});

  static const String routeName = '/passenger/search/results';

  /// Activa el estado vacío PAS-E2.
  final bool empty;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TripRequestRepository _repository = TripRequestRepository();
  List<MatchProposal> _proposals = [];
  String? _requestId;
  bool _isLoading = false;
  int _sort = 0;

  static const List<String> _sorts = [
    'Más temprano',
    'Menor precio',
    'Más asientos',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _requestId = args['requestId']?.toString();
      if (args['proposals'] is List<MatchProposal>) {
        _proposals = args['proposals'] as List<MatchProposal>;
      } else if (_requestId != null && _proposals.isEmpty && !_isLoading) {
        _fetchProposals(_requestId!);
      }
    }
  }

  Future<void> _fetchProposals(String reqId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final list = await _repository.getMatchProposals(reqId);
      if (mounted) {
        setState(() {
          _proposals = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(PassengerData.lastQuery.route),
            const SizedBox(height: 2),
            Text(PassengerData.lastQuery.window, style: AppTypography.support),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune),
            tooltip: 'Filtrar',
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child:
            widget.empty ||
                (!_isLoading && _proposals.isEmpty && _requestId != null)
            ? const _EmptyResults()
            : _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  AppSpacing.md,
                  AppSpacing.screenMargin,
                  AppSpacing.xl,
                ),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < _sorts.length; i++) ...[
                          if (i > 0) const SizedBox(width: AppSpacing.sm),
                          _SortChip(
                            label: _sorts[i],
                            selected: _sort == i,
                            onTap: () => setState(() => _sort = i),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Text(
                        '${_proposals.isEmpty ? 3 : _proposals.length} viajes disponibles',
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Precio estimado por asiento',
                        style: AppTypography.label.copyWith(
                          color: AppColors.ink3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_proposals.isNotEmpty)
                    for (final MatchProposal proposal in _proposals) ...[
                      _ProposalResultCard(
                        proposal: proposal,
                        onTap: () => Navigator.of(context).pushNamed(
                          ConfirmBookingScreen.routeName,
                          arguments: {
                            'groupId': proposal.groupId,
                            'requestId': proposal.requestId.isNotEmpty
                                ? proposal.requestId
                                : _requestId,
                            'proposal': proposal,
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ]
                  else
                    for (final TripOption trip
                        in PassengerData.searchResults) ...[
                      _TripResultCard(
                        trip: trip,
                        onTap: () => Navigator.of(context).pushNamed(
                          ConfirmBookingScreen.routeName,
                          arguments: {
                            'groupId': 'grp_demo_123',
                            'requestId': _requestId ?? 'req_demo_123',
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  const SizedBox(height: AppSpacing.xs),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Icon(
                          Icons.info_outline,
                          size: 17,
                          color: AppColors.ink3,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'El precio puede variar si cambia la ruta.',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 13,
                            height: 1.4,
                            color: AppColors.ink3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

/// PAS-E2 · Estado vacío: sin viajes disponibles.
class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.lg,
        AppSpacing.screenMargin,
        AppSpacing.xl,
      ),
      children: [
        const SizedBox(height: AppSpacing.xl),
        Container(
          width: 96,
          height: 96,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.surface2,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.directions_bus,
            size: 44,
            color: AppColors.ink3,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'No hay viajes disponibles para tu búsqueda',
          textAlign: TextAlign.center,
          style: AppTypography.sectionTitle.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Intenta con otro horario o programa un viaje recurrente. '
          'Te avisaremos cuando haya un viaje en esta ruta.',
          textAlign: TextAlign.center,
          style: AppTypography.support.copyWith(height: 1.5),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              textStyle: AppTypography.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: const Icon(Icons.search, size: 19),
            label: const Text('Cambiar búsqueda'),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton.icon(
          onPressed: () =>
              Navigator.of(context).pushNamed('/passenger/recurring/new'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(44),
            textStyle: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
          ),
          icon: const Icon(Icons.repeat, size: 18),
          label: const Text('Programar viaje recurrente'),
        ),
      ],
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.body.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : AppColors.ink2,
          ),
        ),
      ),
    );
  }
}

class _ProposalResultCard extends StatelessWidget {
  const _ProposalResultCard({required this.proposal, required this.onTap});

  final MatchProposal proposal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final int seatsFree = proposal.seatsAvailable;
    final String seatsLabel =
        '$seatsFree ${seatsFree == 1 ? "asiento libre" : "asientos libres"}';
    final AppBadgeTone seatsTone = seatsFree <= 1
        ? AppBadgeTone.warning
        : AppBadgeTone.success;

    final String driverInitials = proposal.driverName.isNotEmpty
        ? proposal.driverName
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join()
              .toUpperCase()
        : 'CH';

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  proposal.departureTime,
                  style: AppTypography.highlightedData.copyWith(fontSize: 20),
                ),
              ),
              AppBadge(label: seatsLabel, tone: seatsTone, dense: true),
              const SizedBox(width: AppSpacing.md),
              Text(
                'S/ ${proposal.estimatedFare.toStringAsFixed(2)}',
                style: AppTypography.highlightedData.copyWith(
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _RoutePoint(
            icon: const Icon(
              Icons.radio_button_unchecked,
              size: 19,
              color: AppColors.primary,
            ),
            text: proposal.originLabel ?? 'Origen',
          ),
          const SizedBox(height: AppSpacing.sm),
          _RoutePoint(
            icon: const Icon(
              Icons.location_on,
              size: 19,
              color: AppColors.warning,
            ),
            text: proposal.destinationLabel ?? 'Destino',
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _Avatar(initials: driverInitials),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  proposal.driverName,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const Icon(Icons.star, size: 16, color: AppColors.accent),
              const SizedBox(width: 4),
              Text(
                proposal.driverRating.toStringAsFixed(1),
                style: AppTypography.support.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(
                Icons.verified_outlined,
                size: 17,
                color: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripResultCard extends StatelessWidget {
  const _TripResultCard({required this.trip, required this.onTap});

  final TripOption trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final seatsLabel =
        '${trip.seatsFree} '
        '${trip.seatsFree == 1 ? "asiento libre" : "asientos libres"}';
    final seatsTone = trip.seatsFree <= 1
        ? AppBadgeTone.warning
        : AppBadgeTone.success;
    final progressColor = trip.seatsFree <= 1
        ? AppColors.warning
        : AppColors.primary;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  trip.time,
                  style: AppTypography.highlightedData.copyWith(fontSize: 20),
                ),
              ),
              AppBadge(label: seatsLabel, tone: seatsTone, dense: true),
              const SizedBox(width: AppSpacing.md),
              Text(
                trip.price,
                style: AppTypography.highlightedData.copyWith(
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _RoutePoint(
            icon: const Icon(
              Icons.radio_button_unchecked,
              size: 19,
              color: AppColors.primary,
            ),
            text: trip.origin,
          ),
          const SizedBox(height: AppSpacing.sm),
          _RoutePoint(
            icon: const Icon(
              Icons.location_on,
              size: 19,
              color: AppColors.warning,
            ),
            text: trip.destination,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            trip.passengers,
            style: AppTypography.support.copyWith(color: AppColors.ink2),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppProgressBar(value: trip.progress, color: progressColor),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _Avatar(initials: trip.driverInitials),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  trip.driverName,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              if (trip.newDriver)
                const AppBadge(label: 'Conductor nuevo', dense: true)
              else ...[
                const Icon(Icons.star, size: 16, color: AppColors.accent),
                const SizedBox(width: 4),
                Text(
                  trip.driverRating!,
                  style: AppTypography.support.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ],
              const SizedBox(width: AppSpacing.md),
              const Icon(
                Icons.verified_outlined,
                size: 17,
                color: AppColors.success,
              ),
              const SizedBox(width: 4),
              Text(
                'Verificado',
                style: AppTypography.support.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  const _RoutePoint({required this.icon, required this.text});

  final Widget icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.body.copyWith(color: AppColors.ink),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primarySoft,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}
