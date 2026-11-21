import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../data/passenger_data.dart';

/// PAS-10 · Perfil del conductor
class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  static const String routeName = '/passenger/driver';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Conductor')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.md,
            AppSpacing.screenMargin,
            AppSpacing.xl,
          ),
          children: [
            const _IdentityCard(),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.star_outline,
                    value: PassengerData.driver.rating,
                    label: 'Calificación promedio',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatCard(
                    icon: Icons.swap_horiz,
                    value: PassengerData.driver.tripsCount,
                    label: 'Viajes realizados',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Documentos'),
            const _DocumentsCard(),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Vehículo'),
            const _VehicleCard(),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Opiniones recientes'),
            const _ReviewCard(),
          ],
        ),
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              PassengerData.driver.initials,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PassengerData.driver.name,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                const AppBadge(
                  label: 'Documentos verificados',
                  tone: AppBadgeTone.success,
                  icon: Icons.verified_outlined,
                  dense: true,
                ),
                const SizedBox(height: 8),
                Text(
                  PassengerData.driver.memberSince,
                  style: const TextStyle(fontSize: 13, color: AppColors.ink2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.ink2),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTypography.highlightedData.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.support),
        ],
      ),
    );
  }
}

class _DocumentsCard extends StatelessWidget {
  const _DocumentsCard();

  @override
  Widget build(BuildContext context) {
    final List<String> documents = PassengerData.driver.documents;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          for (int i = 0; i < documents.length; i++) ...[
            if (i > 0) const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    size: 21,
                    color: AppColors.ink2,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      documents[i],
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const AppBadge(
                    label: 'Aprobado',
                    tone: AppBadgeTone.success,
                    icon: Icons.check,
                    dense: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          const Icon(
            Icons.directions_car_outlined,
            size: 26,
            color: AppColors.ink2,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${PassengerData.driver.vehicle} · gris plata',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  PassengerData.driver.vehicleSeats,
                  style: const TextStyle(fontSize: 13, color: AppColors.ink2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard();

  @override
  Widget build(BuildContext context) {
    final DriverReview review = PassengerData.driver.reviews.first;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Stars(count: review.stars),
              const Spacer(),
              Text(
                '${review.author} · ${review.date}',
                style: const TextStyle(fontSize: 13, color: AppColors.ink3),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < count; i++)
          const Icon(Icons.star, size: 17, color: AppColors.accent),
      ],
    );
  }
}
