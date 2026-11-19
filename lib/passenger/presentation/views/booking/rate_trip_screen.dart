import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';

/// PAS-15 · Calificar el viaje
class RateTripScreen extends StatefulWidget {
  const RateTripScreen({super.key});

  static const String routeName = '/passenger/rate-trip';

  @override
  State<RateTripScreen> createState() => _RateTripScreenState();
}

class _RateTripScreenState extends State<RateTripScreen> {
  int _stars = 5;
  final Set<String> _tags = {'Puntual', 'Manejo seguro'};

  static const List<String> _availableTags = [
    'Puntual',
    'Manejo seguro',
    'Auto limpio',
    'Amable',
    'Buena ruta',
  ];

  String get _label {
    switch (_stars) {
      case 1:
        return 'Muy malo';
      case 2:
        return 'Regular';
      case 3:
        return 'Bueno';
      case 4:
        return 'Muy bueno';
      default:
        return 'Excelente';
    }
  }

  void _send() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gracias por calificar el viaje.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface2,
                    foregroundColor: AppColors.ink2,
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.close, size: 22),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xs,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'CH',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '¿Cómo estuvo tu viaje con Carlos?',
                      textAlign: TextAlign.center,
                      style: AppTypography.screenTitle.copyWith(fontSize: 27),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Mié 7 oct · Lince a San Isidro',
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(
                        color: AppColors.ink2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 1; i <= 5; i++)
                          IconButton(
                            onPressed: () => setState(() => _stars = i),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                            ),
                            icon: Icon(
                              i <= _stars ? Icons.star : Icons.star_border,
                              size: 42,
                              color: AppColors.accent,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _label,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      alignment: WrapAlignment.center,
                      children: [
                        for (final String tag in _availableTags)
                          _TagChip(
                            label: tag,
                            selected: _tags.contains(tag),
                            onTap: () => setState(() {
                              _tags.contains(tag)
                                  ? _tags.remove(tag)
                                  : _tags.add(tag);
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Comentario (opcional)',
                        style: AppTypography.label,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Cuéntanos qué estuvo bien o qué mejorarías.',
                        hintStyle: AppTypography.support,
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: const BorderSide(
                            color: AppColors.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: const BorderSide(
                            color: AppColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: AppColors.ink2),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Tienes 48 horas para calificar este viaje.',
                            style: AppTypography.support,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(label: 'Enviar calificación', onPressed: _send),
                  AppTextAction(
                    label: 'Ahora no',
                    onPressed: () => Navigator.of(context).maybePop(),
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

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.body.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : AppColors.ink2,
          ),
        ),
      ),
    );
  }
}
