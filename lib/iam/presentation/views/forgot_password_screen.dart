import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/app_bottom_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_info_card.dart';
import '../../../shared/widgets/app_text_field.dart';

/// ACC-06 · Recuperar contraseña
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const String routeName = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _account =
      TextEditingController(text: 'lucia.paredes@correo.pe');

  @override
  void dispose() {
    _account.dispose();
    super.dispose();
  }

  void _sendLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Si los datos corresponden a una cuenta, recibirás el enlace '
          'en unos segundos.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  AppSpacing.sm,
                  AppSpacing.screenMargin,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recupera tu contraseña',
                      style: AppTypography.screenTitle,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Escribe el correo o el celular de tu cuenta y te '
                      'enviaremos un enlace para crear una nueva.',
                      style:
                          AppTypography.body.copyWith(color: AppColors.ink2),
                    ),
                    const SizedBox(height: 26),
                    AppTextField(
                      label: 'Correo o celular',
                      hint: 'lucia.paredes@correo.pe',
                      icon: Icons.mail_outline,
                      controller: _account,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.username],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _sendLink(),
                    ),
                    const SizedBox(height: 20),
                    const AppInfoCard(
                      icon: Icons.schedule,
                      title: 'El enlace vence en 30 minutos',
                      message: 'Si los datos corresponden a una cuenta, '
                          'recibirás el mensaje en unos segundos.',
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(
              divider: true,
              child: AppButton(label: 'Enviar enlace', onPressed: _sendLink),
            ),
          ],
        ),
      ),
    );
  }
}
