import 'package:flutter/material.dart';

import '../../../models/auth_models.dart';
import '../../../repositories/auth_repository.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../data/passenger_data.dart';
import '../../passenger_shell.dart';
import '../search/search_trip_screen.dart';
import '../trips/recurring_trip_form_screen.dart';

/// PAS-01 · Inicio con rutas populares
///
/// Con [emptyRoutes] en `true` muestra el estado vacío PAS-E1 (sin rutas
/// populares cerca de la ubicación).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.emptyRoutes = false});

  /// Activa el estado vacío PAS-E1.
  final bool emptyRoutes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            // La tarjeta de búsqueda monta sobre el borde del encabezado.
            SizedBox(
              height: 40,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: AppSpacing.screenMargin,
                    right: AppSpacing.screenMargin,
                    top: -36,
                    child: _SearchCard(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: 'Tu próximo viaje',
                    actionLabel: 'Ver todos',
                    onAction: () => PassengerShellScope.of(context).goToTab(1),
                  ),
                  const _NextTripCard(),
                  const SizedBox(height: AppSpacing.lg),
                  const SectionHeader(title: 'Rutas populares cerca de ti'),
                  if (emptyRoutes)
                    const _EmptyRoutes()
                  else ...[
                    for (final PopularRoute route
                        in PassengerData.popularRoutes)
                      _PopularRoute(route: route),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.of(context)
                              .pushNamed(RecurringTripFormScreen.routeName),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.ink,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusPill,
                          ),
                        ),
                        textStyle: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      icon: const Icon(Icons.refresh, size: 19),
                      label: const Text('Programar un viaje recurrente'),
                    ),
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

/// PAS-E1 · Estado vacío de rutas populares.
class _EmptyRoutes extends StatelessWidget {
  const _EmptyRoutes();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_walk,
              size: 34,
              color: AppColors.ink3,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Todavía no hay rutas populares cerca de ti',
            textAlign: TextAlign.center,
            style: AppTypography.sectionTitle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Programa un viaje y crea la primera ruta de tu zona.',
            textAlign: TextAlign.center,
            style: AppTypography.support.copyWith(height: 1.5),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppTypography.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('Cambiar mi ubicación'),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header();

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  final AuthRepository _authRepository = AuthRepository();
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _authRepository.getProfile();
      if (mounted) {
        setState(() => _userProfile = profile);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final name = _userProfile?.fullName.isNotEmpty == true
        ? _userProfile!.fullName.split(' ')[0]
        : PassengerData.account.name;

    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.lg,
        AppSpacing.screenMargin,
        46,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, $name',
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Color(0xCCFFFFFF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      PassengerData.account.location,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 13.5,
                        color: const Color(0xCCFFFFFF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => PassengerShellScope.of(context).goToTab(2),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0x1FFFFFFF),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 23,
                  ),
                  Positioned(
                    top: 10,
                    right: 11,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: AppCard(
        radius: AppSpacing.radiusLg,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        onTap: () =>
            Navigator.of(context).pushNamed(SearchTripScreen.routeName),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿A dónde vas?',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Programa tu viaje compartido',
                    style: AppTypography.support,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.ink3),
          ],
        ),
      ),
    );
  }
}

class _NextTripCard extends StatelessWidget {
  const _NextTripCard();

  @override
  Widget build(BuildContext context) {
    final NextTrip trip = PassengerData.nextTrip;

    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 54,
            height: 66,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  trip.weekday,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  trip.day,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  trip.month,
                  style: const TextStyle(fontSize: 11, color: AppColors.ink2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.route,
                  style: AppTypography.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 15, color: AppColors.ink2),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(trip.schedule, style: AppTypography.support),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const _ConfirmedBadge(),
                    const Spacer(),
                    Text(
                      trip.passengers,
                      style: AppTypography.label.copyWith(
                        color: AppColors.ink3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: AppColors.ink3),
        ],
      ),
    );
  }
}

class _ConfirmedBadge extends StatelessWidget {
  const _ConfirmedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 13, color: AppColors.success),
          SizedBox(width: 4),
          Text(
            'Confirmado',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularRoute extends StatelessWidget {
  const _PopularRoute({required this.route});

  final PopularRoute route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        onTap: () =>
            Navigator.of(context).pushNamed(SearchTripScreen.routeName),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.swap_horiz,
                color: AppColors.warning,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${route.from} → ${route.to}',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(route.detail, style: AppTypography.support),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'desde',
                  style: AppTypography.label.copyWith(color: AppColors.ink3),
                ),
                const SizedBox(height: 2),
                Text(
                  route.price,
                  style: AppTypography.highlightedData.copyWith(
                    color: AppColors.primary,
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
