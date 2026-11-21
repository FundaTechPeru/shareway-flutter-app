import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ShareWayWordmark extends StatelessWidget {
  const ShareWayWordmark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShareWayMark(size: compact ? 30 : 36),
        const SizedBox(width: 9),
        Text(
          'ShareWay',
          style: TextStyle(
            color: ShareWayColors.primaryDark,
            fontSize: compact ? 16 : 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class ShareWayMark extends StatelessWidget {
  const ShareWayMark({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(size * 0.28),
      border: Border.all(color: ShareWayColors.border.withValues(alpha: 0.8)),
    ),
    child: CustomPaint(painter: _ShareWayMarkPainter()),
  );
}

class _ShareWayMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = ShareWayColors.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.105
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final mark = Path()
      ..moveTo(size.width * 0.72, size.height * 0.25)
      ..lineTo(size.width * 0.43, size.height * 0.25)
      ..cubicTo(
        size.width * 0.23,
        size.height * 0.25,
        size.width * 0.23,
        size.height * 0.48,
        size.width * 0.43,
        size.height * 0.50,
      )
      ..lineTo(size.width * 0.59, size.height * 0.50)
      ..cubicTo(
        size.width * 0.80,
        size.height * 0.52,
        size.width * 0.78,
        size.height * 0.76,
        size.width * 0.58,
        size.height * 0.76,
      )
      ..lineTo(size.width * 0.28, size.height * 0.76);
    canvas.drawPath(mark, stroke);
    canvas.drawCircle(
      Offset(size.width * 0.77, size.height * 0.22),
      size.width * 0.095,
      Paint()..color = ShareWayColors.accent,
    );
  }

  @override
  bool shouldRepaint(covariant _ShareWayMarkPainter oldDelegate) => false;
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: ShareWayColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              minimumSize: const Size(40, 36),
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    this.color = ShareWayColors.primary,
    this.background,
  });

  final IconData icon;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class IllustratedRouteMap extends StatelessWidget {
  const IllustratedRouteMap({
    super.key,
    this.height = 190,
    this.activeStop = 0,
    this.showVehicle = true,
  });

  final double height;
  final int activeStop;
  final bool showVehicle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _RouteMapPainter(
                  activeStop: activeStop,
                  showVehicle: showVehicle,
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.near_me_rounded,
                      size: 14,
                      color: ShareWayColors.primary,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Recorrido ilustrativo',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteMapPainter extends CustomPainter {
  const _RouteMapPainter({required this.activeStop, required this.showVehicle});

  final int activeStop;
  final bool showVehicle;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(bounds, Paint()..color = const Color(0xFFEAF0EF));

    final blockPaint = Paint()..color = const Color(0xFFF8FAF9);
    final parkPaint = Paint()..color = const Color(0xFFD7EBDD);
    for (var row = 0; row < 5; row++) {
      for (var col = 0; col < 7; col++) {
        final rect = Rect.fromLTWH(
          col * size.width / 6.2 + 4,
          row * size.height / 4.6 + 6,
          size.width / 9.3,
          size.height / 8,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(5)),
          ((row + col) % 5 == 1) ? parkPaint : blockPaint,
        );
      }
    }

    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    for (var row = 1; row < 5; row++) {
      final y = row * size.height / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 8), streetPaint);
    }
    for (var col = 1; col < 6; col++) {
      final x = col * size.width / 6;
      canvas.drawLine(Offset(x, 0), Offset(x + 5, size.height), streetPaint);
    }

    final route = Path()
      ..moveTo(size.width * 0.08, size.height * 0.78)
      ..lineTo(size.width * 0.27, size.height * 0.61)
      ..lineTo(size.width * 0.42, size.height * 0.66)
      ..lineTo(size.width * 0.58, size.height * 0.37)
      ..lineTo(size.width * 0.76, size.height * 0.43)
      ..lineTo(size.width * 0.91, size.height * 0.19);
    canvas.drawPath(
      route,
      Paint()
        ..color = ShareWayColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final points = [
      Offset(size.width * 0.08, size.height * 0.78),
      Offset(size.width * 0.27, size.height * 0.61),
      Offset(size.width * 0.42, size.height * 0.66),
      Offset(size.width * 0.58, size.height * 0.37),
      Offset(size.width * 0.76, size.height * 0.43),
      Offset(size.width * 0.91, size.height * 0.19),
    ];
    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final isActive = index <= activeStop;
      canvas.drawCircle(point, 10, Paint()..color = Colors.white);
      canvas.drawCircle(
        point,
        7,
        Paint()
          ..color = isActive ? ShareWayColors.primary : ShareWayColors.muted,
      );
      if (index > 0 && index < points.length - 1) {
        final text = TextPainter(
          text: TextSpan(
            text: '$index',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        text.paint(canvas, point - Offset(text.width / 2, text.height / 2));
      }
    }
    if (showVehicle) {
      final car = points[activeStop.clamp(0, points.length - 2).toInt()];
      canvas.drawCircle(car, 14, Paint()..color = Colors.white);
      canvas.drawCircle(car, 11, Paint()..color = ShareWayColors.primaryDark);
      const icon = Icons.directions_car_rounded;
      final vehicle = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: const TextStyle(
            fontFamily: 'MaterialIcons',
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      vehicle.paint(
        canvas,
        car - Offset(vehicle.width / 2, vehicle.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RouteMapPainter oldDelegate) =>
      activeStop != oldDelegate.activeStop ||
      showVehicle != oldDelegate.showVehicle;
}

enum ServiceViewState { loading, offline, serviceError, sessionExpired }

class ServiceStatePanel extends StatelessWidget {
  const ServiceStatePanel({
    super.key,
    required this.state,
    this.onRetry,
    this.onAction,
  });

  final ServiceViewState state;
  final VoidCallback? onRetry;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final config = switch (state) {
      ServiceViewState.loading => (
        Icons.more_horiz_rounded,
        'Cargando tus viajes',
        'Estamos buscando la información más reciente.',
      ),
      ServiceViewState.offline => (
        Icons.wifi_off_rounded,
        'Sin conexión',
        'Revisa tu conexión y vuelve a intentarlo. No perdiste ninguna reserva.',
      ),
      ServiceViewState.serviceError => (
        Icons.warning_amber_rounded,
        'No pudimos completar la solicitud',
        'El servicio tardó en responder. Inténtalo de nuevo en unos momentos.',
      ),
      ServiceViewState.sessionExpired => (
        Icons.lock_outline_rounded,
        'Tu sesión expiró',
        'Vuelve a iniciar sesión para continuar.',
      ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state == ServiceViewState.loading)
              const CircularProgressIndicator(color: ShareWayColors.primary)
            else
              IconTile(
                icon: config.$1,
                color: ShareWayColors.primaryDark,
                background: ShareWayColors.primarySoft,
              ),
            const SizedBox(height: 16),
            Text(
              config.$2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 7),
            Text(
              config.$3,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (state != ServiceViewState.loading) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: state == ServiceViewState.sessionExpired
                    ? onAction
                    : onRetry,
                icon: Icon(
                  state == ServiceViewState.sessionExpired
                      ? Icons.login_rounded
                      : Icons.refresh_rounded,
                  size: 17,
                ),
                label: Text(
                  state == ServiceViewState.sessionExpired
                      ? 'Iniciar sesión'
                      : 'Reintentar',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
