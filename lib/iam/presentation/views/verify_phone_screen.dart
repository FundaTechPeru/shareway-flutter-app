import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/app_bottom_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_info_card.dart';
import '../../../shared/widgets/app_otp_field.dart';
import 'permissions_screen.dart';

/// ACC-05 · Verificar celular (código SMS)
class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  static const String routeName = '/verify';

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  String _code = '4819';

  void _verify() {
    if (_code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa los 6 dígitos del código.')),
      );
      return;
    }
    Navigator.of(context).pushReplacementNamed(PermissionsScreen.routeName);
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
                      'Verifica tu celular',
                      style: AppTypography.screenTitle,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Enviamos un código de 6 dígitos por SMS al '
                      '+51 987 654 321.',
                      style: AppTypography.body.copyWith(color: AppColors.ink2),
                    ),
                    const SizedBox(height: 28),
                    AppOtpField(
                      initialValue: '4819',
                      onChanged: (value) => _code = value,
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Icon(Icons.schedule, size: 18, color: AppColors.ink2),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Puedes pedir otro código en 0:42',
                            style: AppTypography.support,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const AppTextAction(label: 'Cambiar número'),
                    const SizedBox(height: AppSpacing.md),
                    const AppInfoCard(
                      icon: Icons.shield_outlined,
                      title: '¿Por qué lo pedimos?',
                      message:
                          'Tu celular nos permite avisarte de cambios '
                          'en el viaje y proteger tu cuenta.',
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(
              divider: true,
              child: AppButton(label: 'Verificar', onPressed: _verify),
            ),
          ],
        ),
      ),
    );
  }
}
