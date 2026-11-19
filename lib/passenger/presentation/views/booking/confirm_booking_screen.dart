import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../errors/seat_unavailable_dialog.dart';
import 'booking_success_screen.dart';
import 'payment_methods_screen.dart';

/// PAS-05 · Confirmar reserva y pago
///
/// Con [seatUnavailable] muestra el diálogo de error PAS-E3 (el viaje se
/// quedó sin asientos) al abrir la pantalla.
class ConfirmBookingScreen extends StatefulWidget {
  const ConfirmBookingScreen({super.key, this.seatUnavailable = false});

  static const String routeName = '/passenger/booking/confirm';

  /// Activa el diálogo de error PAS-E3.
  final bool seatUnavailable;

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.seatUnavailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showSeatUnavailableDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Confirmar reserva')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  AppSpacing.md,
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CountdownAlert(),
                    const SizedBox(height: AppSpacing.md),
                    const _TripSummary(),
                    const SizedBox(height: AppSpacing.xl),
                    const SectionHeader(title: 'Precio estimado'),
                    const _PriceCard(),
                    const SizedBox(height: AppSpacing.xl),
                    const SectionHeader(title: 'Pago'),
                    _PaymentRow(
                      onChange: () => Navigator.of(context).pushNamed(
                        PaymentMethodsScreen.routeName,
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
                            'Si el precio cambia por un cambio de ruta, te '
                            'avisaremos antes de continuar.',
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
              child: AppButton(
                label: 'Confirmar y pagar S/ 7.50',
                icon: Icons.lock_outline,
                onPressed: () => Navigator.of(context).pushNamed(
                  BookingSuccessScreen.routeName,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownAlert extends StatelessWidget {
  const _CountdownAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.schedule, size: 20, color: AppColors.warning),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: AppTypography.support,
                    children: [
                      TextSpan(text: 'Tu asiento está apartado por '),
                      TextSpan(
                        text: '04:58',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Confirma el pago antes de que se libre.',
                  style: AppTypography.support,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripSummary extends StatelessWidget {
  const _TripSummary();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jue 8 oct · sale 7:10 a. m.',
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
              Icon(
                Icons.location_on,
                size: 17,
                color: AppColors.warning,
              ),
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

class _PriceCard extends StatelessWidget {
  const _PriceCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          _PriceRow(label: 'Tarifa base', value: 'S/ 3.00'),
          _PriceRow(label: 'Distancia (6.4 km)', value: 'S/ 5.20'),
          _PriceRow(
            label: 'Ahorro por compartir',
            value: '− S/ 0.70',
            valueColor: AppColors.success,
          ),
          SizedBox(height: AppSpacing.md),
          Divider(),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total por 1 asiento',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Text(
                'S/ 7.50',
                style: AppTypography.highlightedData.copyWith(fontSize: 21),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.ink,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.body.copyWith(
                color: AppColors.ink2,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.onChange});

  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.credit_card,
              size: 21,
              color: AppColors.ink2,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visa •••• 4821',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Se cobra al terminar el viaje',
                  style: AppTypography.support,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onChange,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 40),
              textStyle: AppTypography.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('Cambiar'),
          ),
        ],
      ),
    );
  }
}
