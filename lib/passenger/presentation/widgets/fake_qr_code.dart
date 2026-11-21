import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';

/// QR decorativo determinista.
///
/// No es un QR válido: reproduce el aspecto del código de la referencia
/// (PAS-11) sin añadir una dependencia de generación de códigos.
class FakeQrCode extends StatelessWidget {
  const FakeQrCode({super.key, this.size = 212, this.seed = 20251007});

  final double size;
  final int seed;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _QrPainter(seed));
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter(this.seed);

  final int seed;

  static const int _modules = 25;

  @override
  void paint(Canvas canvas, Size size) {
    final double cell = size.width / _modules;
    final Paint dark = Paint()..color = AppColors.ink;
    final Paint light = Paint()..color = Colors.white;

    canvas.drawRect(Offset.zero & size, light);

    int state = seed;
    int next() {
      state = (state * 1103515245 + 12345) & 0x7fffffff;
      return state;
    }

    bool inFinder(int x, int y) {
      const int f = 7;
      return (x < f && y < f) ||
          (x >= _modules - f && y < f) ||
          (x < f && y >= _modules - f);
    }

    for (int y = 0; y < _modules; y++) {
      for (int x = 0; x < _modules; x++) {
        if (inFinder(x, y)) continue;
        if (next() % 100 < 47) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), dark);
        }
      }
    }

    void finder(int ox, int oy) {
      canvas.drawRect(
        Rect.fromLTWH(ox * cell, oy * cell, 7 * cell, 7 * cell),
        dark,
      );
      canvas.drawRect(
        Rect.fromLTWH((ox + 1) * cell, (oy + 1) * cell, 5 * cell, 5 * cell),
        light,
      );
      canvas.drawRect(
        Rect.fromLTWH((ox + 2) * cell, (oy + 2) * cell, 3 * cell, 3 * cell),
        dark,
      );
    }

    finder(0, 0);
    finder(_modules - 7, 0);
    finder(0, _modules - 7);
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) =>
      oldDelegate.seed != seed;
}
