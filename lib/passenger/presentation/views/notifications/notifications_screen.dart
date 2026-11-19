import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../emergency/emergency_alert_screen.dart';
import '../emergency/live_tracking_screen.dart';

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

  static const List<_Notification> _today = [
    _Notification(
      id: 5,
      icon: Icons.error_outline,
      tone: _Tone.error,
      title: 'Carlos activó una alerta',
      body:
          'Viaje SW-58213 · Av. Arenales 1250, Lince. '
          'Ubicación en vivo disponible.',
      time: 'hace 1 min',
      route: EmergencyAlertScreen.routeName,
    ),
    _Notification(
      id: 0,
      icon: Icons.directions_car_outlined,
      tone: _Tone.primary,
      title: 'Tu conductor va en camino',
      body: 'Carlos H. saldrá en 10 minutos desde Av. Arequipa con Risso.',
      time: 'hace 5 min',
      route: LiveTrackingScreen.routeName,
    ),
    _Notification(
      id: 1,
      icon: Icons.check_circle_outline,
      tone: _Tone.success,
      title: 'Reserva confirmada',
      body: 'Jue 8 oct · Lince a San Isidro · 7:10 a. m. · S/ 7.50.',
      time: 'hace 2 h',
    ),
  ];

  static const List<_Notification> _earlier = [
    _Notification(
      id: 2,
      icon: Icons.star_outline,
      tone: _Tone.accent,
      title: 'Califica tu viaje de ayer',
      body: 'Tienes 48 horas para puntuar a Carlos H.',
      time: 'ayer',
    ),
    _Notification(
      id: 3,
      icon: Icons.repeat,
      tone: _Tone.primary,
      title: 'Tu viaje recurrente está activo',
      body: 'Crearemos la solicitud de la próxima semana el lunes.',
      time: '2 oct',
    ),
    _Notification(
      id: 4,
      icon: Icons.credit_card,
      tone: _Tone.neutral,
      title: 'Pago aprobado',
      body: 'Cobramos S/ 7.50 a tu Visa •••• 4821.',
      time: '2 oct',
    ),
  ];

  void _open(_Notification notification) {
    setState(() => _read.add(notification.id));
    final String? route = notification.route;
    if (route != null && mounted) {
      Navigator.of(context).pushNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool allRead = _read.length >= _today.length + _earlier.length;

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
                      for (final _Notification item in [
                        ..._today,
                        ..._earlier,
                      ]) {
                        _read.add(item.id);
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
            const _SectionLabel('Hoy'),
            for (final _Notification item in _today) ...[
              _NotificationCard(
                notification: item,
                unread: !_read.contains(item.id),
                onTap: () => _open(item),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            const SizedBox(height: AppSpacing.sm),
            const _SectionLabel('Anteriores'),
            for (final _Notification item in _earlier) ...[
              _NotificationCard(
                notification: item,
                unread: !_read.contains(item.id),
                onTap: () => _open(item),
              ),
              const SizedBox(height: AppSpacing.md),
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

enum _Tone { primary, success, accent, neutral, error }

class _Notification {
  const _Notification({
    required this.id,
    required this.icon,
    required this.tone,
    required this.title,
    required this.body,
    required this.time,
    this.route,
  });

  final int id;
  final IconData icon;
  final _Tone tone;
  final String title;
  final String body;
  final String time;

  /// Ruta a abrir al tocar el aviso, si corresponde.
  final String? route;
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.unread,
    required this.onTap,
  });

  final _Notification notification;
  final bool unread;
  final VoidCallback onTap;

  (Color background, Color foreground) get _palette {
    switch (notification.tone) {
      case _Tone.primary:
        return (AppColors.primarySoft, AppColors.primary);
      case _Tone.success:
        return (AppColors.successSoft, AppColors.success);
      case _Tone.accent:
        return (AppColors.accentSoft, AppColors.warning);
      case _Tone.neutral:
        return (AppColors.surface2, AppColors.ink2);
      case _Tone.error:
        return (AppColors.errorSoft, AppColors.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground) = _palette;

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
            child: Icon(notification.icon, size: 21, color: foreground),
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
