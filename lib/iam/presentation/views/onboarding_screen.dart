import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

/// ACC-02 · Bienvenida (onboarding)
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const String routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    final TextStyle description = AppTypography.body
        .copyWith(color: AppColors.ink2);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.lg,
            AppSpacing.screenMargin,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MapIllustration(height: 175),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Tu viaje compartido, sin improvisar',
                style: AppTypography.screenTitle,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Reserva tu asiento con anticipación y viaja con personas '
                'que van por tu misma ruta.',
                style: description,
              ),
              const SizedBox(height: AppSpacing.xl),
              const _FeatureItem(
                icon: Icons.calendar_month_outlined,
                title: 'Programa con anticipación',
                subtitle: 'Eliges ruta, día y rango horario.',
              ),
              const _FeatureItem(
                icon: Icons.verified_user_outlined,
                title: 'Conductores verificados',
                subtitle: 'Con brevet, SOAT y tarjeta revisados.',
              ),
              const _FeatureItem(
                icon: Icons.people_outline,
                title: 'Precio compartido',
                subtitle: 'Ves el precio estimado antes de reservar.',
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Crear cuenta',
                onPressed: () => Navigator.of(context)
                    .pushNamed(RegisterScreen.routeName),
              ),
              AppTextAction(
                label: 'Ya tengo cuenta',
                onPressed: () =>
                    Navigator.of(context).pushNamed(LoginScreen.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.support),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Ilustración de mapa con la ruta compartida, las paradas y el destino.
class _MapIllustration extends StatelessWidget {
  const _MapIllustration({this.height = 175});

  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
                const CustomPaint(painter: _MapPainter()),
                // Origen
                Positioned(
                  left: w * 0.09 - 8,
                  top: h * 0.76 - 8,
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
                // Parada 1
                Positioned(
                  left: w * 0.29 - 13,
                  top: h * 0.55 - 13,
                  child: const _StopDot(label: '1'),
                ),
                // Parada 2
                Positioned(
                  left: w * 0.63 - 13,
                  top: h * 0.37 - 13,
                  child: const _StopDot(label: '2'),
                ),
                // Vehículo
                Positioned(
                  left: w * 0.47 - 17,
                  top: h * 0.60 - 17,
                  child: Container(
                    width: 34,
                    height: 34,
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
                // Destino
                Positioned(
                  left: w * 0.85 - 17,
                  top: h * 0.15 - 34,
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

class _StopDot extends StatelessWidget {
  const _StopDot({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          height: 1,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Fondo
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(18)),
      Paint()..color = AppColors.surface2,
    );

    // Manzanas
    final Paint block = Paint()..color = const Color(0xFFD8E9DA);
    canvas.drawRect(Rect.fromLTWH(w * 0.64, h * 0.08, w * 0.14, h * 0.16), block);
    canvas.drawRect(Rect.fromLTWH(w * 0.08, h * 0.62, w * 0.12, h * 0.16), block);
    canvas.drawRect(Rect.fromLTWH(w * 0.78, h * 0.64, w * 0.14, h * 0.14), block);

    // Calles
    final Paint street = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    for (final double y in const [0.24, 0.5, 0.76]) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * y), street);
    }
    for (final double x in const [0.2, 0.45, 0.7, 0.92]) {
      canvas.drawLine(Offset(w * x, 0), Offset(w * x, h), street);
    }

    // Ruta compartida
    final Paint route = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      Path()
        ..moveTo(w * 0.09, h * 0.76)
        ..lineTo(w * 0.29, h * 0.55)
        ..lineTo(w * 0.47, h * 0.60)
        ..lineTo(w * 0.63, h * 0.37)
        ..lineTo(w * 0.85, h * 0.15),
      route,
    );
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => false;
}
