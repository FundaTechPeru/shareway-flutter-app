import 'package:flutter/material.dart';

import 'dart:async';

import '../../../models/booking_models.dart';
import '../../../repositories/booking_repository.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../data/passenger_data.dart';
import 'boarding_code_screen.dart';
import 'cancel_booking_screen.dart';
import '../errors/late_penalty_sheet.dart';
import '../errors/price_change_sheet.dart';

/// PAS-09 · Detalle de mi reserva
class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({
    super.key,
    this.showPriceChange = false,
    this.lateCancellation = false,
  });

  static const String routeName = '/passenger/booking';

  /// Activa el sheet de cambio de precio PAS-E4.
  final bool showPriceChange;

  /// Hace que cancelar muestre la penalidad PAS-E5.
  final bool lateCancellation;

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  final BookingRepository _bookingRepository = BookingRepository();
  Timer? _pollingTimer;

  String? _bookingId;
  BookingStatus _status = BookingStatus.requested;
  String _statusText = 'REQUESTED';

  @override
  void initState() {
    super.initState();
    if (widget.showPriceChange) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showPriceChangeSheet(context);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _bookingId = args['bookingId']?.toString();
      final statusStr = args['status']?.toString();
      if (statusStr != null) {
        _status = BookingStatus.fromString(statusStr);
        _statusText = statusStr;
      }
      if (_bookingId != null && _pollingTimer == null) {
        _startPolling();
      }
    }
  }

  void _startPolling() {
    _pollBooking();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _pollBooking(),
    );
  }

  Future<void> _pollBooking() async {
    if (_bookingId == null || !mounted) return;
    try {
      final res = await _bookingRepository.getBooking(_bookingId!);
      if (mounted) {
        setState(() {
          _status = res.status;
          _statusText = res.rawStatus ?? res.status.toApiString();
        });
        if (res.status != BookingStatus.requested) {
          _pollingTimer?.cancel();
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _cancel() async {
    if (widget.lateCancellation) {
      final bool? paid = await showLatePenaltySheet(context);
      if (paid == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reserva cancelada. Se cobró la penalidad.'),
          ),
        );
        Navigator.of(context).pop();
      }
      return;
    }
    Navigator.of(context).pushNamed(
      CancelBookingScreen.routeName,
      arguments: {'bookingId': _bookingId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi reserva'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline),
            tooltip: 'Ayuda',
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  AppSpacing.md,
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                ),
                children: [
                  _StatusBanner(status: _status, statusText: _statusText),
                  const SizedBox(height: AppSpacing.md),
                  const _VehicleCard(),
                  const SizedBox(height: AppSpacing.md),
                  const _DriverRow(),
                  const SizedBox(height: AppSpacing.md),
                  const _StopsCard(),
                  const SizedBox(height: AppSpacing.md),
                  const _ActionsCard(),
                ],
              ),
            ),
            AppBottomBar(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _cancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                    ),
                    textStyle: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Cancelar reserva'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({this.status = BookingStatus.requested, this.statusText});

  final BookingStatus status;
  final String? statusText;

  @override
  Widget build(BuildContext context) {
    String title = 'Reserva solicitada (Procesando)';
    String detail = 'Esperando confirmación del backend...';
    Color bgColor = AppColors.accentSoft;
    Color iconColor = AppColors.warning;
    IconData icon = Icons.hourglass_top;

    switch (status) {
      case BookingStatus.confirmed:
        title = 'Reserva confirmada';
        detail = 'Sale hoy a las 7:10 a. m. · con Carlos H.';
        bgColor = AppColors.successSoft;
        iconColor = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case BookingStatus.boarded:
        title = 'Viaje en abordaje / en curso';
        detail = '¡Subiste al vehículo!';
        bgColor = AppColors.primarySoft;
        iconColor = AppColors.primary;
        icon = Icons.directions_car;
        break;
      case BookingStatus.cancelled:
        title = 'Reserva cancelada';
        detail = 'Esta reserva fue cancelada.';
        bgColor = AppColors.errorSoft;
        iconColor = AppColors.error;
        icon = Icons.cancel_outlined;
        break;
      default:
        if (statusText != null) {
          title = 'Estado: $statusText';
        }
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.4,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const _CircleIcon(icon: Icons.directions_car_outlined),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PassengerData.driver.vehicle,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  PassengerData.driver.vehicleDetail,
                  style: const TextStyle(fontSize: 13, color: AppColors.ink2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const _PlateBadge(),
        ],
      ),
    );
  }
}

class _PlateBadge extends StatelessWidget {
  const _PlateBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.ink, width: 1.6),
      ),
      child: Text(
        PassengerData.driver.plate,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 22, color: AppColors.primaryDark),
    );
  }
}

class _DriverRow extends StatelessWidget {
  const _DriverRow();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              PassengerData.driver.initials,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      PassengerData.driver.name,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      size: 17,
                      color: AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 15, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      '${PassengerData.driver.rating} · '
                      '${PassengerData.driver.tripsCount} viajes',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.ink2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.ink3),
        ],
      ),
    );
  }
}

class _StopsCard extends StatelessWidget {
  const _StopsCard();

  @override
  Widget build(BuildContext context) {
    final List<TripStop> stops = PassengerData.currentBooking.stops;

    return AppCard(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              child: Column(
                children: [
                  const _RingDot(color: AppColors.primary),
                  const Expanded(child: ColoredBox(color: AppColors.border)),
                  const _RingDot(color: AppColors.warning),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < stops.length; i++)
                    _StopLine(
                      title: stops[i].title,
                      subtitle: stops[i].subtitle,
                      time: stops[i].time,
                      spaced: i < stops.length - 1,
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

class _StopLine extends StatelessWidget {
  const _StopLine({
    required this.title,
    required this.subtitle,
    required this.time,
    this.spaced = false,
  });

  final String title;
  final String subtitle;
  final String time;
  final bool spaced;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: spaced ? 34 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(fontSize: 13, color: AppColors.ink2),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: AppColors.ink3),
          ),
        ],
      ),
    );
  }
}

class _RingDot extends StatelessWidget {
  const _RingDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 5),
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  const _ActionsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          _ActionRow(
            icon: Icons.qr_code_2,
            label: 'Mi código de abordaje',
            onTap: () =>
                Navigator.of(context).pushNamed(BoardingCodeScreen.routeName),
          ),
          const Divider(),
          _ActionRow(
            icon: Icons.share,
            label: 'Compartir mi ubicación',
            onTap: () =>
                Navigator.of(context).pushNamed('/passenger/share-location'),
          ),
          const Divider(),
          _ActionRow(
            icon: Icons.navigation_outlined,
            label: 'Seguir el viaje en el mapa',
            onTap: () =>
                Navigator.of(context).pushNamed('/passenger/live-trip'),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.ink3),
          ],
        ),
      ),
    );
  }
}
