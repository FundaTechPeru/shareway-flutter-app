import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_progress_bar.dart';
import 'trip_detail_screen.dart';

/// PAS-03 · Resultados de búsqueda
///
/// Con [empty] en `true` muestra el estado vacío PAS-E2 (sin viajes
/// disponibles para los criterios seleccionados).
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key, this.empty = false});

  static const String routeName = '/passenger/search/results';

  /// Activa el estado vacío PAS-E2.
  final bool empty;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  int _sort = 0;

  static const List<String> _sorts = [
    'Más temprano',
    'Menor precio',
    'Más asientos',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lince a San Isidro'),
            const SizedBox(height: 2),
            Text(
              'Jue 8 oct · 7:00 a. m. a 8:00 a. m.',
              style: AppTypography.support,
            ),
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
        child: widget.empty
            ? const _EmptyResults()
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
                  '3 viajes disponibles',
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
            for (final _TripResult trip in _trips) ...[
              _TripResultCard(
                trip: trip,
                onTap: () => Navigator.of(context)
                    .pushNamed(TripDetailScreen.routeName),
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
          onPressed: () => Navigator.of(context)
              .pushNamed('/passenger/recurring/new'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(44),
            textStyle: AppTypography.body.copyWith(
              fontWeight: FontWeight.w500,
            ),
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

class _TripResult {
  const _TripResult({
    required this.time,
    required this.seatsLabel,
    required this.seatsTone,
    required this.price,
    required this.from,
    required this.to,
    required this.progress,
    required this.progressColor,
    required this.passengers,
    required this.initials,
    required this.name,
    this.rating,
    this.newDriver = false,
  });

  final String time;
  final String seatsLabel;
  final AppBadgeTone seatsTone;
  final String price;
  final String from;
  final String to;
  final double progress;
  final Color progressColor;
  final String passengers;
  final String initials;
  final String name;
  final String? rating;
  final bool newDriver;
}

const List<_TripResult> _trips = [
  _TripResult(
    time: '7:10 a. m.',
    seatsLabel: '1 asiento libre',
    seatsTone: AppBadgeTone.warning,
    price: 'S/ 7.50',
    from: 'Av. Arequipa con Risso',
    to: 'Av. Rivera Navarrete 501',
    progress: 0.75,
    progressColor: AppColors.primary,
    passengers: '3 de 4 pasajeros confirmados',
    initials: 'CH',
    name: 'Carlos H.',
    rating: '4.8',
  ),
  _TripResult(
    time: '7:25 a. m.',
    seatsLabel: '2 asientos libres',
    seatsTone: AppBadgeTone.success,
    price: 'S/ 6.80',
    from: 'Av. Arenales con Canevaro',
    to: 'Av. Rivera Navarrette 501',
    progress: 0.67,
    progressColor: AppColors.primary,
    passengers: '2 de 3 pasajeros confirmados',
    initials: 'MT',
    name: 'Milagros T.',
    rating: '4.9',
  ),
  _TripResult(
    time: '7:45 a. m.',
    seatsLabel: '3 asientos libres',
    seatsTone: AppBadgeTone.success,
    price: 'S/ 7.20',
    from: 'Av. Arequipa con Risso',
    to: 'Av. Javier Prado Este 492',
    progress: 0.34,
    progressColor: AppColors.accent,
    passengers: '1 de 3 pasajeros confirmados',
    initials: 'JR',
    name: 'Jorge R.',
    newDriver: true,
  ),
];

class _TripResultCard extends StatelessWidget {
  const _TripResultCard({required this.trip, required this.onTap});

  final _TripResult trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                  style: AppTypography.highlightedData.copyWith(
                    fontSize: 20,
                  ),
                ),
              ),
              AppBadge(
                label: trip.seatsLabel,
                tone: trip.seatsTone,
                dense: true,
              ),
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
            text: trip.from,
          ),
          const SizedBox(height: AppSpacing.sm),
          _RoutePoint(
            icon: const Icon(
              Icons.location_on,
              size: 19,
              color: AppColors.warning,
            ),
            text: trip.to,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            trip.passengers,
            style: AppTypography.support.copyWith(
              color: AppColors.ink2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppProgressBar(
            value: trip.progress,
            color: trip.progressColor,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _Avatar(initials: trip.initials),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  trip.name,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              if (trip.newDriver)
                const AppBadge(label: 'Conductor nuevo', dense: true)
              else ...[
                const Icon(
                  Icons.star,
                  size: 16,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 4),
                Text(
                  trip.rating!,
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
            style: AppTypography.body.copyWith(
              color: AppColors.ink,
            ),
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
