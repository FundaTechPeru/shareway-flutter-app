import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../models/fare_models.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/fare_repository.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../data/bookings_data.dart';
import '../errors/seat_unavailable_dialog.dart';
import 'booking_detail_screen.dart';
import 'payment_methods_screen.dart';

/// PAS-05 · Confirmar reserva y pago
class ConfirmBookingScreen extends StatefulWidget {
  const ConfirmBookingScreen({super.key, this.seatUnavailable = false});

  static const String routeName = '/passenger/booking/confirm';

  /// Activa el diálogo de error PAS-E3.
  final bool seatUnavailable;

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  final FareRepository _fareRepository = FareRepository();
  final BookingRepository _bookingRepository = BookingRepository();

  String _groupId = 'grp_demo_123';
  String _requestId = 'req_demo_123';
  FareEstimate? _fareEstimate;
  bool _isLoadingFare = false;
  bool _isReserving = false;
  String? _errorMessage;
  String? _idempotencyKey;

  @override
  void initState() {
    super.initState();
    _idempotencyKey = const Uuid().v4();
    if (widget.seatUnavailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showSeatUnavailableDialog(context);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      if (args['groupId'] != null) _groupId = args['groupId'].toString();
      if (args['requestId'] != null) _requestId = args['requestId'].toString();
      if (_fareEstimate == null && !_isLoadingFare) {
        _fetchFareEstimate();
      }
    }
  }

  Future<void> _fetchFareEstimate() async {
    setState(() {
      _isLoadingFare = true;
      _errorMessage = null;
    });

    try {
      final fare = await _fareRepository.getFareEstimate(_groupId);
      if (mounted) {
        setState(() {
          _fareEstimate = fare;
          _isLoadingFare = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Si no hay estimador remoto, fallback a tarifa predeterminada
          _fareEstimate = const FareEstimate(amount: 7.50, currency: 'S/');
          _isLoadingFare = false;
        });
      }
    }
  }

  Future<void> _confirmBooking() async {
    setState(() {
      _isReserving = true;
      _errorMessage = null;
    });

    try {
      final booking = await _bookingRepository.createBooking(
        groupId: _groupId,
        requestId: _requestId,
        idempotencyKey: _idempotencyKey,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        BookingDetailScreen.routeName,
        arguments: {
          'bookingId': booking.bookingId,
          'status': booking.rawStatus,
        },
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.isConflict) {
        showSeatUnavailableDialog(context);
      } else {
        setState(() {
          _errorMessage = e.message;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudo completar la reserva. Reintente.';
      });
    } finally {
      if (mounted) {
        setState(() => _isReserving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fareText = _fareEstimate != null
        ? _fareEstimate!.formattedPrice
        : BookingsData.confirmPrice.total;

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
                    if (_isLoadingFare)
                      const AppCard(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      const _PriceCard(),
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
                    const SectionHeader(title: 'Pago'),
                    _PaymentRow(
                      onChange: () =>
                          Navigator.of(context)
                              .pushNamed(PaymentMethodsScreen.routeName),
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
                label: 'Confirmar y pagar $fareText',
                icon: Icons.lock_outline,
                isLoading: _isReserving,
                onPressed: _isReserving ? null : _confirmBooking,
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
    final TripSummary trip = BookingsData.confirmTrip;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.schedule,
            style: AppTypography.support.copyWith(color: AppColors.ink3),
          ),
          SizedBox(height: 5),
          Text(
            trip.route,
            style: AppTypography.highlightedData.copyWith(fontSize: 21),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.location_on, size: 17, color: AppColors.warning),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Recojo: ${trip.pickup}',
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
    final PriceBreakdown price = BookingsData.confirmPrice;
    return AppCard(
      child: Column(
        children: [
          for (final PriceLine line in price.lines)
            _PriceRow(
              label: line.label,
              value: line.value,
              valueColor: line.discount ? AppColors.success : AppColors.ink,
            ),
          SizedBox(height: AppSpacing.md),
          Divider(),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  price.totalLabel,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Text(
                price.total,
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
              style: AppTypography.body.copyWith(color: AppColors.ink2),
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
    final PaymentMethod payment = BookingsData.paymentMethod;
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
                  payment.brand,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(payment.note, style: AppTypography.support),
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
