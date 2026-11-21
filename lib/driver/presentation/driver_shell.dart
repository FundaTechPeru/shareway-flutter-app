import 'package:flutter/material.dart';

import '../data/driver_api_repository.dart';
import '../domain/driver_api_models.dart';
import '../../shared/presentation/notifications_screen.dart';
import '../../shared/presentation/support_screen.dart';
import '../../shared/widgets/shareway_components.dart';
import 'driver_controller.dart';
import 'driver_home_screen.dart';
import 'connected_driver_home_screen.dart';
import 'connected_driver_trips_screen.dart';
import 'driver_profile_screen.dart';
import 'driver_proposals_screen.dart';
import 'driver_trips_screen.dart';

class DriverShell extends StatefulWidget {
  const DriverShell({
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
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _selectedIndex = 0;

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NotificationsScreen()),
    );
  }

  void _openSupport() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const SupportScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      if (widget.apiRepository == null)
        DriverHomeScreen(
          controller: widget.controller,
          onOpenProposals: () => setState(() => _selectedIndex = 1),
          driverName: widget.account?.fullName,
          driverStatus: widget.account?.driverStatus,
        )
      else
        ConnectedDriverHomeScreen(
          account: widget.account!,
          repository: widget.apiRepository!,
          onOpenProfile: () => setState(() => _selectedIndex = 3),
          onOpenProposals: () => setState(() => _selectedIndex = 1),
        ),
      DriverProposalsScreen(
        controller: widget.controller,
        isConnected: widget.apiRepository != null,
      ),
      if (widget.apiRepository == null)
        DriverTripsScreen(controller: widget.controller)
      else
        ConnectedDriverTripsScreen(repository: widget.apiRepository!),
      DriverProfileScreen(
        controller: widget.controller,
        account: widget.account,
        apiRepository: widget.apiRepository,
        onSignOut: widget.onSignOut,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const ShareWayWordmark(compact: true),
        actions: [
          IconButton(
            tooltip: 'Avisos',
            onPressed: _openNotifications,
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            tooltip: 'Ayuda y soporte',
            onPressed: _openSupport,
            icon: const Icon(Icons.help_outline_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (widget.apiRepository != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                color: const Color(0xFFFFF1D1),
                child: const Text(
                  'Conectado al Gateway: perfil, documentos, vehículo, horario y viajes. Propuestas: integración pendiente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF795000), fontSize: 11),
                ),
              ),
            Expanded(
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) =>
                    IndexedStack(index: _selectedIndex, children: pages),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.alt_route_outlined),
            selectedIcon: Icon(Icons.alt_route_rounded),
            label: 'Propuestas',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Viajes',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
