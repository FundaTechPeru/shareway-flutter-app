import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import 'views/home/home_screen.dart';
import 'views/notifications/notifications_screen.dart';
import 'views/profile/profile_screen.dart';
import 'views/trips/trips_screen.dart';

/// Expone el control de las pestañas del [PassengerShell] a sus descendientes.
class PassengerShellScope extends InheritedWidget {
  const PassengerShellScope({
    super.key,
    required this.goToTab,
    required super.child,
  });

  /// Cambia a la pestaña indicada (0 Inicio, 1 Mis viajes, 2 Avisos, 3 Perfil).
  final void Function(int index) goToTab;

  static PassengerShellScope of(BuildContext context) {
    final PassengerShellScope? scope = context
        .dependOnInheritedWidgetOfExactType<PassengerShellScope>();
    assert(scope != null, 'PassengerShellScope no está sobre el contexto.');
    return scope!;
  }

  @override
  bool updateShouldNotify(PassengerShellScope oldWidget) =>
      goToTab != oldWidget.goToTab;
}

/// Contenedor con la barra inferior de pasajero.
class PassengerShell extends StatefulWidget {
  const PassengerShell({
    super.key,
    this.initialTab = 0,
    this.emptyHome = false,
  });

  static const String routeName = '/passenger';

  /// Pestaña con la que arranca el shell (0 Inicio, 1 Mis viajes, ...).
  final int initialTab;

  /// Muestra el inicio en su estado vacío PAS-E1.
  final bool emptyHome;

  @override
  State<PassengerShell> createState() => _PassengerShellState();
}

class _PassengerShellState extends State<PassengerShell> {
  late int _index = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    return PassengerShellScope(
      goToTab: (index) => setState(() => _index = index),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _index,
          children: [
            HomeScreen(emptyRoutes: widget.emptyHome),
            const TripsScreen(),
            NotificationsScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: _PassengerNavBar(
          index: _index,
          onChanged: (index) => setState(() => _index = index),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

const List<_NavItem> _items = [
  _NavItem(
    label: 'Inicio',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
  ),
  _NavItem(
    label: 'Mis viajes',
    icon: Icons.list_alt_outlined,
    activeIcon: Icons.list_alt,
  ),
  _NavItem(
    label: 'Avisos',
    icon: Icons.notifications_outlined,
    activeIcon: Icons.notifications,
  ),
  _NavItem(
    label: 'Perfil',
    icon: Icons.person_outline,
    activeIcon: Icons.person,
  ),
];

class _PassengerNavBar extends StatelessWidget {
  const _PassengerNavBar({
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (int i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavBarItem(
                    item: _items[i],
                    selected: i == index,
                    onTap: () => onChanged(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color foreground =
        selected ? AppColors.primary : AppColors.ink3;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primarySoft
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              selected ? item.activeIcon : item.icon,
              size: 23,
              color: foreground,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11.5,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
