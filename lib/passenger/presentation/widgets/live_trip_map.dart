import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';

/// Mapa a pantalla completa con el recorrido del viaje en curso (PAS-12).
class LiveTripMap extends StatelessWidget {
  const LiveTripMap({super.key});

  // Puntos de la ruta como fracción del ancho/alto disponibles.
  static const List<Offset> _route = [
    Offset(0.11, 0.51),
    Offset(0.31, 0.42),
    Offset(0.42, 0.44),
    Offset(0.72, 0.30),
    Offset(0.875, 0.15),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        final double h = constraints.maxHeight;

        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            const CustomPaint(painter: _LiveMapPainter()),
            Positioned(
              left: w * _route[0].dx - 9,
              top: h * _route[0].dy - 9,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 5),
                ),
              ),
            ),
            Positioned(
              left: w * _route[1].dx - 17,
              top: h * _route[1].dy - 17,
              child: Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_bus,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: w * _route[2].dx - 13,
              top: h * _route[2].dy - 13,
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: w * _route[4].dx - 17,
              top: h * _route[4].dy - 34,
              child: const Icon(Icons.place, size: 38, color: AppColors.accent),
            ),
          ],
        );
      },
    );
  }
}

class _LiveMapPainter extends CustomPainter {
  const _LiveMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.surface2);

    // Manzanas verdes
    final Paint block = Paint()..color = const Color(0xFFDCEBDD);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.02, h * 0.36, w * 0.14, h * 0.07),
      block,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.78, h * 0.44, w * 0.16, h * 0.08),
      block,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.46, h * 0.62, w * 0.14, h * 0.07),
      block,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.12, h * 0.74, w * 0.16, h * 0.07),
      block,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.86, h * 0.68, w * 0.14, h * 0.08),
      block,
    );

    // Calles
    final Paint street = Paint()
      ..color = Colors.white
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;

    const List<double> verticals = [0.06, 0.2, 0.34, 0.5, 0.64, 0.79, 0.93];
    const List<double> horizontals = [
      0.08,
      0.2,
      0.33,
      0.46,
      0.6,
      0.73,
      0.86,
      0.97,
    ];

    for (final double x in verticals) {
      canvas.drawLine(Offset(w * x, 0), Offset(w * x, h), street);
    }
    for (final double y in horizontals) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * y), street);
    }

    // Ruta
    final Paint route = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path path = Path()
      ..moveTo(w * LiveTripMap._route[0].dx, h * LiveTripMap._route[0].dy);
    for (int i = 1; i < LiveTripMap._route.length; i++) {
      path.lineTo(w * LiveTripMap._route[i].dx, h * LiveTripMap._route[i].dy);
    }
    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(covariant _LiveMapPainter oldDelegate) => false;
}
