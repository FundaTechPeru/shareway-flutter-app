import 'package:flutter/material.dart';

import '../../../data/profile_data.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

/// PAS-21 · Contactos de emergencia
class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  static const String routeName = '/passenger/emergency-contacts';

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Contactos de emergencia')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  AppSpacing.sm,
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          for (
                            var i = 0;
                            i < ProfileData.emergencyContacts.length;
                            i++
                          ) ...[
                            if (i > 0) const Divider(),
                            _ContactRow(
                              contact: ProfileData.emergencyContacts[i],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {},
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
                        label: const Text('Agregar contacto'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Nuevo contacto',
                      style: AppTypography.sectionTitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Nombre completo', style: AppTypography.label),
                    const SizedBox(height: 6),
                    const _InputField(
                      hint: 'Ej.: Ana Paredes',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Row(
                      children: [
                        Expanded(
                          child: _LabeledSelect(
                            label: 'Parentesco',
                            value: 'Ej.: tía',
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _LabeledSelect(
                            label: 'Celular',
                            value: '+51',
                            icon: Icons.phone_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
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
                            Icons.shield_outlined,
                            size: 20,
                            color: AppColors.ink2,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cuándo les escribimos',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Solo reciben un SMS cuando compartes un '
                                  'viaje o cuando se activa una alerta de '
                                  'emergencia. Máximo 3 contactos.',
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
                label: 'Guardar contacto',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.contact});

  final EmergencyContact contact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: contact.background,
              shape: BoxShape.circle,
            ),
            child: Text(
              contact.initials,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: contact.foreground,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(contact.meta, style: AppTypography.support),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (contact.primary)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Principal',
                style: AppTypography.label.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            )
          else
            const Icon(Icons.more_vert, size: 20, color: AppColors.ink3),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({required this.hint, required this.icon});

  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.ink3),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hint,
              style: AppTypography.body.copyWith(color: AppColors.ink3),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledSelect extends StatelessWidget {
  const _LabeledSelect({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label),
        const SizedBox(height: 6),
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 19, color: AppColors.ink2),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  value,
                  style: AppTypography.body.copyWith(color: AppColors.ink3),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 22,
                color: AppColors.ink2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
