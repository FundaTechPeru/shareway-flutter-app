import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import 'recurring_trip_form_screen.dart';

/// PAS-18 · Mis viajes recurrentes (pestaña "Recurrentes")
class RecurringTripsTab extends StatefulWidget {
  const RecurringTripsTab({super.key});

  @override
  State<RecurringTripsTab> createState() => _RecurringTripsTabState();
}

class _RecurringTripsTabState extends State<RecurringTripsTab> {
  bool _active1 = true;
  bool _active2 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            children: [
              _RecurringCard(
                from: 'Lince',
                to: 'San Isidro',
                schedule: 'Lun a vie · 7:00 a 8:00 a. m.',
                active: _active1,
                statusLabel: _active1 ? 'Activo' : 'En pausa',
                statusNote: _active1
                    ? 'Próxima solicitud: lun 12 oct'
                    : 'Sin solicitudes nuevas desde el 3 oct',
                onToggle: (value) => setState(() => _active1 = value),
                onEdit: () => Navigator.of(context)
                    .pushNamed(RecurringTripFormScreen.routeName),
                onDelete: () {},
              ),
              const SizedBox(height: 14),
              _RecurringCard(
                from: 'Lince',
                to: 'Monterrico',
                schedule: 'Sábados · 8:30 a 9:30 a. m.',
                active: _active2,
                statusLabel: _active2 ? 'Activo' : 'En pausa',
                statusNote: _active2
                    ? 'Próxima solicitud: sáb 17 oct'
                    : 'Sin solicitudes nuevas desde el 3 oct',
                onToggle: (value) => setState(() => _active2 = value),
                onEdit: () => Navigator.of(context)
                    .pushNamed(RecurringTripFormScreen.routeName),
                onDelete: () {},
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
                      'Si pausas o eliminas un viaje recurrente, dejamos de '
                      'crear solicitudes nuevas. Las reservas ya confirmadas '
                      'no cambian.',
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context)
                  .pushNamed(RecurringTripFormScreen.routeName),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                textStyle: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Nuevo viaje recurrente'),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecurringCard extends StatelessWidget {
  const _RecurringCard({
    required this.from,
    required this.to,
    required this.schedule,
    required this.active,
    required this.statusLabel,
    required this.statusNote,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final String from;
  final String to;
  final String schedule;
  final bool active;
  final String statusLabel;
  final String statusNote;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$from → $to',
                    style: AppTypography.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Switch(
                  value: active,
                  onChanged: onToggle,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: AppColors.borderStrong,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            child: Row(
              children: [
                const Icon(Icons.repeat, size: 16, color: AppColors.ink2),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    schedule,
                    style: AppTypography.support.copyWith(
                      color: AppColors.ink2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.successSoft
                        : AppColors.surface2,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    statusLabel,
                    style: AppTypography.label.copyWith(
                      fontWeight: FontWeight.w600,
                      color: active ? AppColors.success : AppColors.ink2,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    statusNote,
                    style: AppTypography.support.copyWith(
                      color: AppColors.ink3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Editar'),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    textStyle: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Eliminar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
