import 'package:flutter/material.dart';

import '../../../../iam/presentation/views/login_screen.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../booking/payment_methods_screen.dart';
import '../trips/recurring_trip_form_screen.dart';
import 'blocked_users_screen.dart';
import 'edit_profile_screen.dart';
import 'emergency_contacts_screen.dart';
import 'settings_screen.dart';

/// PAS-22 · Mi perfil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginScreen.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.lg,
            AppSpacing.screenMargin,
            AppSpacing.xl,
          ),
          children: [
            const _Header(),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  _MenuRow(
                    icon: Icons.edit_outlined,
                    label: 'Editar perfil',
                    onTap: () => Navigator.of(context)
                        .pushNamed(EditProfileScreen.routeName),
                  ),
                  const Divider(),
                  _MenuRow(
                    icon: Icons.credit_card,
                    label: 'Métodos de pago',
                    onTap: () => Navigator.of(context)
                        .pushNamed(PaymentMethodsScreen.routeName),
                  ),
                  const Divider(),
                  _MenuRow(
                    icon: Icons.shield_outlined,
                    label: 'Contactos de emergencia',
                    onTap: () => Navigator.of(context)
                        .pushNamed(EmergencyContactsScreen.routeName),
                  ),
                  const Divider(),
                  _MenuRow(
                    icon: Icons.repeat,
                    label: 'Viajes recurrentes',
                    onTap: () => Navigator.of(context)
                        .pushNamed(RecurringTripFormScreen.routeName),
                  ),
                  const Divider(),
                  _MenuRow(
                    icon: Icons.block,
                    label: 'Usuarios bloqueados',
                    onTap: () => Navigator.of(context)
                        .pushNamed(BlockedUsersScreen.routeName),
                  ),
                  const Divider(),
                  _MenuRow(
                    icon: Icons.settings_outlined,
                    label: 'Configuración',
                    onTap: () => Navigator.of(context)
                        .pushNamed(SettingsScreen.routeName),
                  ),
                  const Divider(),
                  _MenuRow(
                    icon: Icons.help_outline,
                    label: 'Ayuda y soporte',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: TextButton.icon(
                onPressed: () => _logout(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  textStyle: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: const Icon(Icons.logout, size: 19),
                label: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 66,
          height: 66,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.accentSoft,
            shape: BoxShape.circle,
          ),
          child: const Text(
            'LP',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: AppColors.warning,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lucía Paredes',
                style: AppTypography.screenTitle.copyWith(fontSize: 25),
              ),
              const SizedBox(height: 4),
              Text(
                'Pasajera desde agosto de 2026',
                style: AppTypography.support.copyWith(color: AppColors.ink2),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: AppColors.accent),
                  const SizedBox(width: 5),
                  Text(
                    '4.9 · 18 viajes',
                    style: AppTypography.support.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.surface2,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.edit_outlined,
            size: 20,
            color: AppColors.ink2,
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 21, color: AppColors.ink2),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body.copyWith(
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
