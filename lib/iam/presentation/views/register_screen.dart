import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../../../passenger/repositories/auth_repository.dart';
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

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  String? _fullNameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _errorMessage = null;
      _fullNameError = null;
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
    });

    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (fullName.isEmpty) {
      setState(() => _fullNameError = 'Ingresa tu nombre completo');
      return;
    }
    if (email.isEmpty) {
      setState(() => _emailError = 'Ingresa tu correo');
      return;
    }
    if (phone.isEmpty) {
      setState(() => _phoneError = 'Ingresa tu número de celular');
      return;
    }
    if (password.length < 8 || password.length > 72) {
      setState(
        () =>
            _passwordError = 'La contraseña debe tener entre 8 y 72 caracteres',
      );
      return;
    }
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    if (!hasLetter || !hasDigit) {
      setState(
        () => _passwordError =
            'La contraseña debe incluir al menos una letra y un número',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepository.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      // Auto-iniciar sesión luego de registrarse
      await _authRepository.login(email, password);

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(VerifyPhoneScreen.routeName);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        if (e.isConflict) {
          _emailError = 'El correo ya se encuentra registrado';
          _errorMessage =
              'El correo especificado ya está registrado en ShareWay.';
        } else if (e.isValidationError) {
          _fullNameError = e.getFieldError('fullName');
          _emailError = e.getFieldError('email');
          _phoneError = e.getFieldError('phone');
          _passwordError = e.getFieldError('password');
          _errorMessage = e.message;
        } else {
          _errorMessage = e.message;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Ocurrió un error al crear la cuenta. Intenta de nuevo.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
                      label: 'Nombre completo',
                      hint: 'Lucía Paredes Rojas',
                      icon: Icons.person_outline,
                      controller: _fullNameController,
                      errorText: _fullNameError,
                      autofillHints: const [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Correo',
                      hint: 'lucia.paredes@correo.pe',
                      icon: Icons.mail_outline,
                      controller: _emailController,
                      errorText: _emailError,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Celular',
                      hint: '+51 987 654 321',
                      icon: Icons.phone_outlined,
                      controller: _phoneController,
                      errorText: _phoneError,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                      controller: _passwordController,
                      errorText: _passwordError,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
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
                            style: AppTypography.support.copyWith(
                              color: AppColors.ink,
                            ),
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
                    isLoading: _isLoading,
                    onPressed: _acceptTerms && !_isLoading ? _submit : null,
                  ),
                  AppTextAction(
                    label: '¿Ya tienes cuenta? Inicia sesión',
                    onPressed: () =>
                        Navigator.of(context).pushNamed(LoginScreen.routeName),
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
  const _RoleSelector({required this.selected, required this.onChanged});

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
    final Color foreground = selected ? AppColors.primaryDark : AppColors.ink2;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: selected ? Border.all(color: AppColors.border) : null,
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
