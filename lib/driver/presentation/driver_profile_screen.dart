import 'package:flutter/material.dart';

import '../data/driver_api_repository.dart';
import '../domain/driver_api_models.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/shareway_components.dart';
import 'driver_controller.dart';
import 'driver_setup_screen.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({
    super.key,
    required this.controller,
    this.account,
    this.apiRepository,
    this.onSignOut,
  });

  final DriverController controller;
  final DriverAccountSnapshot? account;
  final DriverApiRepository? apiRepository;
  final Future<void> Function()? onSignOut;

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  List<DriverVehicleData> _vehicles = const [];
  bool _loadingVehicles = false;
  String? _vehicleError;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final repository = widget.apiRepository;
    if (repository == null) return;
    setState(() {
      _loadingVehicles = true;
      _vehicleError = null;
    });
    try {
      final vehicles = await repository.listVehicles();
      if (!mounted) return;
      setState(() => _vehicles = vehicles);
    } catch (_) {
      if (!mounted) return;
      setState(() => _vehicleError = 'No se pudo cargar el vehículo.');
    } finally {
      if (mounted) setState(() => _loadingVehicles = false);
    }
  }

  Future<void> _openSetup(BuildContext context, int step) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => DriverSetupScreen(
          initialStep: step,
          apiRepository: widget.apiRepository,
          account: widget.account,
          onSaved: _loadVehicles,
        ),
      ),
    );
    if (mounted) _loadVehicles();
  }

  Future<void> _signOut() async {
    if (widget.onSignOut == null) {
      _showMessage(context, 'Cerrar sesión');
      return;
    }
    await widget.onSignOut!();
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    final isRemote = widget.apiRepository != null;
    final vehicle = _vehicles.isEmpty ? null : _vehicles.first;
    final statusColor = account?.isVerified == false
        ? ShareWayColors.warning
        : ShareWayColors.success;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: ShareWayColors.primarySoft,
                  child: Text(
                    account?.initials ?? 'CH',
                    style: TextStyle(
                      color: ShareWayColors.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account?.fullName ?? 'Carlos Huamán Quispe',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account == null
                            ? '★ 4.8 · 312 viajes'
                            : account.isVerified
                            ? 'Conductor verificado'
                            : 'Pendiente de verificación',
                        style: TextStyle(color: statusColor, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _openSetup(context, 0),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: _loadingVehicles
              ? const ListTile(
                  leading: IconTile(icon: Icons.directions_car_filled_rounded),
                  title: Text('Cargando vehículo…'),
                )
              : vehicle == null && isRemote
              ? ListTile(
                  leading: const IconTile(
                    icon: Icons.directions_car_filled_rounded,
                  ),
                  title: const Text('Aún no registras un vehículo'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _openSetup(context, 2),
                )
              : ListTile(
                  leading: const IconTile(
                    icon: Icons.directions_car_filled_rounded,
                  ),
                  title: Text(
                    vehicle == null
                        ? 'Toyota Yaris 2019'
                        : '${vehicle.brand} ${vehicle.model} ${vehicle.year}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    vehicle == null
                        ? 'Gris plata · 4 asientos'
                        : '${vehicle.color} · ${vehicle.seats} asientos',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: Text(
                    vehicle?.plate ?? 'BKL-482',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () => _openSetup(context, 2),
                ),
        ),
        if (_vehicleError != null) ...[
          const SizedBox(height: 6),
          TextButton.icon(
            onPressed: _loadVehicles,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(_vehicleError!),
          ),
        ],
        const SizedBox(height: 15),
        Card(
          child: Column(
            children: [
              _ProfileOption(
                icon: Icons.edit_outlined,
                label: 'Editar perfil y vehículo',
                onTap: () => _openSetup(context, 0),
              ),
              _ProfileOption(
                icon: Icons.verified_user_outlined,
                label: 'Documentos y habilitación',
                trailing: StatusPill(
                  label: account == null
                      ? 'Habilitado'
                      : account.isVerified
                      ? 'Habilitado'
                      : 'En revisión',
                  color: statusColor,
                ),
                onTap: () => _openSetup(context, 1),
              ),
              _ProfileOption(
                icon: Icons.calendar_month_outlined,
                label: 'Disponibilidad y horarios',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DriverAvailabilityScreen(
                      repository: widget.apiRepository,
                    ),
                  ),
                ),
              ),
              _ProfileOption(
                icon: Icons.show_chart_rounded,
                label: 'Historial y ganancias',
                onTap: () => _showMessage(context, 'Historial de ganancias'),
              ),
              _ProfileOption(
                icon: Icons.shield_outlined,
                label: 'Contacto de emergencia',
                onTap: () => _showMessage(context, 'Contacto de emergencia'),
              ),
              _ProfileOption(
                icon: Icons.help_outline_rounded,
                label: 'Ayuda y soporte',
                onTap: () => _showMessage(context, 'Ayuda y soporte'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _signOut,
          icon: const Icon(Icons.logout_rounded, color: ShareWayColors.error),
          label: const Text(
            'Cerrar sesión',
            style: TextStyle(color: ShareWayColors.error),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isRemote
              ? 'Perfil y vehículo sincronizados con ShareWay.'
              : 'Perfil y vehículo de demostración.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: ShareWayColors.muted, fontSize: 11),
        ),
      ],
    );
  }

  static void _showMessage(BuildContext context, String name) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name se conectará con el servicio de conductores.'),
        ),
      );
}

class DriverAvailabilityScreen extends StatefulWidget {
  const DriverAvailabilityScreen({super.key, this.repository});

  final DriverApiRepository? repository;

  @override
  State<DriverAvailabilityScreen> createState() =>
      _DriverAvailabilityScreenState();
}

class _DriverAvailabilityScreenState extends State<DriverAvailabilityScreen> {
  final _days = <String, bool>{
    'L': true,
    'M': true,
    'X': true,
    'J': true,
    'V': true,
    'S': false,
    'D': false,
  };
  final _zones = <String>{'Lince', 'Jesús María', 'San Isidro'};
  bool _morning = true;
  bool _afternoon = false;
  bool _loading = false;
  bool _saving = false;
  String? _error;
  bool _hasCustomSlots = false;
  bool _confirmReplaceCustomSlots = false;
  String? _customSlotSummary;

  static const _apiDayNames = {
    'L': 'MONDAY',
    'M': 'TUESDAY',
    'X': 'WEDNESDAY',
    'J': 'THURSDAY',
    'V': 'FRIDAY',
    'S': 'SATURDAY',
    'D': 'SUNDAY',
  };

  @override
  void initState() {
    super.initState();
    if (widget.repository != null) _loadRemoteAvailability();
  }

  Future<void> _loadRemoteAvailability() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final slots = await widget.repository!.getAvailability();
      if (!mounted) return;
      setState(() {
        for (final key in _days.keys.toList()) {
          _days[key] = false;
        }
        _morning = false;
        _afternoon = false;
        _hasCustomSlots = false;
        _confirmReplaceCustomSlots = false;
        _customSlotSummary = null;
        final customTimes = <String>[];
        for (final slot in slots) {
          String? key;
          for (final entry in _apiDayNames.entries) {
            if (entry.value == slot.dayOfWeek) {
              key = entry.key;
              break;
            }
          }
          if (key != null) {
            _days[key] = true;
          }
          final start = slot.startTime.length >= 5
              ? slot.startTime.substring(0, 5)
              : slot.startTime;
          final end = slot.endTime.length >= 5
              ? slot.endTime.substring(0, 5)
              : slot.endTime;
          if (start == '06:30' && end == '09:30') {
            _morning = true;
          } else if (start == '17:00' && end == '20:00') {
            _afternoon = true;
          } else {
            _hasCustomSlots = true;
            customTimes.add('${slot.dayOfWeek} $start–$end');
          }
        }
        if (customTimes.isNotEmpty) {
          _customSlotSummary = customTimes.join(', ');
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'No se pudo cargar la disponibilidad.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    final repository = widget.repository;
    if (repository == null) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Disponibilidad guardada en esta demostración.'),
        ),
      );
      return;
    }
    if (_hasCustomSlots && !_confirmReplaceCustomSlots) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final slots = <WeeklyAvailabilitySlot>[];
      for (final entry in _days.entries.where((entry) => entry.value)) {
        final day = _apiDayNames[entry.key]!;
        if (_morning) {
          slots.add(
            WeeklyAvailabilitySlot(
              dayOfWeek: day,
              startTime: '06:30',
              endTime: '09:30',
            ),
          );
        }
        if (_afternoon) {
          slots.add(
            WeeklyAvailabilitySlot(
              dayOfWeek: day,
              startTime: '17:00',
              endTime: '20:00',
            ),
          );
        }
      }
      await repository.saveAvailability(slots);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Disponibilidad sincronizada.')),
      );
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'No se pudo guardar. Revisa la conexión e inténtalo otra vez.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Disponibilidad')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      children: [
        if (_loading) const LinearProgressIndicator(),
        if (_error != null)
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.error_outline_rounded,
                color: ShareWayColors.error,
              ),
              title: Text(_error!, style: const TextStyle(fontSize: 12)),
              trailing: IconButton(
                onPressed: _loadRemoteAvailability,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ),
          ),
        Text(
          'Días en los que conduces',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: _days.entries
              .map(
                (entry) => FilterChip(
                  label: Text(entry.key),
                  selected: entry.value,
                  onSelected: (value) =>
                      setState(() => _days[entry.key] = value),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        Text(
          'Franjas horarias',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                value: _morning,
                onChanged: (value) => setState(() => _morning = value),
                activeTrackColor: ShareWayColors.primary,
                title: const Text(
                  '6:30 a. m. a 9:30 a. m.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Mañana', style: TextStyle(fontSize: 11)),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                value: _afternoon,
                onChanged: (value) => setState(() => _afternoon = value),
                activeTrackColor: ShareWayColors.primary,
                title: const Text(
                  '5:00 p. m. a 8:00 p. m.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Tarde', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (widget.repository == null) ...[
          Text(
            'Zonas donde recoges pasajeros',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 2,
            children: [
              for (final zone in [
                'Lince',
                'Jesús María',
                'San Isidro',
                'Miraflores',
                'Surco',
              ])
                FilterChip(
                  label: Text(zone),
                  selected: _zones.contains(zone),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _zones.add(zone);
                    } else {
                      _zones.remove(zone);
                    }
                  }),
                ),
            ],
          ),
        ] else ...[
          if (_hasCustomSlots) ...[
            const SizedBox(height: 12),
            Card(
              child: CheckboxListTile(
                value: _confirmReplaceCustomSlots,
                onChanged: (value) =>
                    setState(() => _confirmReplaceCustomSlots = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Reemplazar horarios personalizados',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _customSlotSummary == null
                      ? 'El horario existente usa franjas diferentes.'
                      : _customSlotSummary!,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          const Text(
            'Este servicio guarda días y horarios. La selección de zonas todavía no está disponible en su API.',
            style: TextStyle(color: ShareWayColors.muted, fontSize: 11),
          ),
        ],
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed:
              _saving ||
                  _loading ||
                  (_hasCustomSlots && !_confirmReplaceCustomSlots)
              ? null
              : _save,
          icon: const Icon(Icons.save_outlined),
          label: Text(_saving ? 'Guardando…' : 'Guardar disponibilidad'),
        ),
      ],
    ),
  );
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: ShareWayColors.secondaryInk, size: 19),
    title: Text(label, style: const TextStyle(fontSize: 12)),
    trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 18),
    onTap: onTap,
    dense: true,
  );
}
