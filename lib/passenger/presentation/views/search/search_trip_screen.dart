import 'package:flutter/material.dart';

import '../../../repositories/trip_request_repository.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../data/trips_extra_data.dart';
import 'search_results_screen.dart';

/// PAS-02 · Buscar viaje
class SearchTripScreen extends StatefulWidget {
  const SearchTripScreen({super.key});

  static const String routeName = '/passenger/search';

  @override
  State<SearchTripScreen> createState() => _SearchTripScreenState();
}

class _SearchTripScreenState extends State<SearchTripScreen> {
  static const List<String> _days = ['Hoy', 'Mañana', 'Jue 8', 'Vie 9'];

  final TripRequestRepository _tripRequestRepository = TripRequestRepository();

  int _day = 0;
  int _seats = 1;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final now = DateTime.now();
      final travelDate = now
          .add(Duration(days: _day))
          .toIso8601String()
          .split('T')[0];

      final request = await _tripRequestRepository.createTripRequest(
        originLabel: TripsExtraData.searchForm.route.origin,
        destinationLabel: TripsExtraData.searchForm.route.destination,
        travelDate: travelDate,
        earliestDeparture: '07:00:00',
        latestDeparture: '08:00:00',
        seatsRequested: _seats,
      );

      final proposals = await _tripRequestRepository.generateMatchProposals(
        request.id,
      );

      if (!mounted) return;
      Navigator.of(context).pushNamed(
        SearchResultsScreen.routeName,
        arguments: {'requestId': request.id, 'proposals': proposals},
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e is ApiException
            ? e.message
            : 'Error al buscar viajes. Intenta nuevamente.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final SearchFormDefaults form = TripsExtraData.searchForm;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Buscar viaje')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _RoutePickerCard(),
                    const SizedBox(height: AppSpacing.xl),
                    const SectionHeader(title: '¿Cuándo viajas?'),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (int i = 0; i < _days.length; i++)
                          _DayChip(
                            label: _days[i],
                            selected: _day == i,
                            onTap: () => setState(() => _day = i),
                          ),
                        const _CalendarChip(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const SectionHeader(title: 'Rango horario'),
                    Row(
                      children: [
                        Expanded(
                          child: _TimeField(
                            label: 'Desde',
                            value: form.fromTime,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _TimeField(label: 'Hasta', value: form.toTime),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Verás los viajes que salen dentro de este rango.',
                      style: AppTypography.support,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.event_seat_outlined,
                            size: 24,
                            color: AppColors.ink2,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Asientos',
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _StepButton(
                            icon: Icons.remove,
                            filled: false,
                            onPressed: _seats > 1
                                ? () => setState(() => _seats--)
                                : null,
                          ),
                          const SizedBox(width: 14),
                          SizedBox(
                            width: 22,
                            child: Text(
                              '$_seats',
                              textAlign: TextAlign.center,
                              style: AppTypography.highlightedData,
                            ),
                          ),
                          const SizedBox(width: 14),
                          _StepButton(
                            icon: Icons.add,
                            filled: true,
                            onPressed: _seats < 4
                                ? () => setState(() => _seats++)
                                : null,
                          ),
                        ],
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.errorSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: AppTypography.support.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    const SectionHeader(title: 'Búsquedas recientes'),
                    for (final RecentSearch search
                        in TripsExtraData.recentSearches)
                      _RecentSearch(
                        title: search.title,
                        subtitle: search.subtitle,
                      ),
                  ],
                ),
              ),
            ),
            AppBottomBar(
              child: AppButton(
                label: 'Buscar viajes',
                icon: Icons.search,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _search,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutePickerCard extends StatelessWidget {
  const _RoutePickerCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EndPoint(
                  icon: const Icon(
                    Icons.radio_button_unchecked,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  label: 'Origen',
                  value: TripsExtraData.searchForm.route.origin,
                ),
                const _DashedConnector(),
                _EndPoint(
                  icon: const Icon(
                    Icons.location_on,
                    size: 21,
                    color: AppColors.warning,
                  ),
                  label: 'Destino',
                  value: TripsExtraData.searchForm.route.destination,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.swap_vert,
              size: 22,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EndPoint extends StatelessWidget {
  const _EndPoint({
    required this.icon,
    required this.label,
    required this.value,
  });

  final Widget icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.label),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedConnector extends StatelessWidget {
  const _DashedConnector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 6, bottom: 6),
      child: Column(
        children: List.generate(
          4,
          (_) => Container(
            width: 2,
            height: 4,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: AppColors.borderStrong,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
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

class _CalendarChip extends StatelessWidget {
  const _CalendarChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: const Icon(
        Icons.calendar_month_outlined,
        size: 20,
        color: AppColors.ink2,
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label),
        const SizedBox(height: 6),
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.schedule, size: 19, color: AppColors.ink2),
              const SizedBox(width: 10),
              Text(value, style: AppTypography.body),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.filled, this.onPressed});

  final IconData icon;
  final bool filled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;

    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 40, height: 40),
        style: IconButton.styleFrom(
          backgroundColor: filled ? AppColors.primarySoft : AppColors.surface,
          foregroundColor: enabled
              ? (filled ? AppColors.primary : AppColors.ink2)
              : AppColors.border,
          side: filled
              ? BorderSide.none
              : const BorderSide(color: AppColors.border),
          shape: const CircleBorder(),
        ),
        icon: Icon(icon, size: 20),
      ),
    );
  }
}

class _RecentSearch extends StatelessWidget {
  const _RecentSearch({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.schedule, size: 20, color: AppColors.ink3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.support),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
