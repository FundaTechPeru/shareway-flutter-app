import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_card.dart';
import 'boarding_code_screen.dart';
import 'cancel_booking_screen.dart';
import '../errors/late_penalty_sheet.dart';
import '../errors/price_change_sheet.dart';

/// PAS-09 · Detalle de mi reserva
///
/// Con [showPriceChange] abre el sheet PAS-E4 (cambio de precio) al abrir
/// la pantalla. Con [lateCancellation] el botón de cancelar abre el sheet
/// PAS-E5 (penalidad por cancelación tardía).
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
  @override
  void initState() {
    super.initState();
    if (widget.showPriceChange) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showPriceChangeSheet(context);
      });
    }
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
    Navigator.of(context).pushNamed(CancelBookingScreen.routeName);
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
                  const _StatusBanner(),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 20, color: AppColors.success),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reserva confirmada',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Sale mañana, mié 7 oct, a las 7:10 a. m.',
                  style: TextStyle(
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
    return const AppCard(
      padding: EdgeInsets.all(14),
      child: Row(
        children: [
          _CircleIcon(icon: Icons.directions_car_outlined),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toyota Yaris 2019',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Gris plata · sedán',
                  style: TextStyle(fontSize: 13, color: AppColors.ink2),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          _PlateBadge(),
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
      child: const Text(
        'BKL-482',
        style: TextStyle(
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
    return const AppCard(
      padding: EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              'CH',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Carlos Huamán',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.verified,
                      size: 17,
                      color: AppColors.success,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 15, color: AppColors.accent),
                    SizedBox(width: 4),
                    Text(
                      '4.8 · 312 viajes',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.ink2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.ink3),
        ],
      ),
    );
  }
}

class _StopsCard extends StatelessWidget {
  const _StopsCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              child: Column(
                children: [
                  _RingDot(color: AppColors.primary),
                  Expanded(child: ColoredBox(color: AppColors.border)),
                  _RingDot(color: AppColors.warning),
                ],
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                children: [
                  _StopLine(
                    title: 'Av. Arequipa con Risso',
                    subtitle: 'Tu punto de recojo',
                    time: '7:10 a. m.',
                    spaced: true,
                  ),
                  _StopLine(
                    title: 'Av. Rivera Navarrete 501',
                    subtitle: 'San Isidro',
                    time: '7:38 a. m.',
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
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.ink2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.ink3,
            ),
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
            onTap: () => Navigator.of(context)
                .pushNamed(BoardingCodeScreen.routeName),
          ),
          const Divider(),
          _ActionRow(
            icon: Icons.share,
            label: 'Compartir mi ubicación',
            onTap: () => Navigator.of(context)
                .pushNamed('/passenger/share-location'),
          ),
          const Divider(),
          _ActionRow(
            icon: Icons.navigation_outlined,
            label: 'Seguir el viaje en el mapa',
            onTap: () => Navigator.of(context).pushNamed('/passenger/live-trip'),
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
