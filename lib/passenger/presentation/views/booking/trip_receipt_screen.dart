import 'package:flutter/material.dart';

import '../../../repositories/payment_repository.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../data/bookings_data.dart';
import '../../passenger_shell.dart';

/// PAS-16 · Recibo del viaje
class TripReceiptScreen extends StatefulWidget {
  const TripReceiptScreen({super.key});

  static const String routeName = '/passenger/receipt';

  @override
  State<TripReceiptScreen> createState() => _TripReceiptScreenState();
}

class _TripReceiptScreenState extends State<TripReceiptScreen> {
  final PaymentRepository _paymentRepository = PaymentRepository();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args['paymentId'] != null) {
      _loadPayment(args['paymentId'].toString());
    }
  }

  Future<void> _loadPayment(String paymentId) async {
    try {
      await _paymentRepository.getPaymentDetail(paymentId);
      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      if (mounted) {}
    }
  }

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
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
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
    final ReceiptSummary summary = BookingsData.receipt.summary;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _DoneBadge(),
              Spacer(),
              Text(
                summary.date,
                style: AppTypography.support.copyWith(color: AppColors.ink3),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            summary.route,
            style: AppTypography.highlightedData.copyWith(fontSize: 21),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.schedule, size: 17, color: AppColors.ink2),
              SizedBox(width: 6),
              Expanded(
                child: Text(summary.schedule, style: AppTypography.support),
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
    final PriceBreakdown breakdown = BookingsData.receipt.breakdown;
    return AppCard(
      child: Column(
        children: [
          for (final PriceLine line in breakdown.lines)
            _Row(
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
                  breakdown.totalLabel,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Text(
                breakdown.total,
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
                  BookingsData.receipt.payment.brand,
                  style: AppTypography.support.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Text(
                BookingsData.receipt.payment.status,
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
    final List<LabeledValue> meta = BookingsData.receipt.meta;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          for (int i = 0; i < meta.length; i++) ...[
            if (i > 0) const Divider(),
            _MetaRow(label: meta[i].label, value: meta[i].value),
          ],
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
