import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/app_logo.dart';
import 'onboarding_screen.dart';

/// ACC-01 · Splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(OnboardingScreen.routeName);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: CustomPaint(
          painter: const _SplashWavesPainter(),
          child: SafeArea(
            child: Column(
              children: const [
                Expanded(child: Center(child: _SplashContent())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(size: 92, onDark: true),
        SizedBox(height: 20),
        Text(
          'ShareWay',
          style: TextStyle(
            fontSize: 34,
            height: 1.1,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Viajes compartidos y programados',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, height: 1.4, color: Color(0xCCFFFFFF)),
        ),
      ],
    );
  }
}

/// Dos bandas onduladas más claras que el fondo primario.
class _SplashWavesPainter extends CustomPainter {
  const _SplashWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint paint = Paint()..color = const Color(0x14FFFFFF);

    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.14)
        ..quadraticBezierTo(w * 0.28, h * 0.06, w * 0.55, h * 0.13)
        ..quadraticBezierTo(w * 0.80, h * 0.20, w, h * 0.11)
        ..lineTo(w, h * 0.21)
        ..quadraticBezierTo(w * 0.80, h * 0.30, w * 0.55, h * 0.23)
        ..quadraticBezierTo(w * 0.28, h * 0.16, 0, h * 0.24)
        ..close(),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.62)
        ..quadraticBezierTo(w * 0.30, h * 0.54, w * 0.58, h * 0.62)
        ..quadraticBezierTo(w * 0.82, h * 0.69, w, h * 0.60)
        ..lineTo(w, h * 0.70)
        ..quadraticBezierTo(w * 0.82, h * 0.79, w * 0.58, h * 0.72)
        ..quadraticBezierTo(w * 0.30, h * 0.64, 0, h * 0.72)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SplashWavesPainter oldDelegate) => false;
}
