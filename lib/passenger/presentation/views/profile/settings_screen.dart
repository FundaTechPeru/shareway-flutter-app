import 'package:flutter/material.dart';

import '../../../../iam/presentation/views/login_screen.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';

/// PAS-24 · Configuración
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/passenger/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _arrival = true;
  bool _ratingReminder = true;
  bool _news = false;

  void _logout() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Configuración')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.sm,
            AppSpacing.screenMargin,
            AppSpacing.xl,
          ),
          children: [
            Text(
              'Notificaciones',
              style: AppTypography.sectionTitle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppCard(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  _FixedRow(
                    icon: Icons.error_outline,
                    title: 'Cambios y alertas del viaje',
                    subtitle: 'Siempre activas',
                  ),
                  Divider(),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  _SwitchRow(
                    icon: Icons.directions_car_outlined,
                    title: 'Llegada del vehículo',
                    subtitle: '10 minutos antes del recojo',
                    value: _arrival,
                    onChanged: (value) => setState(() => _arrival = value),
                  ),
                  const Divider(),
                  _SwitchRow(
                    icon: Icons.star_outline,
                    title: 'Recordatorio para calificar',
                    subtitle: 'Después de cada viaje',
                    value: _ratingReminder,
                    onChanged: (value) =>
                        setState(() => _ratingReminder = value),
                  ),
                  const Divider(),
                  _SwitchRow(
                    icon: Icons.mail_outline,
                    title: 'Novedades y promociones',
                    subtitle: 'Ofertas y cambios del servicio',
                    value: _news,
                    onChanged: (value) => setState(() => _news = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    Icons.info_outline,
                    size: 17,
                    color: AppColors.ink3,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Las alertas críticas del viaje no se pueden desactivar.',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.ink3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Privacidad y seguridad',
              style: AppTypography.sectionTitle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  _LinkRow(
                    icon: Icons.location_on_outlined,
                    label: 'Permisos de ubicación',
                    onTap: () {},
                  ),
                  const Divider(),
                  _LinkRow(
                    icon: Icons.lock_outline,
                    label: 'Cambiar contraseña',
                    onTap: () {},
                  ),
                  const Divider(),
                  _LinkRow(
                    icon: Icons.description_outlined,
                    label: 'Términos y privacidad',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: TextButton.icon(
                onPressed: _logout,
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
            const SizedBox(height: AppSpacing.sm),
            const Center(
              child: Text('ShareWay 1.0.0', style: AppTypography.support),
            ),
          ],
        ),
      ),
    );
  }
}

class _FixedRow extends StatelessWidget {
  const _FixedRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 21, color: AppColors.ink2),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.support),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 13, color: AppColors.ink2),
                SizedBox(width: 4),
                Text(
                  'Fijas',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 21, color: AppColors.ink2),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.support),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.borderStrong,
          ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
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
