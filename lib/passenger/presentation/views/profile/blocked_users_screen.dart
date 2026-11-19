import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';

/// PAS-20 · Usuarios bloqueados
class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  static const String routeName = '/passenger/blocked-users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Usuarios bloqueados')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.sm,
            AppSpacing.screenMargin,
            AppSpacing.xl,
          ),
          children: [
            Text(
              'No comparten viaje contigo',
              style: AppTypography.body.copyWith(color: AppColors.ink2),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: const [
                  _BlockedRow(
                    initials: 'LT',
                    name: 'Luis T.',
                    meta: 'Pasajero · desde el 2 oct',
                    background: AppColors.primarySoft,
                    foreground: AppColors.primaryDark,
                  ),
                  Divider(),
                  _BlockedRow(
                    initials: 'MD',
                    name: 'Marco D.',
                    meta: 'Conductor · desde el 14 sep',
                    background: AppColors.accentSoft,
                    foreground: AppColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline, size: 20, color: AppColors.ink2),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bloquear es privado',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'La otra persona no se entera. Si desbloqueas a '
                          'alguien, podría volver a coincidir contigo en '
                          'un viaje.',
                          style: AppTypography.support,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    Icons.info_outline,
                    size: 17,
                    color: AppColors.ink3,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Para bloquear a alguien, abre un viaje pasado y elige '
                    'a la persona.',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.ink3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockedRow extends StatelessWidget {
  const _BlockedRow({
    required this.initials,
    required this.name,
    required this.meta,
    required this.background,
    required this.foreground,
  });

  final String initials;
  final String name;
  final String meta;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: background, shape: BoxShape.circle),
            child: Text(
              initials,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(meta, style: AppTypography.support),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 40),
              textStyle: AppTypography.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Desbloquear'),
          ),
        ],
      ),
    );
  }
}
