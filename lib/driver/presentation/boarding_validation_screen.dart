import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/theme/app_theme.dart';
import '../domain/driver_models.dart';
import 'driver_controller.dart';

class BoardingValidationScreen extends StatefulWidget {
  const BoardingValidationScreen({
    super.key,
    required this.controller,
    required this.tripId,
    required this.passenger,
  });

  final DriverController controller;
  final String tripId;
  final DriverPassenger passenger;

  @override
  State<BoardingValidationScreen> createState() =>
      _BoardingValidationScreenState();
}

class _BoardingValidationScreenState extends State<BoardingValidationScreen> {
  final _pinController = TextEditingController();
  int _attempts = 0;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _validate() {
    if (_pinController.text == '5108') {
      final messenger = ScaffoldMessenger.of(context);
      widget.controller.markPassengerBoarded(
        widget.tripId,
        widget.passenger.name,
      );
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(content: Text('${widget.passenger.name} validado.')),
      );
      return;
    }
    setState(() => _attempts++);
  }

  @override
  Widget build(BuildContext context) {
    final attemptsLeft = 3 - _attempts;
    return Scaffold(
      appBar: AppBar(title: const Text('Validar pasajero')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: ShareWayColors.primarySoft,
                child: Text(
                  widget.passenger.initials,
                  style: const TextStyle(
                    color: ShareWayColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              title: Text(
                widget.passenger.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                widget.passenger.pickup,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: ShareWayColors.ink,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.qr_code_2_rounded,
                  size: 84,
                  color: Colors.white,
                ),
                const SizedBox(height: 7),
                Text(
                  'Escáner QR de demostración',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'O ingresa su PIN',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 9),
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              letterSpacing: 12,
              fontWeight: FontWeight.w700,
            ),
            decoration: const InputDecoration(
              hintText: '••••',
              counterText: 'PIN de ejemplo: 5108',
            ),
          ),
          if (_attempts > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4E1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                attemptsLeft > 0
                    ? 'El código no coincide. Te quedan $attemptsLeft intentos.'
                    : 'Se agotaron los intentos. Contacta a soporte.',
                style: const TextStyle(
                  color: ShareWayColors.error,
                  fontSize: 12,
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: attemptsLeft > 0 ? _validate : null,
            icon: const Icon(Icons.verified_user_outlined),
            label: const Text('Validar código'),
          ),
          const SizedBox(height: 10),
          const Text(
            'El lector de cámara se conectará al flujo de validación cuando se integre el API.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
