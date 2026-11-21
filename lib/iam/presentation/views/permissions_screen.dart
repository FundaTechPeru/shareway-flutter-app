import 'package:flutter/material.dart';

import '../../../passenger/presentation/passenger_shell.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/app_bottom_bar.dart';
import '../../../shared/widgets/app_button.dart';

/// ACC-07 · Permisos de ubicación y notificaciones
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  static const String routeName = '/permissions';

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _location = true;
  bool _notifications = true;

  void _continue() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(PassengerShell.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  AppSpacing.xl,
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dos permisos para empezar',
                      style: AppTypography.screenTitle,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Los usamos solo para tus viajes. Puedes cambiarlos '
                      'cuando quieras.',
                      style: AppTypography.body.copyWith(color: AppColors.ink2),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _PermissionCard(
                      icon: Icons.location_on_outlined,
                      title: 'Ubicación',
                      subtitle:
                          'Para mostrarte rutas cercanas y compartir '
                          'tu recorrido en vivo.',
                      value: _location,
                      onChanged: (value) => setState(() => _location = value),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _PermissionCard(
                      icon: Icons.notifications_outlined,
                      title: 'Notificaciones',
                      subtitle:
                          'Para avisarte de confirmaciones, cambios y '
                          'la llegada del vehículo.',
                      value: _notifications,
                      onChanged: (value) =>
                          setState(() => _notifications = value),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.lock_outline,
                            size: 16,
                            color: AppColors.ink3,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Compartimos tu ubicación con otra persona solo '
                            'cuando tú lo activas o hay una emergencia.',
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
                  ],
                ),
              ),
            ),
            AppBottomBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(label: 'Continuar', onPressed: _continue),
                  AppTextAction(label: 'Ahora no', onPressed: _continue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 21, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
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
          const SizedBox(width: AppSpacing.sm),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
