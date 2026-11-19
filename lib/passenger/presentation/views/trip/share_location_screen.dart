import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../emergency/expired_link_screen.dart';
import '../emergency/live_tracking_screen.dart';

/// PAS-13 · Compartir ubicación
class ShareLocationScreen extends StatefulWidget {
  const ShareLocationScreen({super.key});

  static const String routeName = '/passenger/share-location';

  @override
  State<ShareLocationScreen> createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen> {
  int _selected = 0;

  static const List<_Contact> _contacts = [
    _Contact(
      initials: 'RP',
      name: 'Rosa Paredes',
      meta: 'Mamá · +51 9•• ••204',
      background: AppColors.accentSoft,
      foreground: AppColors.warning,
    ),
    _Contact(
      initials: 'DP',
      name: 'Diego Paredes',
      meta: 'Hermano · +51 9•• •• 871',
      background: AppColors.primarySoft,
      foreground: AppColors.primaryDark,
    ),
  ];

  void _share() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enlace enviado. Se apagará al terminar el viaje.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Compartir ubicación')),
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
                    const SectionHeader(
                      title: '¿Con quién compartes este viaje?',
                    ),
                    AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < _contacts.length; i++) ...[
                            if (i > 0) const Divider(),
                            _ContactRow(
                              contact: _contacts[i],
                              selected: _selected == i,
                              onTap: () => setState(() => _selected = i),
                            ),
                          ],
                          const Divider(),
                          const _AddContactRow(),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _InfoBlock(
                      backgroundColor: AppColors.primarySoft,
                      icon: Icons.chat_bubble_outline,
                      title: 'Qué recibe tu contacto',
                      message:
                          'Un SMS con un enlace para ver el auto en el '
                          'mapa. No necesita instalar la aplicación.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _InfoBlock(
                      backgroundColor: AppColors.surface2,
                      icon: Icons.schedule,
                      title: 'El enlace se apaga solo',
                      message: 'Deja de funcionar apenas termina el viaje.',
                      onTap: () =>
                          Navigator.of(context)
                              .pushNamed(ExpiredLinkScreen.routeName),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: TextButton(
                        onPressed: () =>
                            Navigator.of(context)
                                .pushNamed(LiveTrackingScreen.routeName),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          textStyle: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: const Text('Ver lo que verá tu contacto'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppBottomBar(
              child: AppButton(
                label: 'Compartir ubicación',
                icon: Icons.share,
                onPressed: _share,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Contact {
  const _Contact({
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
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.contact,
    required this.selected,
    required this.onTap,
  });

  final _Contact contact;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: contact.background,
                shape: BoxShape.circle,
              ),
              child: Text(
                contact.initials,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: contact.foreground,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(contact.meta, style: AppTypography.support),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.borderStrong,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Center(
                      child: Icon(Icons.circle, size: 9, color: Colors.white),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddContactRow extends StatelessWidget {
  const _AddContactRow();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surface2,
              child: Icon(Icons.add, size: 20, color: AppColors.ink2),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Agregar otro contacto',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.ink3),
          ],
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.message,
    this.onTap,
  });

  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.ink2),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.support.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(message, style: AppTypography.support),
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right, color: AppColors.ink3),
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: content,
    );
  }
}
