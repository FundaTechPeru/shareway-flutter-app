import 'package:flutter/material.dart';

import '../../../models/payment_models.dart';
import '../../../repositories/payment_method_repository.dart';
import '../../../../core/network/api_exception.dart';
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
  final PaymentMethodRepository _repository = PaymentMethodRepository();
  List<PaymentMethodItem> _cards = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await _repository.getPaymentMethods();
      if (mounted) {
        setState(() {
          _cards = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e is ApiException
              ? e.message
              : 'Error al cargar métodos de pago';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteCard(String id) async {
    try {
      await _repository.deletePaymentMethod(id);
      await _fetchCards();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is ApiException ? e.message : 'No se pudo eliminar la tarjeta',
          ),
        ),
      );
    }
  }

  Future<void> _showAddCardDialog() async {
    final brandController = TextEditingController(text: 'Visa');
    final last4Controller = TextEditingController(text: '4821');
    final tokenController = TextEditingController(text: 'tok_visa');
    int expMonth = 12;
    int expYear = 2028;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar tarjeta de prueba'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nota: La app no guarda el número ni CVV completos. '
                'Envía cardToken ya tokenizado (ej. tok_visa o tok_declined).',
                style: AppTypography.support,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(
                  labelText: 'Marca (Visa / Mastercard)',
                ),
              ),
              TextField(
                controller: last4Controller,
                decoration: const InputDecoration(
                  labelText: 'Últimos 4 dígitos',
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
              ),
              TextField(
                controller: tokenController,
                decoration: const InputDecoration(
                  labelText: 'Card Token (ej. tok_visa / tok_declined)',
                  hintText: 'tok_visa',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await _repository.addPaymentMethod(
                  cardToken: tokenController.text.trim(),
                  brand: brandController.text.trim(),
                  last4: last4Controller.text.trim(),
                  expMonth: expMonth,
                  expYear: expYear,
                );
                if (!context.mounted) return;
                _fetchCards();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e is ApiException
                          ? e.message
                          : 'Error al registrar la tarjeta',
                    ),
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Métodos de pago')),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTypography.body,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchCards,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
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
                    if (_cards.isEmpty)
                      AppCard(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Aún no tienes tarjetas registradas.',
                            style: AppTypography.body.copyWith(
                              color: AppColors.ink2,
                            ),
                          ),
                        ),
                      )
                    else
                      AppCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.xs,
                        ),
                        child: Column(
                          children: [
                            for (int i = 0; i < _cards.length; i++) ...[
                              if (i > 0) const Divider(),
                              _CardRowItem(
                                item: _cards[i],
                                selected: _selected == i,
                                onTap: () => setState(() => _selected = i),
                                onDelete: () => _deleteCard(_cards[i].id),
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
                        onPressed: _showAddCardDialog,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusPill,
                            ),
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
                      message:
                          'ShareWay no guarda el número completo de tu '
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

class _CardRowItem extends StatelessWidget {
  const _CardRowItem({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  final PaymentMethodItem item;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

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
                    item.displayTitle,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  if (item.displayExpiry.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(item.displayExpiry, style: AppTypography.support),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 20,
              ),
              onPressed: onDelete,
              tooltip: 'Eliminar tarjeta',
            ),
            const SizedBox(width: AppSpacing.xs),
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
