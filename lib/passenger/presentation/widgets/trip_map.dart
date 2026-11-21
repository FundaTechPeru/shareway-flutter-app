import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';

/// Mapa estilizado con la ruta de un viaje.
///
/// Se usa en el detalle del viaje (PAS-04) y donde haga falta representar el
/// recorrido sin depender de un proveedor de mapas.
class TripMap extends StatelessWidget {
  const TripMap({
    super.key,
    this.height = 150,
    this.radius = 0,
    this.showStopLabel = true,
  });

  final double height;
  final double radius;
  final bool showStopLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double w = constraints.maxWidth;
            final double h = constraints.maxHeight;

            return Stack(
              fit: StackFit.expand,
              children: [
                const CustomPaint(painter: _TripMapPainter()),
                Positioned(
                  left: w * 0.07 - 8,
                  top: h * 0.62 - 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 4),
                    ),
                  ),
                ),
                Positioned(
                  left: w * 0.33 - 13,
                  top: h * 0.46 - 13,
                  child: Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      showStopLabel ? '2' : '',
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: w * 0.90 - 17,
                  top: h * 0.10 - 34,
                  child: const Icon(
                    Icons.place,
                    size: 38,
                    color: AppColors.accent,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TripMapPainter extends CustomPainter {
  const _TripMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(18)),
      Paint()..color = AppColors.surface2,
    );

    final Paint block = Paint()..color = const Color(0xFFD8E9DA);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.60, h * 0.04, w * 0.13, h * 0.18),
      block,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.10, h * 0.70, w * 0.13, h * 0.20),
      block,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.78, h * 0.62, w * 0.14, h * 0.18),
      block,
    );

    final Paint street = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    for (final double y in const [0.3, 0.6]) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * y), street);
    }
    for (final double x in const [0.2, 0.45, 0.7, 0.92]) {
      canvas.drawLine(Offset(w * x, 0), Offset(w * x, h), street);
    }

    final Paint route = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      Path()
        ..moveTo(w * 0.07, h * 0.62)
        ..lineTo(w * 0.33, h * 0.46)
        ..lineTo(w * 0.60, h * 0.34)
        ..lineTo(w * 0.90, h * 0.10),
      route,
    );
  }

  @override
  bool shouldRepaint(covariant _TripMapPainter oldDelegate) => false;
}
