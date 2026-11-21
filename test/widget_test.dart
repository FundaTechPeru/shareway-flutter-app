import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shareway_flutter_app/app.dart';
import 'package:shareway_flutter_app/passenger/presentation/views/emergency/emergency_alert_screen.dart';
import 'package:shareway_flutter_app/passenger/presentation/views/emergency/expired_link_screen.dart';
import 'package:shareway_flutter_app/passenger/presentation/views/emergency/live_tracking_screen.dart';
import 'package:shareway_flutter_app/passenger/presentation/views/notifications/notifications_screen.dart';

/// Vuelca una pantalla suelta sin pasar por el splash.
Future<void> _pumpStandalone(WidgetTester tester, Widget screen) async {
  await tester.pumpWidget(MaterialApp(home: screen));
}

void main() {
  testWidgets('muestra el splash de ShareWay', (WidgetTester tester) async {
    await tester.pumpWidget(const ShareWayApp());

    expect(find.text('ShareWay'), findsOneWidget);
    expect(find.text('Viajes compartidos y programados'), findsOneWidget);
  });

  testWidgets('el splash navega a iniciar sesión', (WidgetTester tester) async {
    await tester.pumpWidget(const ShareWayApp());

    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa para ver tus viajes programados.'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });

  testWidgets('EME-01 muestra el seguimiento en vivo', (tester) async {
    await _pumpStandalone(tester, const LiveTrackingScreen());

    expect(find.text('En vivo'), findsOneWidget);
    expect(find.text('Lucía va camino a San Isidro'), findsOneWidget);
    expect(find.text('Toyota Yaris 2019'), findsOneWidget);
    expect(find.text('BKL-482'), findsOneWidget);
  });

  testWidgets('EME-02 muestra la alerta de emergencia', (tester) async {
    await _pumpStandalone(tester, const EmergencyAlertScreen());

    expect(find.text('Emergencia'), findsOneWidget);
    expect(find.text('Carlos activó una alerta'), findsOneWidget);
    expect(find.text('Av. Arenales 1250, Lince'), findsOneWidget);
    expect(find.text('Te avisamos porque eres su contacto.'), findsOneWidget);
  });

  testWidgets('EME-03 muestra el enlace expirado', (tester) async {
    await _pumpStandalone(tester, const ExpiredLinkScreen());

    expect(find.text('Este enlace ya no está disponible'), findsOneWidget);
    expect(find.text('¿Necesitas ubicar a Lucía?'), findsOneWidget);
    expect(
      find.text('ShareWay · viajes compartidos y programados'),
      findsOneWidget,
    );
  });

  testWidgets('los avisos se agrupan por fecha', (tester) async {
    await _pumpStandalone(tester, const NotificationsScreen());

    expect(find.text('Avisos'), findsOneWidget);
    expect(find.text('Hoy'), findsOneWidget);
    expect(find.text('Anteriores'), findsOneWidget);
    expect(find.text('Carlos activó una alerta'), findsOneWidget);
  });
}
