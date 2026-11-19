import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/app_bottom_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'login_screen.dart';
import 'verify_phone_screen.dart';

enum _AccountRole { passenger, driver }

/// ACC-04 · Crear cuenta (pasajero o conductor)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  _AccountRole _role = _AccountRole.passenger;
  bool _acceptTerms = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RoleSelector(
                      selected: _role,
                      onChanged: (role) => setState(() => _role = role),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Si conduces, luego te pediremos licencia y documentos.',
                      style: AppTypography.support,
                    ),
                    const SizedBox(height: 22),
                    const AppTextField(
                      label: 'Nombre completo',
                      hint: 'Lucía Paredes Rojas',
                      icon: Icons.person_outline,
                      autofillHints: [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    const AppTextField(
                      label: 'Correo',
                      hint: 'lucia.paredes@correo.pe',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    const AppTextField(
                      label: 'Celular',
                      hint: '+51 987 654 321',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      autofillHints: [AutofillHints.telephoneNumber],
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    const AppTextField(
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Mínimo 8 caracteres, con una letra y un número.',
                      style: AppTypography.support,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) =>
                              setState(() => _acceptTerms = value ?? false),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Acepto los Términos y la Política de privacidad',
                            style: AppTypography.support
                                .copyWith(color: AppColors.ink),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: 'Continuar',
                    onPressed: _acceptTerms
                        ? () => Navigator.of(context)
                            .pushNamed(VerifyPhoneScreen.routeName)
                        : null,
                  ),
                  AppTextAction(
                    label: '¿Ya tienes cuenta? Inicia sesión',
                    onPressed: () => Navigator.of(context)
                        .pushNamed(LoginScreen.routeName),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.selected,
    required this.onChanged,
  });

  final _AccountRole selected;
  final ValueChanged<_AccountRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        children: [
          Expanded(
            child: _RoleOption(
              label: 'Pasajero',
              icon: Icons.person_outline,
              selected: selected == _AccountRole.passenger,
              onTap: () => onChanged(_AccountRole.passenger),
            ),
          ),
          Expanded(
            child: _RoleOption(
              label: 'Conductor',
              icon: Icons.directions_car_outlined,
              selected: selected == _AccountRole.driver,
              onTap: () => onChanged(_AccountRole.driver),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color foreground =
        selected ? AppColors.primaryDark : AppColors.ink2;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: selected
              ? Border.all(color: AppColors.border)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: foreground),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.body.copyWith(
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
