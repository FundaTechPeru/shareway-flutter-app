import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../passenger_shell.dart';

/// PAS-16 · Recibo del viaje
class TripReceiptScreen extends StatelessWidget {
  const TripReceiptScreen({super.key});

  static const String routeName = '/passenger/receipt';

  void _goHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      PassengerShell.routeName,
      (route) => false,
      arguments: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Recibo del viaje'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined),
            tooltip: 'Descargar',
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.sm,
            AppSpacing.screenMargin,
            AppSpacing.xl,
          ),
          children: [
            const _SummaryCard(),
            const SizedBox(height: AppSpacing.md),
            const _BreakdownCard(),
            const SizedBox(height: AppSpacing.md),
            const _MetaCard(),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.ink,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  textStyle: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text('Reportar un problema'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: TextButton(
                onPressed: () => _goHome(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: const Text('Volver al inicio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _DoneBadge(),
              Spacer(),
              Text(
                'Mié 7 oct 2026',
                style: AppTypography.support.copyWith(color: AppColors.ink3),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Lince → San Isidro',
            style: AppTypography.highlightedData.copyWith(fontSize: 21),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.schedule, size: 17, color: AppColors.ink2),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '7:10 a 7:38 a. m. · 28 min · 6.4 km',
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

class _DoneBadge extends StatelessWidget {
  const _DoneBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 14, color: AppColors.success),
          SizedBox(width: 5),
          Text(
            'Viaje finalizado',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          _Row(label: 'Tarifa base', value: 'S/ 3.00'),
          _Row(label: 'Distancia (6.4 km)', value: 'S/ 5.20'),
          _Row(
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
                  'Total cobrado',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
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
          SizedBox(height: AppSpacing.md),
          Divider(),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.credit_card, size: 19, color: AppColors.ink2),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Visa •••• 4821',
                  style: AppTypography.support.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Text(
                'Pagado',
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

class _Row extends StatelessWidget {
  const _Row({
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

class _MetaCard extends StatelessWidget {
  const _MetaCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          _MetaRow(label: 'N.° de viaje', value: 'SW-58213'),
          Divider(),
          _MetaRow(label: 'Conductor', value: 'Carlos Huamán'),
          Divider(),
          _MetaRow(label: 'Vehículo', value: 'Toyota Yaris · BKL-482'),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
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
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
