import 'package:flutter/material.dart';

import '../../shared/presentation/emergency_link_screen.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';
import 'driver_controller.dart';

class DriverEmergencyScreen extends StatelessWidget {
  const DriverEmergencyScreen({super.key, required this.controller});

  final DriverController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Alerta de emergencia')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(19),
              decoration: BoxDecoration(
                color: controller.emergencySent
                    ? ShareWayColors.error
                    : const Color(0xFFFFE4E1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: controller.emergencySent
                        ? Colors.white
                        : ShareWayColors.error,
                    size: 34,
                  ),
                  const SizedBox(height: 9),
                  Text(
                    controller.emergencySent
                        ? 'Alerta enviada'
                        : '¿Necesitas ayuda?',
                    style: TextStyle(
                      color: controller.emergencySent
                          ? Colors.white
                          : ShareWayColors.error,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    controller.emergencySent
                        ? (controller.emergencyMessage ?? '')
                        : 'Avisaremos a tus contactos y compartiremos tu ubicación del viaje.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: controller.emergencySent
                          ? Colors.white.withValues(alpha: 0.9)
                          : ShareWayColors.secondaryInk,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 17),
            if (controller.emergencySent) ...[
              const SectionHeading(title: 'Estado del envío'),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: const [
                      _DeliveryStatus(
                        icon: Icons.shield_rounded,
                        label: 'Central de ShareWay',
                        detail: 'Alerta recibida · 7:21 a. m.',
                        sent: true,
                      ),
                      Divider(height: 24),
                      _DeliveryStatus(
                        icon: Icons.person_outline_rounded,
                        label: 'Marta H. (esposa)',
                        detail: 'Aviso enviado',
                        sent: true,
                      ),
                      Divider(height: 24),
                      _DeliveryStatus(
                        icon: Icons.my_location_rounded,
                        label: 'Tu ubicación en vivo',
                        detail: 'Compartida mientras dure la alerta',
                        sent: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const EmergencyTrackingScreen(
                      mode: EmergencyLinkMode.alertSent,
                    ),
                  ),
                ),
                icon: const Icon(Icons.share_location_rounded),
                label: const Text('Ver enlace de emergencia'),
              ),
              const SizedBox(height: 9),
            ] else ...[
              Card(
                child: ListTile(
                  leading: const IconTile(icon: Icons.contact_phone_outlined),
                  title: const Text(
                    'Contacto de confianza',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Marta H. (esposa) · +51 987 654 321',
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: ShareWayColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  leading: const IconTile(icon: Icons.location_on_outlined),
                  title: const Text(
                    'Ubicación del viaje',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Compartiremos la ubicación mientras la alerta esté activa.',
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: const Icon(
                    Icons.check_circle_rounded,
                    color: ShareWayColors.success,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: ShareWayColors.error,
                ),
                onPressed: () {
                  controller.sendEmergencyAlert();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alerta de demostración enviada.'),
                    ),
                  );
                },
                icon: const Icon(Icons.sos_rounded),
                label: const Text('Enviar alerta de emergencia'),
              ),
              const SizedBox(height: 9),
            ],
            OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Llamada de emergencia de demostración.'),
                ),
              ),
              icon: const Icon(Icons.call_rounded),
              label: const Text('Llamar al 105'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const EmergencyTrackingScreen(
                    mode: EmergencyLinkMode.expired,
                  ),
                ),
              ),
              icon: const Icon(Icons.link_off_rounded, size: 17),
              label: const Text('Ver ejemplo de enlace expirado'),
            ),
            const SizedBox(height: 10),
            const Text(
              'En una emergencia real, llama directamente a los servicios de emergencia.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryStatus extends StatelessWidget {
  const _DeliveryStatus({
    required this.icon,
    required this.label,
    required this.detail,
    required this.sent,
  });

  final IconData icon;
  final String label;
  final String detail;
  final bool sent;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(
        icon,
        color: sent ? ShareWayColors.success : ShareWayColors.muted,
        size: 19,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3),
            Text(
              detail,
              style: const TextStyle(color: ShareWayColors.muted, fontSize: 10),
            ),
          ],
        ),
      ),
      Icon(
        sent ? Icons.check_circle_rounded : Icons.schedule_rounded,
        color: sent ? ShareWayColors.success : ShareWayColors.accent,
        size: 17,
      ),
    ],
  );
}
