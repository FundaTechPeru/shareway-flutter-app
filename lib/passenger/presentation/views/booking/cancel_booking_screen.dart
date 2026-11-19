import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

/// PAS-14 · Cancelar reserva
class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({super.key});

  static const String routeName = '/passenger/booking/cancel';

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  int _reason = 0;

  static const List<String> _reasons = [
    'Cambié de planes',
    'Encontré otra forma de llegar',
    'El horario ya no me sirve',
    'Otro motivo',
  ];

  void _confirm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reserva cancelada. Sin penalidad.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Cancelar reserva')),
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
                    const _TripCard(),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.successSoft,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 20,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Puedes cancelar sin penalidad',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.success,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Faltan más de 30 minutos para la salida.',
                                  style: AppTypography.support,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      '¿Por qué cancelas?',
                      style: AppTypography.sectionTitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < _reasons.length; i++) ...[
                            if (i > 0) const Divider(),
                            InkWell(
                              onTap: () => setState(() => _reason = i),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _reasons[i],
                                        style: AppTypography.body.copyWith(
                                          color: AppColors.ink,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    _RadioDot(selected: _reason == i),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
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
                            'Tu asiento se libera de inmediato para otro pasajero.',
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
            ),
            AppBottomBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _confirm,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusPill),
                        ),
                        textStyle: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Cancelar reserva'),
                    ),
                  ),
                  AppTextAction(
                    label: 'Mantener mi reserva',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mié 7 oct · sale 7:10 a. m.',
            style: AppTypography.support.copyWith(color: AppColors.ink3),
          ),
          SizedBox(height: 5),
          Text(
            'Lince → San Isidro',
            style: AppTypography.highlightedData.copyWith(fontSize: 21),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.location_on, size: 17, color: AppColors.warning),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Recojo: Av. Arequipa con Risso',
                  style: AppTypography.support,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderStrong,
          width: 2,
        ),
      ),
      child: selected
          ? const Center(
              child: Icon(Icons.circle, size: 9, color: Colors.white),
            )
          : null,
    );
  }
}
