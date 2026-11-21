import 'package:flutter/material.dart';

import 'driver/data/driver_api_repository.dart';
import 'driver/data/demo_driver_repository.dart';
import 'driver/presentation/driver_controller.dart';
import 'driver/presentation/driver_shell.dart';
import 'auth/presentation/session_gate.dart';
import 'shared/data/shareway_api_client.dart';
import 'shared/theme/app_theme.dart';

class ShareWayApp extends StatelessWidget {
  const ShareWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DriverController(DemoDriverRepository());
    const gatewayUrl = String.fromEnvironment(
      'SHAREWAY_API_BASE_URL',
      defaultValue: 'https://shareway-api-gateway.onrender.com',
    );
    final configuredUrl = gatewayUrl.trim();
    final home = configuredUrl.isEmpty
        ? DriverShell(controller: controller)
        : DriverSessionGate(
            repository: DriverApiRepository(
              client: ShareWayApiClient(baseUrl: configuredUrl),
            ),
            demoController: controller,
          );

    return MaterialApp(
      title: 'ShareWay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: home,
    );
  }
}
