import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../data/passenger_data.dart';

/// Pestaña "Avisos" del pasajero.
///
/// No existe un mockup de referencia para esta vista; se diseña con la
/// guía de estilo siguiendo el patrón de listas del módulo passenger.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  /// Ids de los avisos que el usuario ya abrió.
  final Set<int> _read = {3};

  void _open(AppNotification notification) {
    setState(() => _read.add(notification.id));
    final String? route = notification.route;
    if (route != null && mounted) {
      Navigator.of(context).pushNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<NotificationGroup> groups = PassengerData.notificationGroups;
    final int totalCount = groups
        .expand((NotificationGroup group) => group.items)
        .length;
    final bool allRead = _read.length >= totalCount;

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
            Row(
              children: [
                Expanded(
                  child: Text('Avisos', style: AppTypography.screenTitle),
                ),
                if (!allRead)
                  TextButton(
                    onPressed: () => setState(() {
                      for (final NotificationGroup group in groups) {
                        for (final AppNotification item in group.items) {
                          _read.add(item.id);
                        }
                      }
                    }),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 40),
                      textStyle: AppTypography.support.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Marcar todos'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            for (int g = 0; g < groups.length; g++) ...[
              if (g > 0) const SizedBox(height: AppSpacing.sm),
              _SectionLabel(groups[g].label),
              for (final AppNotification item in groups[g].items) ...[
                _NotificationCard(
                  notification: item,
                  unread: !_read.contains(item.id),
                  onTap: () => _open(item),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        text,
        style: AppTypography.label.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.ink3,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.unread,
    required this.onTap,
  });

  final AppNotification notification;
  final bool unread;
  final VoidCallback onTap;

  /// Icono y colores que corresponden al tipo del aviso.
  (IconData icon, Color background, Color foreground) get _style {
    switch (notification.type) {
      case NotificationType.tripOnWay:
        return (
          Icons.directions_car_outlined,
          AppColors.primarySoft,
          AppColors.primary,
        );
      case NotificationType.bookingConfirmed:
        return (
          Icons.check_circle_outline,
          AppColors.successSoft,
          AppColors.success,
        );
      case NotificationType.rating:
        return (Icons.star_outline, AppColors.accentSoft, AppColors.warning);
      case NotificationType.recurring:
        return (Icons.repeat, AppColors.primarySoft, AppColors.primary);
      case NotificationType.payment:
        return (Icons.credit_card, AppColors.surface2, AppColors.ink2);
      case NotificationType.emergency:
        return (Icons.error_outline, AppColors.errorSoft, AppColors.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color background, Color foreground) = _style;

    return AppCard(
      padding: const EdgeInsets.all(14),
      backgroundColor: unread ? AppColors.surface : AppColors.background,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 21, color: foreground),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: AppTypography.body.copyWith(
                          fontWeight: unread
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    if (unread) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: AppTypography.support.copyWith(height: 1.45),
                ),
                const SizedBox(height: 6),
                Text(
                  notification.time,
                  style: AppTypography.label.copyWith(color: AppColors.ink3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
