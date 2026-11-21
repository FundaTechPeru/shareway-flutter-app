import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../../../passenger/repositories/auth_repository.dart';
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

  final TextEditingController _account = TextEditingController(
    text: 'lucia.paredes@correo.pe',
  );
  final TextEditingController _password = TextEditingController(
    text: 'secreta123',
  );

  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _account.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _errorMessage = null;
      _emailError = null;
      _passwordError = null;
    });

    if (!(_formKey.currentState?.validate() ?? true)) return;

    final email = _account.text.trim();
    final password = _password.text;

    if (email.isEmpty) {
      setState(() => _emailError = 'Ingresa tu correo');
      return;
    }
    if (password.isEmpty) {
      setState(() => _passwordError = 'Ingresa tu contraseña');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepository.login(email, password);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(PermissionsScreen.routeName);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        if (e.isUnauthorized) {
          _errorMessage =
              'Credenciales incorrectas. Revisa tu correo y contraseña.';
        } else if (e.isValidationError) {
          _emailError = e.getFieldError('email');
          _passwordError = e.getFieldError('password');
          _errorMessage = e.message;
        } else {
          _errorMessage = e.message;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudo iniciar sesión. Verifique su conexión.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle subtitle = AppTypography.body.copyWith(
      color: AppColors.ink2,
    );

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
                const Text('Hola de nuevo', style: AppTypography.screenTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Ingresa para ver tus viajes programados.',
                  style: subtitle,
                ),
                const SizedBox(height: 26),
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.errorSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: AppTypography.support.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                AppTextField(
                  label: 'Correo o celular',
                  hint: 'lucia.paredes@correo.pe',
                  icon: Icons.mail_outline,
                  controller: _account,
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.username],
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Contraseña',
                  icon: Icons.lock_outline,
                  controller: _password,
                  errorText: _passwordError,
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
                    onPressed: () =>
                        Navigator.of(context)
                            .pushNamed(ForgotPasswordScreen.routeName),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Iniciar sesión',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _submit,
                ),
                const SizedBox(height: 20),
                const _DividerWithLabel(label: 'o'),
                const SizedBox(height: 20),
                AppButton(
                  label: 'Crear cuenta',
                  variant: AppButtonVariant.secondary,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(RegisterScreen.routeName),
                ),
                const SizedBox(height: 28),
                Text(
                  'Al continuar aceptas los Términos de uso y la Política de '
                  'privacidad de ShareWay.',
                  textAlign: TextAlign.center,
                  style: AppTypography.support.copyWith(color: AppColors.ink3),
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
