import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../data/bookings_data.dart';
import '../../../data/passenger_data.dart';
import '../../widgets/fake_qr_code.dart';

/// PAS-11 · Mi código de abordaje (PIN y QR)
class BoardingCodeScreen extends StatelessWidget {
  const BoardingCodeScreen({super.key});

  static const String routeName = '/passenger/boarding-code';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Código de abordaje')),
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
                  children: [
                    const _CodeCard(),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 19,
                            color: AppColors.ink2,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Es solo para este viaje',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'No lo envíes por mensaje ni lo publiques.',
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
              child: AppButton(
                label: 'Listo',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard();

  @override
  Widget build(BuildContext context) {
    final BoardingCode code = BookingsData.boardingCode;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 22, AppSpacing.lg, 20),
      child: Column(
        children: [
          Text(
            'Muéstralo al conductor al subir',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${code.date} · ${code.time} · auto ${PassengerData.driver.plate}',
            textAlign: TextAlign.center,
            style: AppTypography.support,
          ),
          const SizedBox(height: AppSpacing.lg),
          const FakeQrCode(size: 214),
          const SizedBox(height: AppSpacing.lg),
          const _LabeledDivider(label: 'o dicta tu PIN'),
          const SizedBox(height: AppSpacing.lg),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PinBox('4'),
              SizedBox(width: AppSpacing.md),
              _PinBox('7'),
              SizedBox(width: AppSpacing.md),
              _PinBox('2'),
              SizedBox(width: AppSpacing.md),
              _PinBox('9'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule, size: 16, color: AppColors.ink2),
              SizedBox(width: 6),
              Text(
                'Vence cuando el viaje inicia',
                style: AppTypography.support,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LabeledDivider extends StatelessWidget {
  const _LabeledDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: AppTypography.support.copyWith(color: AppColors.ink3),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _PinBox extends StatelessWidget {
  const _PinBox(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 62,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        value,
        style: AppTypography.highlightedData.copyWith(fontSize: 26),
      ),
    );
  }
}
