import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

/// PAS-23 · Editar perfil
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  static const String routeName = '/passenger/profile/edit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Editar perfil')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _PhotoSection(),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Nombre completo', style: AppTypography.label),
                    const SizedBox(height: 6),
                    const _InputField(
                      value: 'Lucía Paredes Rojas',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Correo', style: AppTypography.label),
                    const SizedBox(height: 6),
                    const _InputField(
                      value: 'lucia.paredes@correo.pe',
                      icon: Icons.mail_outline,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Celular', style: AppTypography.label),
                    const SizedBox(height: 6),
                    const _InputField(
                      value: '+51 987 654 321',
                      icon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Verificado. Si lo cambias, te pediremos un código nuevo.',
                      style: AppTypography.support.copyWith(
                        color: AppColors.ink3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          _ActionRow(
                            icon: Icons.lock_outline,
                            label: 'Cambiar contraseña',
                            color: AppColors.ink,
                            onTap: () {},
                          ),
                          const Divider(),
                          _ActionRow(
                            icon: Icons.cancel_outlined,
                            label: 'Eliminar mi cuenta',
                            color: AppColors.error,
                            onTap: () {},
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
                label: 'Guardar cambios',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 104,
                height: 104,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  'LP',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppTypography.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('Cambiar foto'),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({required this.value, required this.icon});

  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.ink2),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: AppTypography.body.copyWith(color: AppColors.ink),
            ),
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
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 21, color: color),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: color,
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
