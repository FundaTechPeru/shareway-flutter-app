import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../data/trips_extra_data.dart';

/// PAS-17 · Programar viaje recurrente
class RecurringTripFormScreen extends StatefulWidget {
  const RecurringTripFormScreen({super.key});

  static const String routeName = '/passenger/recurring/new';

  @override
  State<RecurringTripFormScreen> createState() =>
      _RecurringTripFormScreenState();
}

class _RecurringTripFormScreenState extends State<RecurringTripFormScreen> {
  // L M X J V S D
  final Set<int> _days = {0, 1, 2, 3, 4};

  static const List<String> _letters = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  bool get _weekdaysOnly =>
      _days.length == 5 && _days.containsAll(const {0, 1, 2, 3, 4});

  void _save() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Programación guardada.')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final RecurringFormDefaults form = TripsExtraData.recurringForm;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Viaje recurrente')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  AppSpacing.sm,
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _RouteCard(),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      '¿Qué días?',
                      style: AppTypography.sectionTitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < _letters.length; i++)
                          _DayCircle(
                            letter: _letters[i],
                            selected: _days.contains(i),
                            onTap: () => setState(() {
                              _days.contains(i)
                                  ? _days.remove(i)
                                  : _days.add(i);
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _weekdaysOnly
                          ? 'De lunes a viernes'
                          : 'Días seleccionados',
                      style: AppTypography.support,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: _TimeField(
                            label: 'Salir desde',
                            value: form.departureTime,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _TimeField(
                            label: 'Hasta',
                            value: form.arrivalTime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Empieza',
                      style: AppTypography.sectionTitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 20,
                            color: AppColors.ink2,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              form.startDate,
                              style: AppTypography.body,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 22,
                            color: AppColors.ink2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.repeat,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Así funciona',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Cada semana creamos tus solicitudes y te '
                                  'avisamos cuando haya un viaje confirmado. '
                                  'Solo pagas los viajes que se confirman.',
                                  style: AppTypography.support,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(
              child: AppButton(label: 'Guardar programación', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard();

  @override
  Widget build(BuildContext context) {
    final TripRoute route = TripsExtraData.recurringForm.route;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Origen', style: AppTypography.label),
                const SizedBox(height: 3),
                Text(
                  route.origin,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                const Text('Destino', style: AppTypography.label),
                const SizedBox(height: 3),
                Text(
                  route.destination,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Column(
            children: [
              Icon(
                Icons.radio_button_unchecked,
                size: 20,
                color: AppColors.primary,
              ),
              SizedBox(height: 4),
              Icon(Icons.arrow_downward, size: 15, color: AppColors.ink3),
              SizedBox(height: 4),
              Icon(Icons.location_on, size: 21, color: AppColors.warning),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayCircle extends StatelessWidget {
  const _DayCircle({
    required this.letter,
    required this.selected,
    required this.onTap,
  });

  final String letter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.primary : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          letter,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.ink2,
          ),
        ),
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
