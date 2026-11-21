import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';
import '../data/driver_api_repository.dart';
import '../domain/driver_api_models.dart';

class ConnectedDriverHomeScreen extends StatefulWidget {
  const ConnectedDriverHomeScreen({
    super.key,
    required this.account,
    required this.repository,
    required this.onOpenProfile,
    required this.onOpenProposals,
  });

  final DriverAccountSnapshot account;
  final DriverApiRepository repository;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenProposals;

  @override
  State<ConnectedDriverHomeScreen> createState() =>
      _ConnectedDriverHomeScreenState();
}

class _ConnectedDriverHomeScreenState extends State<ConnectedDriverHomeScreen> {
  _DriverOverview? _overview;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOverview();
  }

  Future<void> _loadOverview() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final values = await Future.wait<Object>([
        widget.repository.listVehicles(),
        widget.repository.listDocuments(),
        widget.repository.getAvailability(),
      ]);
      if (!mounted) return;
      setState(() {
        _overview = _DriverOverview(
          vehicles: values[0] as List<DriverVehicleData>,
          documents: values[1] as List<DriverDocumentData>,
          availability: values[2] as List<WeeklyAvailabilitySlot>,
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'No pudimos actualizar tus datos del Gateway.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    final overview = _overview;
    final firstName = account.fullName.trim().split(RegExp(r'\s+')).first;
    final verified = account.isVerified;

    return RefreshIndicator(
      onRefresh: _loadOverview,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Hola, ${firstName.isEmpty ? 'conductor' : firstName}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton(
                tooltip: 'Actualizar datos',
                onPressed: _loading ? null : _loadOverview,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.cloud_done_rounded,
                color: ShareWayColors.success,
                size: 16,
              ),
              const SizedBox(width: 6),
              const Text(
                'Cuenta conectada al API Gateway',
                style: TextStyle(
                  color: ShareWayColors.secondaryInk,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estado de tu cuenta',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        verified
                            ? Icons.verified_rounded
                            : Icons.schedule_rounded,
                        color: verified
                            ? ShareWayColors.success
                            : ShareWayColors.warning,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          verified
                              ? 'Conductor habilitado'
                              : 'Verificación pendiente',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: widget.onOpenProfile,
                        child: const Text('Ver perfil'),
                      ),
                    ],
                  ),
                  if (!verified) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Completa la carga de documentos y espera la revisión para habilitar tu cuenta.',
                      style: TextStyle(
                        color: ShareWayColors.secondaryInk,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_loading) const LinearProgressIndicator(),
          if (_error case final error?) ...[
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.cloud_off_rounded,
                  color: ShareWayColors.error,
                ),
                title: Text(error, style: const TextStyle(fontSize: 12)),
                trailing: IconButton(
                  tooltip: 'Reintentar',
                  onPressed: _loadOverview,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (overview != null) ...[
            Text(
              'Tus datos sincronizados',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _OverviewRow(
                    icon: Icons.directions_car_filled_rounded,
                    title: 'Vehículo',
                    value: overview.vehicleLabel,
                    onTap: widget.onOpenProfile,
                  ),
                  const Divider(height: 1, indent: 54),
                  _OverviewRow(
                    icon: Icons.description_outlined,
                    title: 'Documentos',
                    value: overview.documentLabel,
                    onTap: widget.onOpenProfile,
                  ),
                  const Divider(height: 1, indent: 54),
                  _OverviewRow(
                    icon: Icons.calendar_month_outlined,
                    title: 'Horario semanal',
                    value: overview.availabilityLabel,
                    onTap: widget.onOpenProfile,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: widget.onOpenProfile,
            icon: const Icon(Icons.manage_accounts_outlined),
            label: const Text('Gestionar mi cuenta'),
          ),
          const SizedBox(height: 14),
          Card(
            color: ShareWayColors.primarySoft,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Propuestas y viajes',
                    style: TextStyle(
                      color: ShareWayColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'El Gateway aún no ofrece una bandeja de propuestas ni viajes asignados al conductor. No mostramos aquí datos de demostración.',
                    style: TextStyle(
                      color: ShareWayColors.secondaryInk,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: widget.onOpenProposals,
                      child: const Text('Ver estado'),
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

class _OverviewRow extends StatelessWidget {
  const _OverviewRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: ShareWayColors.primary),
    title: Text(title, style: const TextStyle(fontSize: 12)),
    subtitle: Text(value, style: const TextStyle(fontSize: 11)),
    trailing: const Icon(Icons.chevron_right_rounded, size: 19),
    onTap: onTap,
  );
}

class _DriverOverview {
  const _DriverOverview({
    required this.vehicles,
    required this.documents,
    required this.availability,
  });

  final List<DriverVehicleData> vehicles;
  final List<DriverDocumentData> documents;
  final List<WeeklyAvailabilitySlot> availability;

  String get vehicleLabel {
    if (vehicles.isEmpty) return 'Aún no hay un vehículo registrado';
    final vehicle = vehicles.first;
    return '${vehicle.brand} ${vehicle.model} ${vehicle.year} · ${vehicle.plate}';
  }

  String get documentLabel {
    if (documents.isEmpty) return 'Aún no hay documentos cargados';
    final pending = documents
        .where((document) => document.status == 'PENDING')
        .length;
    final approved = documents
        .where((document) => document.status == 'APPROVED')
        .length;
    final rejected = documents
        .where((document) => document.status == 'REJECTED')
        .length;
    return '${documents.length} cargados · $approved aprobados · $pending en revisión${rejected == 0 ? '' : ' · $rejected rechazados'}';
  }

  String get availabilityLabel => availability.isEmpty
      ? 'Aún no hay franjas registradas'
      : '${availability.length} franjas semanales registradas';
}
