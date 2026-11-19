import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'forgot_password_screen.dart';
import 'permissions_screen.dart';
import 'register_screen.dart';

/// ACC-03 · Iniciar sesión
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _account =
      TextEditingController(text: 'lucia.paredes@correo.pe');
  final TextEditingController _password =
      TextEditingController(text: 'secreta123');

  @override
  void dispose() {
    _account.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    _formKey.currentState?.validate();
    Navigator.of(context).pushNamed(PermissionsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle subtitle =
        AppTypography.body.copyWith(color: AppColors.ink2);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBrand(size: 44),
                const SizedBox(height: 26),
                const Text(
                  'Hola de nuevo',
                  style: AppTypography.screenTitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Ingresa para ver tus viajes programados.',
                    style: subtitle),
                const SizedBox(height: 26),
                AppTextField(
                  label: 'Correo o celular',
                  hint: 'lucia.paredes@correo.pe',
                  icon: Icons.mail_outline,
                  controller: _account,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.username],
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Contraseña',
                  icon: Icons.lock_outline,
                  controller: _password,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppTextAction(
                    label: '¿Olvidaste tu contraseña?',
                    onPressed: () => Navigator.of(context)
                        .pushNamed(ForgotPasswordScreen.routeName),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(label: 'Iniciar sesión', onPressed: _submit),
                const SizedBox(height: 20),
                const _DividerWithLabel(label: 'o'),
                const SizedBox(height: 20),
                AppButton(
                  label: 'Crear cuenta',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(RegisterScreen.routeName),
                ),
                const SizedBox(height: 28),
                Text(
                  'Al continuar aceptas los Términos de uso y la Política de '
                  'privacidad de ShareWay.',
                  textAlign: TextAlign.center,
                  style:
                      AppTypography.support.copyWith(color: AppColors.ink3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerWithLabel extends StatelessWidget {
  const _DividerWithLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: AppTypography.support.copyWith(color: AppColors.ink3),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
