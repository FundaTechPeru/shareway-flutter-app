import 'package:flutter/material.dart';

import '../../../repositories/trip_repository.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../data/trips_extra_data.dart';
import '../../passenger_shell.dart';
import '../../widgets/live_trip_map.dart';
import 'share_location_screen.dart';

/// PAS-12 · Viaje en curso
class LiveTripScreen extends StatefulWidget {
  const LiveTripScreen({super.key});

  static const String routeName = '/passenger/live-trip';

  @override
  State<LiveTripScreen> createState() => _LiveTripScreenState();
}

class _LiveTripScreenState extends State<LiveTripScreen> {
  final TripRepository _tripRepository = TripRepository();
  String? _tripId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args['tripId'] != null) {
      _tripId = args['tripId'].toString();
      _fetchTrip();
    }
  }

  Future<void> _fetchTrip() async {
    if (_tripId == null) return;
    try {
      await _tripRepository.getTripDetail(_tripId!);
      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      if (mounted) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface2,
      body: Stack(
        children: [
          const Positioned.fill(child: LiveTripMap()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _CircleButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      TripsExtraData.liveTrip.statusLabel,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Align(alignment: Alignment.bottomCenter, child: _TripPanel()),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, size: 24, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _TripPanel extends StatelessWidget {
  const _TripPanel();

  void _shareLocation(BuildContext context) {
    Navigator.of(context).pushNamed(ShareLocationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final LiveTripUpdate live = TripsExtraData.liveTrip;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              live.eta,
              style: AppTypography.screenTitle.copyWith(fontSize: 25),
            ),
            const SizedBox(height: 5),
            Text(
              live.etaDetail,
              style: AppTypography.body.copyWith(color: AppColors.ink2),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _NextStopCard(),
            const SizedBox(height: AppSpacing.md),
            const _DriverRow(),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: AppColors.successSoft,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.share, size: 17, color: AppColors.success),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      live.shareStatus,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _PanelButton(
                    label: 'Compartir ubicación',
                    icon: Icons.share,
                    filled: true,
                    onTap: () => _shareLocation(context),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: _PanelButton(
                    label: 'Ayuda',
                    icon: Icons.help_outline,
                    filled: false,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  PassengerShell.routeName,
                  (route) => false,
                  arguments: 0,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: const Text('Terminar demostración'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextStopCard extends StatelessWidget {
  const _NextStopCard();

  @override
  Widget build(BuildContext context) {
    final LiveTripUpdate live = TripsExtraData.liveTrip;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SoftCircle(
            icon: Icons.location_on,
            color: AppColors.accentSoft,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  live.nextStopTitle,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  live.nextStopSubtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.ink2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(
        icon,
        size: 20,
        color: color == AppColors.accentSoft
            ? AppColors.warning
            : AppColors.primary,
      ),
    );
  }
}

class _DriverRow extends StatelessWidget {
  const _DriverRow();

  @override
  Widget build(BuildContext context) {
    final LiveTripUpdate live = TripsExtraData.liveTrip;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              live.driver.initials,
              style: const TextStyle(
                fontSize: 13,
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
                Text(
                  '${live.driver.name} · ${live.driver.plate}',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  live.vehicleLine,
                  style: const TextStyle(fontSize: 13, color: AppColors.ink2),
                ),
              ],
            ),
          ),
          const Icon(Icons.call, size: 22, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _PanelButton extends StatelessWidget {
  const _PanelButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: filled
          ? TextButton.icon(
              onPressed: onTap,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primarySoft,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                textStyle: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: Icon(icon, size: 18),
              label: Text(label),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.ink,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                textStyle: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: Icon(icon, size: 18),
              label: Text(label),
            ),
    );
  }
}
