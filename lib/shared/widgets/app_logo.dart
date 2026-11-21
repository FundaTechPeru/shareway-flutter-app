import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Logotipo de ShareWay: cuadrado redondeado con la "S" y el punto ámbar.
///
/// Usa [onDark] cuando se coloca sobre el fondo primario (splash), para que
/// el cuadrado sea blanco. Sobre fondo claro el cuadrado es primario.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 56, this.onDark = false});

  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final Color background = onDark ? Colors.white : AppColors.primary;
    final Color foreground = onDark ? AppColors.primary : Colors.white;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.26),
      ),
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            'S',
            style: TextStyle(
              fontSize: size * 0.56,
              height: 1,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Container(
              width: size * 0.17,
              height: size * 0.17,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logotipo horizontal: cuadrado + nombre "ShareWay".
class AppBrand extends StatelessWidget {
  const AppBrand({
    super.key,
    this.size = 40,
    this.onDark = false,
    this.textColor,
  });

  final double size;
  final bool onDark;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(size: size, onDark: onDark),
        const SizedBox(width: 10),
        Text(
          'ShareWay',
          style: TextStyle(
            fontSize: size * 0.5,
            height: 1,
            fontWeight: FontWeight.w700,
            color: textColor ?? (onDark ? Colors.white : AppColors.primaryDark),
          ),
        ),
      ],
    );
  }
}
