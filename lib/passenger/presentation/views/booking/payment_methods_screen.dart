import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_info_card.dart';
import '../../../../shared/widgets/section_header.dart';

/// PAS-07 · Métodos de pago
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  static const String routeName = '/passenger/payment-methods';

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selected = 0;

  static const List<_CardItem> _cards = [
    _CardItem(
      brand: 'Visa •••• 4821',
      meta: 'Vence 08/28 · Predeterminada',
    ),
    _CardItem(
      brand: 'Mastercard •••• 0937',
      meta: 'Vence 02/27',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Métodos de pago')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.lg,
            AppSpacing.screenMargin,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Tus tarjetas'),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _cards.length; i++) ...[
                      if (i > 0) const Divider(),
                      _CardRow(
                        card: _cards[i],
                        selected: _selected == i,
                        onTap: () => setState(() => _selected = i),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    textStyle: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Agregar tarjeta'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const AppInfoCard(
                icon: Icons.lock_outline,
                title: 'Tus datos están protegidos',
                message: 'ShareWay no guarda el número completo de tu '
                    'tarjeta. El pago lo procesa la pasarela de pagos.',
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: '¿Cómo se cobra?'),
              const _ChargeStep(
                number: 1,
                title: 'Al reservar',
                subtitle: 'Apartamos el monto estimado.',
              ),
              const SizedBox(height: AppSpacing.md),
              const _ChargeStep(
                number: 2,
                title: 'Al terminar el viaje',
                subtitle: 'Cobramos el precio final.',
              ),
              const SizedBox(height: AppSpacing.md),
              const _ChargeStep(
                number: 3,
                title: 'Si cancelas a tiempo',
                subtitle: 'Liberamos la autorización completa.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardItem {
  const _CardItem({required this.brand, required this.meta});

  final String brand;
  final String meta;
}

class _CardRow extends StatelessWidget {
  const _CardRow({
    required this.card,
    required this.selected,
    required this.onTap,
  });

  final _CardItem card;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
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
                    card.brand,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(card.meta, style: AppTypography.support),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

class _ChargeStep extends StatelessWidget {
  const _ChargeStep({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final int number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTypography.support),
            ],
          ),
        ),
      ],
    );
  }
}
