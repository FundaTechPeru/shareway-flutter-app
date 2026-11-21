import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../../driver/domain/driver_map_models.dart';
import '../widgets/shareway_components.dart';
import '../widgets/route_map_preview.dart';

enum EmergencyLinkMode { live, alertSent, expired }

class EmergencyTrackingScreen extends StatelessWidget {
  const EmergencyTrackingScreen({super.key, required this.mode});

  final EmergencyLinkMode mode;

  @override
  Widget build(BuildContext context) {
    if (mode == EmergencyLinkMode.expired) {
      return const _ExpiredEmergencyLinkScreen();
    }

    final isAlert = mode == EmergencyLinkMode.alertSent;
    return Scaffold(
      appBar: AppBar(
        title: const ShareWayWordmark(compact: true),
        actions: [
          if (isAlert)
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Center(
                child: StatusPill(
                  label: 'Emergencia',
                  color: ShareWayColors.error,
                  icon: Icons.warning_rounded,
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 22),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isAlert
                  ? const Color(0xFFFFE4E1)
                  : ShareWayColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  isAlert
                      ? Icons.warning_amber_rounded
                      : Icons.location_on_rounded,
                  color: isAlert
                      ? ShareWayColors.error
                      : ShareWayColors.primary,
                  size: 19,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isAlert
                        ? 'Carlos activó una alerta'
                        : 'Ubicación compartida en vivo',
                    style: TextStyle(
                      color: isAlert
                          ? ShareWayColors.error
                          : ShareWayColors.primaryDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isAlert)
            const Padding(
              padding: EdgeInsets.only(top: 6, bottom: 10),
              child: Text(
                'Te avisamos porque eres su contacto de confianza.',
                style: TextStyle(
                  color: ShareWayColors.secondaryInk,
                  fontSize: 11,
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(top: 7, bottom: 10),
              child: Text(
                'Actualizada hace 5 s',
                style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
              ),
            ),
          RouteMapPreview(
            height: isAlert ? 285 : 245,
            activeStop: 2,
            points: DriverDemoMapRoutes.linceToSanIsidro,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAlert
                        ? 'Última ubicación conocida'
                        : 'Lucía va camino a San Isidro',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isAlert
                        ? 'Av. Arenales 1250, Lince · actualizada a las 7:21 a. m.'
                        : 'Llega cerca de las 7:38 a. m. · faltan 14 min',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(height: 24),
                  const Row(
                    children: [
                      Icon(
                        Icons.directions_car_filled_rounded,
                        color: ShareWayColors.primary,
                        size: 19,
                      ),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Toyota Yaris 2019\nGris plata · sedán',
                          style: TextStyle(
                            color: ShareWayColors.ink,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                      Text(
                        'BKL-482',
                        style: TextStyle(
                          color: ShareWayColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (!isAlert) ...[
                    const Divider(height: 24),
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: ShareWayColors.primarySoft,
                          child: Text(
                            'CH',
                            style: TextStyle(
                              color: ShareWayColors.primaryDark,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'Carlos Huamán\nConductor verificado por ShareWay',
                            style: TextStyle(
                              color: ShareWayColors.ink,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.verified_rounded,
                          color: ShareWayColors.success,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (isAlert) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showCallMessage(context, 'Carlos'),
                    icon: const Icon(Icons.call_rounded, size: 16),
                    label: const Text('Llamar a Carlos'),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: ShareWayColors.error,
                    ),
                    onPressed: () => _showCallMessage(context, '105'),
                    icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
                    label: const Text('Llamar al 105'),
                  ),
                ),
              ],
            ),
          ] else
            FilledButton.icon(
              onPressed: () => _showCallMessage(context, 'Lucía'),
              icon: const Icon(Icons.call_rounded),
              label: const Text('Llamar a Lucía'),
            ),
          const SizedBox(height: 10),
          const Text(
            'El enlace dejará de funcionar cuando termine el viaje.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ShareWayColors.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }

  static void _showCallMessage(BuildContext context, String contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Llamada de demostración a $contact.')),
    );
  }
}

class _ExpiredEmergencyLinkScreen extends StatelessWidget {
  const _ExpiredEmergencyLinkScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const ShareWayWordmark(compact: true)),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconTile(
              icon: Icons.lock_outline_rounded,
              color: ShareWayColors.muted,
              background: ShareWayColors.pale,
            ),
            const SizedBox(height: 16),
            Text(
              'Este enlace ya no está disponible',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'El viaje terminó y el seguimiento se desactivó automáticamente.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_in_talk_outlined,
                      color: ShareWayColors.primary,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Si necesitas ubicar a Carlos, comunícate directamente con él.',
                        style: TextStyle(
                          color: ShareWayColors.secondaryInk,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
